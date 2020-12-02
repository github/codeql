import cpp

string describe(Struct s) {
  s instanceof LocalStruct and
  result = "LocalStruct"
  or
  s instanceof NestedStruct and
  result = "NestedStruct"
}

query predicate structs(Struct s, string descStr) {
  s.fromSource() and
  descStr = concat(describe(s), ", ")
}

query predicate assignments(Assignment a, Expr l, string explainL, Expr r, string explainR) {
  l = a.getLValue() and
  explainL = l.getType().explain() and
  r = a.getRValue() and
  explainR = r.getType().explain()
}
