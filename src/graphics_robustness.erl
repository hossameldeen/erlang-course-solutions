% Note: Not really a code file to take wx practices from...
% Probably should've learnt about supervision trees before doing this one.
-module(graphics_robustness).
-author("hossameldeen").

%% API
-export([start/0]).

-include_lib("wx/include/wx.hrl").
-include_lib("wx/src/wxe.hrl").


start() ->
%%  Wx = wx:new([{debug, verbose}]),
  Wx = wx:new(),
  Env = wx:get_env(),
  spawn(fun() -> create_window(Wx, Env, none) end).

%-------------------------------------------------------------------------------
create_window(Wx, Env, Parent_pid) ->
  wx:set_env(Env),
  construct(Wx, Parent_pid).

% So the problem was that `wxFrame:show(F)` needed to be called after all the adding done or what?!
construct(Wx, Parent_pid) ->
  process_flag(trap_exit, true),
  F = wxFrame:new(Wx, -1, pid_to_list(self())),
  Panel = wxPanel:new(F),
  Sizer = wxBoxSizer:new(?wxHORIZONTAL),
  Quit_ref = add_button(Panel, Sizer, "Quit"),
  Spawn_ref = add_button(Panel, Sizer,"Spawn"),
  Error_ref = add_button(Panel, Sizer,"Error"),
  wxPanel:setSizer(Panel, Sizer),
  wxFrame:show(F),
  loop(Wx, F, Quit_ref, Spawn_ref, Error_ref, Parent_pid).

loop(Wx, F, Quit_ref, Spawn_ref, Error_ref, Parent_pid) ->
  % Assumes it only receives click events
  receive
    #wx{obj = #wx_ref{ref = Quit_ref}} ->
      wxFrame:destroy(F),
      exit(normal);
    #wx{obj = #wx_ref{ref = Spawn_ref}} ->
      Env = wx:get_env(),
      Self = self(),
      spawn_link(fun() -> create_window(Wx, Env, Self) end);
    #wx{obj = #wx_ref{ref = Error_ref}} ->
      wxFrame:destroy(F),
      exit(error_clicked);
    {'EXIT', Parent_pid, Reason} ->
      wxFrame:destroy(F),
      exit(Reason);
    {'EXIT', _, error_clicked} ->
      Env = wx:get_env(),
      Self = self(),
      spawn_link(fun() -> create_window(Wx, Env, Self) end);
    X -> io:format("Received ~w, parentid=~w~n", [X, Parent_pid])
  end,
  loop(Wx, F, Quit_ref, Spawn_ref, Error_ref, Parent_pid).

add_button(Panel, Sizer, Label) ->
  B = wxButton:new(Panel, -1, [{label, Label}]),
  wxButton:connect(B, command_button_clicked),
  wxSizer:add(Sizer, B),
  wxSizer:addSpacer(Sizer, 20),
  B#wx_ref.ref.