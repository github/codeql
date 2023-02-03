import cil

query predicate cilfields(CIL::Field f, string type) {
  f.isRef() and type = f.getType().toString() and f.getDeclaringType().getName() = "RefStruct"
}
