-module(elixir_rewrite).
-export([rewrite/6, inline/3]).
-include("elixir.hrl").

-define(is_literal(Arg), (is_binary(Arg) orelse is_number(Arg) orelse is_atom(Arg))).

%% Convenience variables

-define(atom, 'Elixir.Atom').
-define(access, 'Elixir.Access').
-define(enum, 'Elixir.Enum').
-define(io, 'Elixir.IO').
-define(integer, 'Elixir.Integer').
-define(kernel, 'Elixir.Kernel').
-define(list, 'Elixir.List').
-define(list_chars, 'Elixir.List.Chars').
-define(map, 'Elixir.Map').
-define(node, 'Elixir.Node').
-define(port, 'Elixir.Port').
-define(process, 'Elixir.Process').
-define(string, 'Elixir.String').
-define(string_chars, 'Elixir.String.Chars').
-define(system, 'Elixir.System').
-define(tuple, 'Elixir.Tuple').

%% Inline

%% Inline rules are straight-forward, they keep the same
%% number and order of arguments and show up on captures.

inline(?atom, to_charlist, 1) -> {erlang, atom_to_list};
inline(?io, iodata_length, 1) -> {erlang, iolist_size};
inline(?io, iodata_to_binary, 1) -> {erlang, iolist_to_binary};
inline(?integer, to_string, 1) -> {erlang, integer_to_binary};
inline(?integer, to_string, 2) -> {erlang, integer_to_binary};
inline(?integer, to_charlist, 1) -> {erlang, integer_to_list};
inline(?integer, to_charlist, 2) -> {erlang, integer_to_list};
inline(?list, to_atom, 1) -> {erlang, list_to_atom};
inline(?list, to_existing_atom, 1) -> {erlang, list_to_existing_atom};
inline(?list, to_float, 1) -> {erlang, list_to_float};
inline(?list, to_integer, 1) -> {erlang, list_to_integer};
inline(?list, to_integer, 2) -> {erlang, list_to_integer};
inline(?list, to_tuple, 1) -> {erlang, list_to_tuple};

inline(?kernel, '+', 2) -> {erlang, '+'};
inline(?kernel, '-', 2) -> {erlang, '-'};
inline(?kernel, '+', 1) -> {erlang, '+'};
inline(?kernel, '-', 1) -> {erlang, '-'};
inline(?kernel, '*', 2) -> {erlang, '*'};
inline(?kernel, '/', 2) -> {erlang, '/'};
inline(?kernel, '++', 2) -> {erlang, '++'};
inline(?kernel, '--', 2) -> {erlang, '--'};
inline(?kernel, 'not', 1) -> {erlang, 'not'};
inline(?kernel, '<', 2) -> {erlang, '<'};
inline(?kernel, '>', 2) -> {erlang, '>'};
inline(?kernel, '<=', 2) -> {erlang, '=<'};
inline(?kernel, '>=', 2) -> {erlang, '>='};
inline(?kernel, '==', 2) -> {erlang, '=='};
inline(?kernel, '!=', 2) -> {erlang, '/='};
inline(?kernel, '===', 2) -> {erlang, '=:='};
inline(?kernel, '!==', 2) -> {erlang, '=/='};
inline(?kernel, abs, 1) -> {erlang, abs};
inline(?kernel, apply, 2) -> {erlang, apply};
inline(?kernel, apply, 3) -> {erlang, apply};
inline(?kernel, binary_part, 3) -> {erlang, binary_part};
inline(?kernel, bit_size, 1) -> {erlang, bit_size};
inline(?kernel, byte_size, 1) -> {erlang, byte_size};
inline(?kernel, 'div', 2) -> {erlang, 'div'};
inline(?kernel, exit, 1) -> {erlang, exit};
inline(?kernel, hd, 1) -> {erlang, hd};
inline(?kernel, is_atom, 1) -> {erlang, is_atom};
inline(?kernel, is_binary, 1) -> {erlang, is_binary};
inline(?kernel, is_bitstring, 1) -> {erlang, is_bitstring};
inline(?kernel, is_boolean, 1) -> {erlang, is_boolean};
inline(?kernel, is_float, 1) -> {erlang, is_float};
inline(?kernel, is_function, 1) -> {erlang, is_function};
inline(?kernel, is_function, 2) -> {erlang, is_function};
inline(?kernel, is_integer, 1) -> {erlang, is_integer};
inline(?kernel, is_list, 1) -> {erlang, is_list};
inline(?kernel, is_map, 1) -> {erlang, is_map};
inline(?kernel, is_number, 1) -> {erlang, is_number};
inline(?kernel, is_pid, 1) -> {erlang, is_pid};
inline(?kernel, is_port, 1) -> {erlang, is_port};
inline(?kernel, is_reference, 1) -> {erlang, is_reference};
inline(?kernel, is_tuple, 1) -> {erlang, is_tuple};
inline(?kernel, length, 1) -> {erlang, length};
inline(?kernel, make_ref, 0) -> {erlang, make_ref};
inline(?kernel, map_size, 1) -> {erlang, map_size};
inline(?kernel, max, 2) -> {erlang, max};
inline(?kernel, min, 2) -> {erlang, min};
inline(?kernel, node, 0) -> {erlang, node};
inline(?kernel, node, 1) -> {erlang, node};
inline(?kernel, 'rem', 2) -> {erlang, 'rem'};
inline(?kernel, round, 1) -> {erlang, round};
inline(?kernel, self, 0) -> {erlang, self};
inline(?kernel, send, 2) -> {erlang, send};
inline(?kernel, spawn, 1) -> {erlang, spawn};
inline(?kernel, spawn, 3) -> {erlang, spawn};
inline(?kernel, spawn_link, 1) -> {erlang, spawn_link};
inline(?kernel, spawn_link, 3) -> {erlang, spawn_link};
inline(?kernel, spawn_monitor, 1) -> {erlang, spawn_monitor};
inline(?kernel, spawn_monitor, 3) -> {erlang, spawn_monitor};
inline(?kernel, throw, 1) -> {erlang, throw};
inline(?kernel, tl, 1) -> {erlang, tl};
inline(?kernel, trunc, 1) -> {erlang, trunc};
inline(?kernel, tuple_size, 1) -> {erlang, tuple_size};

inline(?map, keys, 1) -> {maps, keys};
inline(?map, merge, 2) -> {maps, merge};
inline(?map, size, 1) -> {maps, size};
inline(?map, values, 1) -> {maps, values};
inline(?map, to_list, 1) -> {maps, to_list};

inline(?node, list, 0) -> {erlang, nodes};
inline(?node, list, 1) -> {erlang, nodes};
inline(?node, spawn, 2) -> {erlang, spawn};
inline(?node, spawn, 3) -> {erlang, spawn_opt};
inline(?node, spawn, 4) -> {erlang, spawn};
inline(?node, spawn, 5) -> {erlang, spawn_opt};
inline(?node, spawn_link, 2) -> {erlang, spawn_link};
inline(?node, spawn_link, 4) -> {erlang, spawn_link};

inline(?process, 'alive?', 1) -> {erlang, is_process_alive};
inline(?process, cancel_timer, 1) -> {erlang, cancel_timer};
inline(?process, exit, 2) -> {erlang, exit};
inline(?process, get, 0) -> {erlang, get};
inline(?process, get_keys, 0) -> {erlang, get_keys};
inline(?process, get_keys, 1) -> {erlang, get_keys};
inline(?process, hibernate, 3) -> {erlang, hibernate};
inline(?process, demonitor, 1) -> {erlang, demonitor};
inline(?process, demonitor, 2) -> {erlang, demonitor};
inline(?process, link, 1) -> {erlang, link};
inline(?process, read_timer, 1) -> {erlang, read_timer};
inline(?process, spawn, 2) -> {erlang, spawn_opt};
inline(?process, spawn, 4) -> {erlang, spawn_opt};
inline(?process, unlink, 1) -> {erlang, unlink};

inline(?port, open, 2) -> {erlang, open_port};
inline(?port, close, 1) -> {erlang, port_close};
inline(?port, command, 2) -> {erlang, port_command};
inline(?port, command, 3) -> {erlang, port_command};
inline(?port, connect, 2) -> {erlang, port_connect};
inline(?port, list, 0) -> {erlang, ports};

inline(?string, to_float, 1) -> {erlang, binary_to_float};
inline(?string, to_integer, 1) -> {erlang, binary_to_integer};
inline(?string, to_integer, 2) -> {erlang, binary_to_integer};

inline(?system, stacktrace, 0) -> {erlang, get_stacktrace};
inline(?system, monotonic_time, 0) -> {erlang, monotonic_time};
inline(?system, os_time, 0) -> {os, system_time};
inline(?system, system_time, 0) -> {erlang, system_time};
inline(?system, time_offset, 0) -> {erlang, time_offset};
inline(?system, unique_integer, 0) -> {erlang, unique_integer};
inline(?system, unique_integer, 1) -> {erlang, unique_integer};

inline(?tuple, to_list, 1) -> {erlang, tuple_to_list};
inline(?tuple, append, 2) -> {erlang, append_element};

inline(_, _, _) -> false.

%% Rewrite rules
%%
%% Rewrite rules are more complex than regular inlining code.
%% It receives all remote call arguments and return quoted
%% expressions with the new environment.
%%
%% Notice we use the given Meta in rewritten code so we
%% get proper coverage report. However, we mark the enclosing
%% cases as hidden to avoid warnings.

%% Complex rewrite rules

%% TODO: Move rewrite rules to Erlang pass as those are
%% optimizations specific to the Erlang backend. They also
%% affect code such as guard validation.

rewrite(?access, _DotMeta, 'get', _Meta, [nil, Arg], _Env)
    when ?is_literal(Arg) orelse (is_atom(element(1, Arg)) andalso element(3, Arg) == nil) ->
  nil;
rewrite(?access, _DotMeta, 'get', Meta, [Arg, _], Env)
    when ?is_literal(Arg) orelse element(1, Arg) == '{}' orelse element(1, Arg) == '<<>>' ->
  elixir_errors:compile_error(Meta, ?m(Env, file),
    "the Access syntax and calls to Access.get/2 are not available for the value: ~ts",
    ['Elixir.Macro':to_string(Arg)]);
rewrite(?list_chars, _DotMeta, 'to_charlist', _Meta, [List], _Env) when is_list(List) ->
  List;
rewrite(?string_chars, _DotMeta, 'to_string', _Meta, [String], _Env) when is_binary(String) ->
  String;
rewrite(?string_chars, _, 'to_string', _, [{{'.', _, [?kernel, inspect]}, _, _} = Call], _Env) ->
  Call;
rewrite(?string_chars, DotMeta, 'to_string', Meta, [Call], _Env) ->
  Generated = ?generated(Meta),
  Var   = {'rewrite', Meta, 'Elixir'},
  Guard = remote(erlang, Generated, is_binary, Generated, [Var]),
  Slow  = remote(?string_chars, DotMeta, 'to_string', Meta, [Var]),
  Fast  = Var,

  {'case', Generated, [Call, [{do,
    [{'->', Generated, [[{'when', Meta, [Var, Guard]}], Fast]},
     {'->', Generated, [[Var], Slow]}]
  }]]};

rewrite(?enum, DotMeta, 'reverse', Meta, [List], _Env) when is_list(List) ->
  remote(lists, DotMeta, 'reverse', Meta, [List]);
rewrite(?enum, DotMeta, 'reverse', Meta, [List], _Env) ->
  Generated = ?generated(Meta),
  Var   = {'rewrite', Meta, 'Elixir'},
  Guard = remote(erlang, Generated, is_list, Generated, [Var]),
  Slow  = remote(?enum, DotMeta, 'reverse', Meta, [Var, []]),
  Fast  = remote(lists, DotMeta, 'reverse', Meta, [Var]),

  {'case', Generated, [List, [{do,
    [{'->', Generated, [[{'when', Meta, [Var, Guard]}], Fast]},
     {'->', Generated, [[Var], Slow]}]
  }]]};

rewrite(Receiver, DotMeta, Right, Meta, Args, _Env) ->
  {EReceiver, ERight, EArgs} = rewrite(Receiver, Right, Args),
  remote(EReceiver, DotMeta, ERight, Meta, EArgs).

%% Simple rewrite rules

rewrite(?atom, to_string, [Arg]) ->
  {erlang, atom_to_binary, [Arg, utf8]};
rewrite(?enum, into, [Arg, {'%{}', _, []}]) ->
  {?map, new, [Arg]};
rewrite(?enum, into, [Arg, {'%{}', _, []}, Fun]) ->
  {?map, new, [Arg, Fun]};
rewrite(?kernel, elem, [Tuple, Index]) ->
  {erlang, element, [increment(Index), Tuple]};
rewrite(?kernel, put_elem, [Tuple, Index, Value]) ->
  {erlang, setelement, [increment(Index), Tuple, Value]};
rewrite(?map, 'has_key?', [Map, Key]) ->
  {maps, is_key, [Key, Map]};
rewrite(?map, fetch, [Map, Key]) ->
  {maps, find, [Key, Map]};
rewrite(?map, put, [Map, Key, Value]) ->
  {maps, put, [Key, Value, Map]};
rewrite(?map, delete, [Map, Key]) ->
  {maps, remove, [Key, Map]};
rewrite(?process, monitor, [Arg]) ->
  {erlang, monitor, [process, Arg]};
rewrite(?process, send_after, [Dest, Msg, Time]) ->
  {erlang, send_after, [Time, Dest, Msg]};
rewrite(?process, send_after, [Dest, Msg, Time, Opts]) ->
  {erlang, send_after, [Time, Dest, Msg, Opts]};
rewrite(?string, to_atom, [Arg]) ->
  {erlang, binary_to_atom, [Arg, utf8]};
rewrite(?string, to_existing_atom, [Arg]) ->
  {erlang, binary_to_existing_atom, [Arg, utf8]};
rewrite(?tuple, insert_at, [Tuple, Index, Term]) ->
  {erlang, insert_element, [increment(Index), Tuple, Term]};
rewrite(?tuple, delete_at, [Tuple, Index]) ->
  {erlang, delete_element, [increment(Index), Tuple]};
rewrite(?tuple, duplicate, [Data, Size]) ->
  {erlang, make_tuple, [Size, Data]};
rewrite(Receiver, Fun, Args) ->
  {Receiver, Fun, Args}.

%% Rewrite helpers

remote(Receiver, DotMeta, Right, Meta, Args) ->
  {{'.', DotMeta, [Receiver, Right]}, Meta, Args}.

increment(Number) when is_number(Number) ->
  Number + 1;
increment(Other) ->
  {{'.', [], [erlang, '+']}, [], [Other, 1]}.
