private import codeql.swift.elements

cached
predicate toBeTested(Element e) {
  e instanceof File
  or
  exists(ModuleDecl m |
    not m.isBuiltinModule() and
    not m.isSystemModule() and
    (m = e or m.getInterfaceType() = e)
  )
  or
  exists(Locatable loc |
    loc.getLocation().getFile().getName().matches("%swift/ql/test%") and
    (
      e = loc
      or
      exists(Type t |
        (e = t or e = t.(ExistentialType).getConstraint() or e = t.getCanonicalType()) and
        (
          t = loc.(ValueDecl).getInterfaceType()
          or
          t = loc.(NominalTypeDecl).getType()
          or
          t = loc.(VarDecl).getType()
          or
          t = loc.(Expr).getType()
        )
      )
    )
  )
}
