import javascript

query predicate test_query11(VarDef def, string res) {
  exists(LocalVariable v | v = def.getAVariable() and not exists(VarUse use | def = use.getADef()) |
    res = "Dead store of local variable."
  )
}
