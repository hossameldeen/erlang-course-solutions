-module(lists1).
-author("hossameldeen").

%% API
-export([min_max/1, min/1, max/1]).

min_max(L) ->
  {min(L), max(L)}.

% Undefined for empty lists.
min([H|T]) ->
  min(T, H).

% Undefined for empty lists.
max([H|T]) ->
  max(T, H).

% Tail-recursion.
min([H|T], Res) ->
  MinTillNow = if H < Res -> H; true -> Res end,
  case T of
    [] -> MinTillNow;
    [_|T2] -> min(T2, MinTillNow)
  end.

% Tail-recursion.
max([H|T], Res) ->
  MaxTillNow = if H > Res -> H; true -> Res end,
  case T of
    [] -> MaxTillNow;
    [_|T2] -> max(T2, MaxTillNow)
  end.

%% EUnit Test
-include_lib("eunit/include/eunit.hrl").

convert_test() ->
  ?assertEqual({1, 10}, min_max([4,1,7,3,9,10])).