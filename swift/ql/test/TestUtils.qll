private import codeql.swift.elements

cached
predicate toBeTested(Element e) {
  e instanceof File
  or
  exists(Locatable loc |
    loc.getLocation().getFile().getName().matches("%swift/ql/test%") and
    (
      e = loc
      or
      e = loc.(ValueDecl).getInterfaceType()
      or
      e = loc.(NominalTypeDecl).getType()
    )
  )
}
