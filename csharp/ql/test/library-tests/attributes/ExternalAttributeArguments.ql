import csharp

query predicate arguments(string a, int index, string e) {
  exists(Attribute attribute, Attributable attributable |
    attribute.getType().toString() = "CustomAttribute" and
    attributable = attribute.getTarget() and
    e = attribute.getArgument(index).toString() and
    a = attributable.toString()
  )
}

query predicate literals(string lit, string t, string value) {
  exists(Attribute attribute, Literal l |
    attribute.getType().toString() = "CustomAttribute" and
    l = attribute.getArgument(_) and
    t = l.getType().toString() and
    value = l.getValue() and
    lit = l.toString()
  )
}

query predicate enums(string cast, string e, string ta, string value) {
  exists(Attribute attribute, Cast c |
    attribute.getType().toString() = "CustomAttribute" and
    c = attribute.getArgument(_) and
    value = c.getValue() and
    e = c.getExpr().toString() and
    ta = c.getTypeAccess().toString() and
    cast = c.toString()
  )
}

query predicate typeof(string typeof, string t) {
  exists(Attribute attribute, TypeofExpr te |
    attribute.getType().toString() = "CustomAttribute" and
    te = attribute.getArgument(_) and
    t = te.getTypeAccess().toString() and
    typeof = te.toString()
  )
}

query predicate array(string array, int l, int i, string child) {
  exists(Attribute attribute, ArrayCreation ac |
    attribute.getType().toString() = "CustomAttribute" and
    ac = attribute.getArgument(_) and
    array = ac.toString() and
    l = ac.getLengthArgument(0).getValue().toInt() and
    child = ac.getInitializer().getChild(i).toString()
  )
}
