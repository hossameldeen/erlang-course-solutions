%%%-------------------------------------------------------------------
%%% Assumed spec:
%%%
%%%-------------------------------------------------------------------
-module(concurrency2).
-author("hossameldeen").

%% API
-export([start/3, start_testing/0]).

% Fact has it that the behaviour of all the ring processes are not the same. Mainly, the behaviour of an initiator is
% not the same behaviour as all other nodes'; all others receive then send M times, but the initiator sends then
% receives M times. Another way to put it: A normal node dies after its last send, but the initiator dies after its last
% send. So, better to make a function for each of them.
%
% Another question to be asked: How should the wiring be done? There're at least 2 options:
% 1- First, create all nodes. Then send to ALL nodes their wiring. Then tell initiator to begin sending.
% 2- First, create initiator. Then, create second node pointing to the initiator, third pointing to the second, ... etc.
%    Then, send a message to initiator with the last's id & telling it to begin sending.
% Will go with (2), because it reduces the special behaviour in normal nodes
%
% Also, should intermediate nodes have knowledge of the M, or should it just be told either to "pass & live" or
% "pass & die"?
% I think I'll go with them being oblivious node, to reduce the possibility of inconsistency between nodes in round
% number.
%
% Finally, there's a last question to be asked on the problem's description itself: should a process die after it's sent
% all the messages or it needs to send, OR should it die after all messages in the system have been sent? I'll assume
% the required behaviour is the former, since probably implementing the later will require one more round of terminating
% messages.

% Also, tested cases of N_proc=1 & M_rounds = 0
start_testing() ->
  start(4, 3, hamada).

% N_procs >= 1, M_rounds >= 0.
start(N_procs, M_rounds, Msg) ->
  Initiator_pid = spawn(fun() -> initiator(M_rounds, Msg) end),
  Last_pid = create_linked_list(Initiator_pid, N_procs - 1),
  Initiator_pid ! {wire_and_start, Last_pid}.

create_linked_list(Prev_pid, 0) ->
  Prev_pid;
create_linked_list(Prev_pid, N_procs) ->
  Cur_pid = spawn(fun() -> intermediate(Prev_pid) end),
  create_linked_list(Cur_pid, N_procs - 1).

initiator(M_rounds, Msg) ->
  receive
    {wire_and_start, Last_pid} ->
      initiator_running(M_rounds, Msg, Last_pid)
  end.

% Sends, then receives. Does that M times.
initiator_running(0, _, _) ->
  true;
initiator_running(M_rounds, Msg, Last_pid) ->
  Last_pid ! {
    if M_rounds > 1 -> live;
      true -> die end,
    Msg},
  io:fwrite("Process ~w sent ~w to process ~w~n", [self(), Msg, Last_pid]),
  receive
    {_, Msg} ->
      % io:fwrite("Process ~w received ~w~n", [self(), Msg]), % Log is clearer with receive printing removed
      initiator_running(M_rounds - 1, Msg, Last_pid)
  end.

intermediate(Prev_pid) ->
  receive
    {live, Msg} ->
      % io:fwrite("Process ~w received ~w~n", [self(), Msg]), % Log is clearer with receive printing removed
      Prev_pid ! {live, Msg},
      io:fwrite("Process ~w sent ~w to process ~w~n", [self(), Msg, Prev_pid]),
      intermediate(Prev_pid);
    {die, Msg} ->
      % io:fwrite("Process ~w received ~w~n", [self(), Msg]), % Log is clearer with receive printing removed
      Prev_pid ! {die, Msg},
      io:fwrite("Process ~w sent ~w to process ~w~n", [self(), Msg, Prev_pid])
  end.
