import javascript

abstract class Violation extends ASTNode {
  abstract string reason();
}

/**
 * Holds for tuples of form `[X, "name1"]` where `X` is a simple type access
 * resolving to an interface of form `{ where: "name2" }`.
 *
 * The assertion holds if `name1 = name2`, indicating that `X` resolved to the right interface.
 */
class TypeResolutionAssertion extends TupleTypeExpr, Violation {
  InterfaceDeclaration interface;
  LocalTypeAccess typeAccess;
  string expected;
  string actual;

  TypeResolutionAssertion() {
    typeAccess = getElementType(0) and
    expected = getElementType(1).(StringLiteralTypeExpr).getValue() and
    typeAccess.getLocalTypeName() = interface.getIdentifier().(TypeDecl).getLocalTypeName() and
    actual = interface.getField("where").getTypeAnnotation().(StringLiteralTypeExpr).getValue() and
    actual != expected
  }

  override string reason() {
    result = "resolved to '" + actual + "' but should resolve to '" + expected + "'"
  }
}

from Violation violation
select violation, violation.reason()
