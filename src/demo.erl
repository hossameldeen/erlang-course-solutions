-module(demo).
-author("hossameldeen").

%% API
-export([double/1]).

double(X) ->
  X * 2.

%% EUnit Test
-include_lib("eunit/include/eunit.hrl").

double_test() ->
  ?assertEqual(24, double(12)),
  ?assertEqual(0, double(0)),
  ?assertEqual(222222222222222222222, double(111111111111111111111)),
  ?assertEqual(2.0, double(1.0)).
