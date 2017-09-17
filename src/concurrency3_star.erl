-module(concurrency3_star).
-author("hossameldeen").

%% API
-export([star/3, run_sample/0]).

% Yet another unclear specification. First, `in a star` makes no sense after `starts N processes`. And regardless of
% ignoring or implementing it, the next step would be for the start process to send M messages to them then all die.
%
% Will just assume the specification is as follows is that Heart (the special node in the middle) will ping-pong every
% other node separately. The ping-ponging of nodes will be concurrent with respect to the nodes. I.e., ping-ponging of
% each node will NOT depend on ping-ponging of any other. When a process (other than Heart) has sent M pongs, it should
% die (even before being received by Heart). When Heart has received pong M*(N-1), it should die.
%
% To make something new, this time, unlike in ring, will disallow having extra info in a message, except for processes'
% identifiers. So, all nodes will keep track of M. Will also create them differently.

run_sample() ->
  star(5, hamada, 4).

star(N, Msg, M) ->
  Limbs_pids = lists:map(fun(_) -> spawn(fun() -> limb(M) end) end, lists:seq(1, N - 1)),
  spawn(fun() -> heart(Msg, M, Limbs_pids) end).

heart(_, 0, _) ->
  done;
heart(Msg, M, Limbs_pids) when is_list(Limbs_pids) ->
  Limbs =
    maps:from_list(
      lists:map(  % I hate it when maps aren't pure.
        fun(Pid) -> Pid ! {self(), Msg}, {Pid, 0} end,
        Limbs_pids
      )),
  heart(Msg, M, Limbs);
heart(Msg, M, Limbs) ->
  if
    map_size(Limbs) =:= 0 ->
      ok;
    true ->
      receive
        {Limb_pid, _} ->
          io:fwrite("Process ~w received ~w from ~w~n", [self(), Msg, Limb_pid]),
          Limbs2 = maps:update(Limb_pid, maps:get(Limb_pid, Limbs) + 1, Limbs),
          Limbs3 = case maps:get(Limb_pid, Limbs2) of
                     M ->
                       maps:remove(Limb_pid, Limbs2);
                     _ ->
                       Limb_pid ! {self(), Msg}, Limbs2
                   end,
          heart(Msg, M, Limbs3)
      end
  end.

limb(0) ->
  ok;
limb(M) ->
  receive
    {Heart_pid, Msg} ->
      io:fwrite("Process ~w received ~w from ~w~n", [self(), Msg, Heart_pid]),
      Heart_pid ! {self(), Msg},
      limb(M - 1)
  end.
