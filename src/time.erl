-module(time).
-author("hossameldeen").

%% API
-export([swedish_date/0]).

swedish_date() ->
  {Y, M, D} = date(),
  YMDIntegers = [Y rem 100, M, D],
  YMDLists = lists:map(fun(I) -> integer_to_list(I) end, YMDIntegers),
  YMDFixedLength = lists:map(fun(L) -> makeSize(L, 2) end, YMDLists),
  lists:flatten(YMDFixedLength).

% No need to optimize it, expected input is small.
makeSize(L, Size)
  when Size =:= length(L) ->
  L;
makeSize(L, Size)
  when Size < length(L) ->
  error('makeSize only makes a list bigger, or I made some other error.');
makeSize(L, Size) ->
  makeSize([$0|L], Size).
