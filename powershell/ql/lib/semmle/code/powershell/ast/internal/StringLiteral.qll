private import AstImport

// TODO: A string literal should ideally be the string constants that are
// surrounded by quotes (single or double), but we don't yet extract that
// information. So for now we just use the StringConstExpr class, which is
// a bit more general than we want.
class StringLiteral instanceof StringConstExpr {
  /** Get the string representation of this string literal. */
  string toString() { result = this.getValue() }

  /** Get the value of this string literal. */
  string getValue() { result = super.getValueString() }

  /** Get the location of this string literal. */
  SourceLocation getLocation() { result = super.getLocation() }
}
