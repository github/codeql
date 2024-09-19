private import codeql.swift.elements
private import codeql.swift.generated.ParentChild
// Internal classes are not imported by the tests:
import codeql.swift.elements.expr.internal.InitializerRefCallExpr
import codeql.swift.elements.expr.internal.DotSyntaxCallExpr

cached
predicate toBeTested(Element e) {
  e instanceof File
  or
  e instanceof ParameterizedProtocolType
  or
  e instanceof PackType
  or
  e instanceof PackElementType
  or
  e instanceof PackArchetypeType
  or
  e instanceof MacroRole
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
      or
      tested = getImmediateParent(e)
    )
  )
}
