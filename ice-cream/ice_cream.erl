%% My solution for https://www.hackerrank.com/challenges/icecream-parlor
-module(ice_cream).
-export([drive/0]).

drive() -> read_stdin().
%%drive() -> read_file("test.txt").

read_file(Filename) ->
  {ok, File} = file:open(Filename, read),
  io:get_line(File, ""), %% First line of file is not needed
  read_input(File),
  file:close(File).
read_stdin() ->
  io:get_line(standard_io, ""),
  read_input(standard_io).
read_input(Device) ->
  case io:get_line(Device, "") of
    eof -> io:format("All done!~n");
    M -> N = io:get_line(Device, ""),
         Vals = io:get_line(Device, ""),
         io:format("Running ice cream problem on ~n M = ~p~n N = ~p~n Vals = ~p~n", [M,N,Vals]),
         read_input(Device)
  end.

%% M is total dollar amount
%% List is a list of ids mapped to dollar values in format {id, val}
%%find_ice_cream(M, L) ->
%%  List = lists:sort(fun({_,A},{_,B}) -> A =< B end, L),
%%  [Target | Rest] = List,
%%  Target.
%%
%%binary_search(Target, List) ->
%%  {P1, P2} = lists:split(length(List) div 2, List).
