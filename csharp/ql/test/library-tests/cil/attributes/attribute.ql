import semmle.code.cil.Attribute
import semmle.code.cil.Declaration

query predicate attrNoArg(string dec, string attr) {
  exists(Declaration d, Attribute a |
    a.getDeclaration() = d and
    not exists(a.getAnArgument())
  |
    dec = d.toStringWithTypes() and
    attr = a.toStringWithTypes()
  )
}

query predicate attrArgNamed(string dec, string attr, string name, string value) {
  exists(Declaration d, Attribute a |
    a.getDeclaration() = d and
    a.getNamedArgument(name) = value
  |
    dec = d.toStringWithTypes() and
    attr = a.toStringWithTypes()
  )
}

query predicate attrArgPositional(string dec, string attr, int index, string value) {
  exists(Declaration d, Attribute a |
    a.getDeclaration() = d and
    a.getArgument(index) = value
  |
    dec = d.toStringWithTypes() and
    attr = a.toStringWithTypes()
  )
}
