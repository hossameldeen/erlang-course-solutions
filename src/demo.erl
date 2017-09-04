-module(demo).
-author("hossameldeen").

%% API
-export([double/1]).

double(X) ->
  X * 2.

%% EUnit Test
-include_lib("eunit/include/eunit.hrl").

double_test() ->
  ?assert(double(12) =:= 24),
  ?assert(double(0) =:= 0),
  ?assert(double(111111111111111111111) =:= 222222222222222222222),
  ?assert(double(1.0) =:= 2.0).
