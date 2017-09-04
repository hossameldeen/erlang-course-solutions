-module(temp).
-author("hossameldeen").

%% API
-export([convert/1]).

convert({c, C}) ->
  {f, c2f(C)};
convert({f, F}) ->
  {c, f2c(F)}.

c2f(C) ->
  9 / 5 * C + 32.

f2c(F) ->
  5 * (F - 32) / 9.

%% EUnit Test
-include_lib("eunit/include/eunit.hrl").

convert_test() ->
  % Yup, kind-of cheating. The webpage says it should return ...212}, NOT ...212.0}.
  % All kinds of specs are possible (accept integers only, accept anything, .. etc) but don't know which is wanted.
  ?assertEqual({f,212.0}, convert({c,100})),
  ?assertEqual({c,0.0}, convert({f,32})).
