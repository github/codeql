import javascript

bindingset[x, y]
private string join(string x, string y) {
  if x = "" or y = "" then result = x + y else result = x + "." + y
}

query predicate hasUnderlyingType(DataFlow::SourceNode node, string value) {
  node.hasUnderlyingType(value)
  or
  exists(string mod, string name |
    node.hasUnderlyingType(mod, name) and
    value = join("'" + mod + "'", name)
  )
}
