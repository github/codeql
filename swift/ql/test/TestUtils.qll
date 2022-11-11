private import codeql.swift.elements

cached
predicate toBeTested(Element e) {
  e instanceof File
  or
  e instanceof AppliedPropertyWrapperExpr
  or
  exists(ModuleDecl m |
    m = e and
    not m.isBuiltinModule() and
    not m.isSystemModule()
  )
  or
  e.(Locatable).getLocation().getFile().getName().matches("%swift/ql/test%")
  or
  exists(Element tested |
    toBeTested(tested) and
    (
      e = tested.(ValueDecl).getInterfaceType()
      or
      e = tested.(NominalTypeDecl).getType()
      or
      e = tested.(VarDecl).getType()
      or
      e = tested.(Expr).getType()
      or
      e = tested.(Type).getCanonicalType()
      or
      e = tested.(ExistentialType).getConstraint()
      or
      e.(UnspecifiedElement).getParent() = tested
      or
      e.(OpaqueTypeDecl).getNamingDeclaration() = tested
    )
  )
}
