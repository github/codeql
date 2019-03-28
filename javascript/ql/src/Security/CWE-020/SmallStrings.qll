/**
 * Provides predicates for restricting reasoning to small strings, in the name of performance.
 */

import javascript

/**
 * Holds if `n` represents a small regular expression pattern,
 * either because `n` is a regular expression literal, or because `n` is
 * a string that could be used to construct a regular expression.
 */
pragma[noinline]
predicate isSmallRegExpPattern(DataFlow::Node n, string pattern) {
  pattern.length() < 1000 and
  (
    n.asExpr().(RegExpLiteral).getValue() = pattern
    or
    n.asExpr().(SimpleConstantString).getSimpleStringValue() = pattern
  )
}

/**
 * Holds if `n` represents a small string.
 */
pragma[noinline]
predicate isSmallString(DataFlow::Node n, string str) {
  str.length() < 1000 and
  n.asExpr().(SimpleConstantString).getSimpleStringValue() = str
}

/**
 * An expression that evaluates to a constant string in one step.
 */
private class SimpleConstantString extends ConstantString {
  string str;

  SimpleConstantString() {
    str = this.(StringLiteral).getValue()
    or
    exists(TemplateLiteral template | this = template |
      template.getNumChildExpr() = 0 and
      str = ""
      or
      template.getNumChildExpr() = 1 and
      str = template.getElement(0).(TemplateElement).getValue()
    )
  }

  /** Gets the constant string value this expression evaluates to. */
  string getSimpleStringValue() { result = str }
}
