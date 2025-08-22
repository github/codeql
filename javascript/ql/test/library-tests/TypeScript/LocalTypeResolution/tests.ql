import javascript

abstract class Violation extends AstNode {
  abstract string reason();
}

/**
 * Holds for tuples of form `[X, "name1"]` where `X` is a simple type access
 * resolving to an interface of form `{ where: "name2" }`.
 *
 * The assertion holds if `name1 = name2`, indicating that `X` resolved to the right interface.
 */
class TypeResolutionAssertion extends TupleTypeExpr, Violation {
  string expected;
  string actual;

  TypeResolutionAssertion() {
    exists(InterfaceDeclaration interface, LocalTypeAccess typeAccess |
      typeAccess = this.getElementType(0) and
      expected = this.getElementType(1).(StringLiteralTypeExpr).getValue() and
      typeAccess.getLocalTypeName() = interface.getIdentifier().(TypeDecl).getLocalTypeName() and
      actual = interface.getField("where").getTypeAnnotation().(StringLiteralTypeExpr).getValue() and
      actual != expected
    )
  }

  override string reason() {
    result = "resolved to '" + actual + "' but should resolve to '" + expected + "'"
  }
}

query predicate checkResolution(Violation violation, string reason) { violation.reason() = reason }

query predicate namespaceAccess(NamespaceAccess acc) { any() }

query predicate noDeclaration(LocalTypeName name, Scope scope, string msg) {
  not exists(name.getADeclaration()) and
  name.getScope() = scope and
  msg = name.toString() + " has no declaration"
}

query predicate noLocalName(LocalTypeAccess type) { not exists(type.getLocalTypeName()) }

query predicate resolveNamespaceNames(
  LocalNamespaceName name, Identifier acc, LocalNamespaceDecl decl
) {
  acc = name.getAnAccess() and
  decl = name.getADeclaration()
}

query predicate resolveTypeNames(LocalTypeName name, Identifier acc, LocalNamespaceDecl decl) {
  acc = name.getAnAccess() and
  decl = name.getADeclaration()
}
