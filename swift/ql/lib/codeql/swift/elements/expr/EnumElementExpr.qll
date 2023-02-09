private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.Argument
private import codeql.swift.elements.expr.CallExpr
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.decl.EnumElementDecl

/**
 * An expression that constructs a case of an enum.
 */
abstract class EnumElementExpr extends Expr {
  EnumElementDecl decl;

  /** Gets the declaration of the enum element that this expression creates. */
  EnumElementDecl getElement() { result = decl }

  /** Gets the `i`th argument passed to this enum element expression (0-based). */
  Argument getArgument(int i) { none() }

  /** Gets an argument passed to this enum element expression, if any. */
  final Argument getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments passed to this enum element expression. */
  final int getNumberOfArguments() { result = count(this.getArgument(_)) }
}

private class EnumElementLookupExpr extends MethodLookupExpr {
  EnumElementLookupExpr() { this.getMember() instanceof EnumElementDecl }
}

private class NullaryEnumElementExpr extends EnumElementExpr instanceof EnumElementLookupExpr {
  NullaryEnumElementExpr() {
    this.getMember() = decl and not exists(CallExpr ce | ce.getFunction() = this)
  }
}

private class NonNullaryEnumElementExpr extends EnumElementExpr instanceof CallExpr {
  NonNullaryEnumElementExpr() {
    exists(EnumElementLookupExpr eele |
      this.getFunction() = eele and
      eele.getMember() = decl
    )
  }

  override Argument getArgument(int i) { result = CallExpr.super.getArgument(i) }
}
