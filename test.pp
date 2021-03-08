$arg_hash = {
  'test'  => 'foo',
  'thing' => 'bar',
}
$args = $arg_hash.reduce('') |$cli_string, $arg| {
  "$cli_string --${arg[0]}==${arg[1]}"
}

