%% My solution for https://www.hackerrank.com/challenges/queue-using-two-stacks
-module(solution).
-export([main/0, main_file/1]).

main_file(Filename) -> read_file(Filename).
main() -> read_stdin().

read_file(Filename) ->
  {ok, File} = file:open(Filename, read),
  io:get_line(File, ""), %% First line can be thrown away
  read_input({[], []}, File),
  file:close(File).
read_stdin() ->
  io:get_line(standard_io, ""), %% First line can be thrown away
  read_input({[], []}, standard_io).

%% Queue is a tuple of two lists (behaving as stacks): a dequeue list and
%% an enqueue list -- {Dequeue, Enqueue}
read_input(Q, Device) ->
  case io:get_line(Device, "") of
    eof -> ok;
    L -> case string:tokens(L, " \n") of
           ["1",X|_] -> read_input(enqueue(Q,X), Device);
           ["2"|_] -> read_input(dequeue(Q), Device);
           ["3"|_] -> read_input(print_front(Q), Device)
         end
  end.


enqueue({Deq,Enq}, X) -> {Deq, [X|Enq]}.

%% Empties the enqueue list into the dequeue list
to_deq({Deq,[]}) -> {Deq,[]};
to_deq({Deq,Enq}) ->
  [H|T] = Enq,
  to_deq({[H|Deq],T}).

dequeue({[],[]}) ->
  io:format("Oops, nothing to dequeue!~n"),
  {[],[]};
dequeue({[],Enq}) ->
  dequeue(to_deq({[],Enq}));
dequeue({Deq,Enq}) ->
  [_|T] = Deq,
  {T,Enq}.

print_front({[],[]}) ->
  io:format("Oops, nothing to print!~n"),
  {[],[]};
print_front({[],Enq}) -> print_front(to_deq({[],Enq}));
print_front({Deq,Enq}) ->
  [H|_] = Deq,
  io:format("~s~n", [H]),
  {Deq,Enq}.
