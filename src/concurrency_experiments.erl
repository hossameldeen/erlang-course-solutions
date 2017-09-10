-module(concurrency_experiments).
-author("hossameldeen").

%% API
-export([send_die_before_receiving/0, link_dead_process/0, undead_process_test/0]).

%%--------------------------------------------------------------------
send_die_before_receiving() ->
  Receiver_pid = spawn(fun() -> receiver() end),
  spawn(fun() -> sender(Receiver_pid) end).

receiver() ->
  receive
    M -> io:fwrite("received message: ~s", [M])
  end.

sender(Received_pid) ->
  Received_pid ! "hiii".
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
link_dead_process() ->
  Pid_of_1 = spawn(fun() -> process1() end),
  Pid_of_1 ! "hi",
  spawn(fun() -> process2(Pid_of_1) end).

process1() ->
  receive
    _ -> lists:droplast([])
  end.

process2(P1id) ->
  process_flag(trap_exit, true),
  link(P1id),
  receive
    {'EXIT', Pid, Reason} ->
      io:fwrite("Received EXIT Pid=~w, Reason=~w", [Pid, Reason])
  end.
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
% See what will happen in Intellij when an undead process is running.
% Update: found that Intellij's run may terminate although a process
% is still running. So, always need to test from shell to check
% graceful termination.
undead_process_test() ->
  spawn(fun() -> undead_process() end).

undead_process() ->
  receive
    _ -> true
  end.
%%--------------------------------------------------------------------
