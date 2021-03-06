-module(ms).
-author("hossameldeen").

%% API
-export([start/1, to_slave/2]).


start(N) ->
  Master_pid = spawn(fun() -> master(init, N) end),
  register(master, Master_pid).

to_slave(Message, N) ->
  master ! {Message, N}.

%-------------------------------------------------------------------------------
% master
master(init, N) ->
  process_flag(trap_exit, true),
  One_to_N = lists:seq(1, N),
  Slaves_pids = lists:map(fun(I) -> start_slave(I) end, One_to_N),
  N_to_pid = maps:from_list(lists:zip(One_to_N, Slaves_pids)),
  Pid_to_N = maps:from_list(lists:zip(Slaves_pids, One_to_N)),
  master(listening, N_to_pid, Pid_to_N).

master(listening, N_to_pid, Pid_to_N) ->
  % Yes, it's bad that I may forget a `master(...)` at the end of one clause. Have a structure in mind to prevent that
  % but to try it in another problem isA. Same for `slave(...)`
  receive
    {'EXIT', Pid, _} ->
      N = maps:get(Pid, Pid_to_N),
      New_pid = start_slave(N),
      io:fwrite("master restarting dead slave~w~n", [N]),
      master(listening, maps:update(N, New_pid, N_to_pid), maps:put(New_pid, N, maps:remove(Pid, Pid_to_N)));
    {Message, N} ->
      maps:get(N, N_to_pid) ! Message,
      master(listening, N_to_pid, Pid_to_N)
  end.

start_slave(N) ->
  spawn_link(fun() -> slave(N) end).

%-------------------------------------------------------------------------------
% slave
slave(N) ->
  receive
    die ->
      exit(unexpected_crash);
    Msg ->
      io:fwrite("Slave ~w got message ~w~n", [N, Msg]),
      slave(N)
  end.
