import semmle.code.cil.Attribute
import semmle.code.cil.Declaration

private predicate isOsSpecific(Declaration d) {
  d.getQualifiedName()
      .matches("%" +
          [
            "libobjc", "libproc", "System.Diagnostics.Tracing.XplatEventLogger",
            "System.Threading.AutoreleasePool"
          ] + "%")
}

query predicate attrNoArg(string dec, string attr) {
  exists(Declaration d, Attribute a |
    not isOsSpecific(d) and
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
    not isOsSpecific(d) and
    a.getNamedArgument(name) = value
  |
    dec = d.toStringWithTypes() and
    attr = a.toStringWithTypes()
  )
}

query predicate attrArgPositional(string dec, string attr, int index, string value) {
  exists(Declaration d, Attribute a |
    a.getDeclaration() = d and
    not isOsSpecific(d) and
    a.getArgument(index) = value
  |
    dec = d.toStringWithTypes() and
    attr = a.toStringWithTypes()
  )
}
