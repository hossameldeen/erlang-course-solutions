-module(mathStuff).
-author("hossameldeen").

%% API
-export([perimeter/1]).

perimeter({square, Side}) ->
  4 * Side;
perimeter({circle, Radius}) ->
  2 * 3 * Radius; % Used pi as 3 instead of math:pi() to preserve integerness or floatness of Radius
perimeter({triangle, A, B, C}) ->
  A + B + C.

%% EUnit Test
-include_lib("eunit/include/eunit.hrl").

convert_test() ->
  % kind-of cheating on float-vs-integer.
  ?assertEqual(20, perimeter({square, 5})),
  ?assertEqual(42, perimeter({circle, 7})),
  ?assertEqual(12, perimeter({triangle, 1, 4, 7})).