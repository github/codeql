/**
 * `EnumElementExpr` is an expression that constructs a case of an enum.
 */

private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.Argument
private import codeql.swift.elements.expr.CallExpr
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.decl.EnumElementDecl

/**
 * An expression that references a case of an enum. For example both `enumElement` in:
 * ```
 * let value = MyEnum.enumElement
 * ...
 * switch (anotherValue) {
 *   case .enumElement:
 *   ...
 * ```
 */
final class EnumElementExpr extends Expr {
  EnumElementDecl decl;

  EnumElementExpr() {
    this.(NullaryEnumElementExpr).getElement() = decl or
    this.(NonNullaryEnumElementExpr).getElement() = decl
  }

  /** Gets the declaration of the enum element that this expression creates. */
  EnumElementDecl getElement() { result = decl }

  /** Gets the `i`th argument passed to this enum element expression (0-based). */
  Argument getArgument(int i) { result = this.(NonNullaryEnumElementExpr).getArgument(i) }

  /** Gets an argument passed to this enum element expression, if any. */
  final Argument getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments passed to this enum element expression. */
  final int getNumberOfArguments() { result = count(this.getArgument(_)) }
}

/**
 * An expression that refers to an enum element, either directly in the case of a nullary enum element,
 * or referring to the enum element constructor in the case of a non-nullary enum element.
 */
private class EnumElementLookupExpr extends MethodLookupExpr {
  EnumElementLookupExpr() { this.getMember() instanceof EnumElementDecl }
}

/** An expression creating an enum with no arguments */
private class NullaryEnumElementExpr extends EnumElementLookupExpr {
  /** Gets the declaration of the enum element that this expression creates. */
  EnumElementDecl getElement() { this.getMember() = result }

  NullaryEnumElementExpr() { not exists(CallExpr ce | ce.getFunction() = this) }
}

/** An expression creating an enum with arguments */
private class NonNullaryEnumElementExpr extends CallExpr {
  EnumElementLookupExpr eele;

  /** Gets the declaration of the enum element that this expression creates. */
  EnumElementDecl getElement() { eele.getMember() = result }

  NonNullaryEnumElementExpr() { this.getFunction() = eele }
}
