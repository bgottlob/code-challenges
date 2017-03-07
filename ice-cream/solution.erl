%% My solution for https://www.hackerrank.com/challenges/icecream-parlor
-module(solution).
-export([main/0]).

main() -> read_stdin().
%%main() -> read_file("test.txt").

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
    eof -> ok;
    MLine -> io:get_line(Device, ""), %% N is not needed
             {M, _} = string:to_integer(MLine),
             {Vals, _} = lists:mapfoldl(
                      fun(Str, Ct) ->
                          {Int, _} = string:to_integer(Str),
                          {{Ct, Int}, Ct + 1} end,
                      1, string:tokens(io:get_line(Device, ""), " \n")
                     ),
             find_ice_cream(M, Vals),
             read_input(Device)
  end.

%% M is total dollar amount
%% List is a list of ids mapped to dollar values in format {id, val}
find_ice_cream(M, L) ->
  List = lists:sort(fun({_,A},{_,B}) -> A =< B end, L),
  find_ice_cream(M, List, List).
find_ice_cream(_, _, []) -> io:format("No solution found");
find_ice_cream(M, All, [Curr|Rest]) ->
  {CurrId, CurrVal} = Curr,
  TgtVal = M - CurrVal,
  case binary_search(TgtVal, lists:delete(Curr, All)) of
    false -> find_ice_cream(M, All, Rest);
    TgtId ->
      if CurrId < TgtId -> io:format("~p ~p~n", [CurrId, TgtId]);
         TgtId < CurrId -> io:format("~p ~p~n", [TgtId, CurrId]);
         CurrId == TgtId -> io:format("Something went wrong, ids are equal~n")
      end
  end.

ceil(X) ->
  T = trunc(X),
  case X > T of
    true -> T + 1;
    false -> T
  end.

binary_search(_,[]) -> false;
binary_search(Target, List) ->
  %%io:format("Searching ~p for ~p~n", [List, Target]),
  %% Ceiling guarantees our pivot element will be the last one in P1
  %% Since List won't be empty, the smallest P will be 1, putting one element
  %% in P1
  P = ceil(length(List) / 2),
  {P1, P2} = lists:split(P, List),
  case length(P1) of
    0 -> false;
    _ -> {PivId, PivVal} = lists:last(P1),
         if Target == PivVal -> PivId;
            Target > PivVal -> binary_search(Target, P2);
            Target < PivVal -> binary_search(Target, lists:droplast(P1))
         end
  end.
