-module(concurrency1_ping_pong).
-author("hossameldeen").

%% API
-export([ping_pong/2]).

ping_pong(M, Msg) ->
  RightPid = spawn(fun() -> right(M, Msg) end),
  spawn(fun() -> left(M, Msg, RightPid) end).

% At first, I tried to model them using only one function/actor type. However, actually, their behaviour is different
% , beside the "who starts" part. The other difference is that one of the actors, after sending its last message, needs
% to wait the last message in the system before it terminates, or else the message won't be received.
% So, anyway, I've decided to go with another model that still has the same effect required. The model is as follows:
% Actor-left:
%  - Sends a message.
%  - Waits its response.
%  - If M > 0, send other message. Otherwise, terminate.
% Actor-right:
%  - Just a bouncer.
%  - Knows that it should end after it's bounced M times.
% Actually, could've made the wiring in a step other than the creation, but nvm. And yes, some stuff like aren't needed,
% like Msg for right, ... etc.
%
% Lesson learned: Don't think of a system flow. Think of a specification for each actor, whose combined behaviours
% produce the required behaviour of the system.
%
% And I probably won't stay in this hell for long. There must be a better way to write the code. Elm type system or
% even Scala's case classes & Actor class seem better. (Yup, can implement state machine, but nvm).

left(0, _, _) ->
  true;
left(M, Msg, Right) ->
  io:fwrite("left will send~n"),
  Right ! {self(), Msg},
  receive
    {Right, Msg} ->
      io:fwrite("left received~n"),
      left(M - 1, Msg, Right)
  end.

right(0, _) ->
  true;
right(M, Msg) ->
  receive
    {Left, Msg} ->
      io:fwrite("right received & will send~n"),
      Left ! {self(), Msg}
  end,
  right(M - 1, Msg).
