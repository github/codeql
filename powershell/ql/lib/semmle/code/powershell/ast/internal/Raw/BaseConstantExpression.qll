private import Raw

/** The base class for constant expressions. */
class BaseConstExpr extends @base_constant_expression, Expr {
  /** Gets the type of this constant expression. */
  string getType() { none() }

  /** Gets a string literal of this constant expression. */
  StringLiteral getValue() { none() }
}
