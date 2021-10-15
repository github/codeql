package com.semmle.js.ast;

import com.semmle.jcorn.TokenType;
import com.semmle.ts.ast.ITypeExpression;

/**
 * A literal constant.
 *
 * <p>A <code>null</code> literal may occur as a TypeScript type annotation - other literals are always
 * expressions.
 */
public class Literal extends Expression implements ITypeExpression {
  private final TokenType tokenType;
  private final Object value;
  private final String raw;

  public Literal(SourceLocation loc, TokenType tokenType, Object value) {
    super("Literal", loc);

    // for numbers, check whether they can be represented as integers
    if (value instanceof Double) {
      Double dvalue = (Double) value;
      if (dvalue >= Long.MIN_VALUE && dvalue <= Long.MAX_VALUE && (dvalue % 1) == 0)
        value = dvalue.longValue();
    } else if (value instanceof CharSequence) {
      value = value.toString();
    }

    this.tokenType = tokenType;
    this.value = value;
    this.raw = getLoc().getSource();
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The type of the token corresponding to this literal. */
  public TokenType getTokenType() {
    return tokenType;
  }

  /**
   * The value of this literal; may be null if this is a null literal or a literal whose value
   * cannot be represented by the parser.
   */
  public Object getValue() {
    return value;
  }

  /** The source text of this literal. */
  public String getRaw() {
    return raw;
  }

  /** Is this a regular expression literal? */
  public boolean isRegExp() {
    return tokenType == TokenType.regexp;
  }

  /** Is this a string literal? */
  public boolean isStringLiteral() {
    return tokenType == TokenType.string;
  }

  /** The value of this literal expressed as a string. */
  public String getStringValue() {
    // regular expressions may have a null value; use the raw value instead
    if (isRegExp()) return raw;
    return String.valueOf(value);
  }

  /** Is the value of this literal falsy? */
  public boolean isFalsy() {
    if (isRegExp()) return false;
    return value == null
        || value instanceof Number && ((Number) value).intValue() == 0
        || value == Boolean.FALSE
        || value instanceof String && ((String) value).isEmpty();
  }

  /** Is the value of this literal truthy? */
  public boolean isTruthy() {
    return !isFalsy();
  }
}
