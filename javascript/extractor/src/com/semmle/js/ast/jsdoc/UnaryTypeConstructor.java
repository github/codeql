package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/**
 * Common superclass of {@link NonNullableType}, {@link NullableType}, {@link OptionalType} and
 * {@link RestType}.
 */
public abstract class UnaryTypeConstructor extends JSDocTypeExpression {
  private final JSDocTypeExpression expression;
  private final boolean prefix;
  private final String operator;

  public UnaryTypeConstructor(
      SourceLocation loc,
      String type,
      JSDocTypeExpression expression,
      Boolean prefix,
      String operator) {
    super(loc, type);
    this.expression = expression;
    this.prefix = prefix == Boolean.TRUE;
    this.operator = operator;
  }

  @Override
  public String pp() {
    if (expression == null) return operator;

    if (prefix) return operator + expression.pp();
    else return expression.pp() + operator;
  }

  /** The argument of this type constructor. */
  public JSDocTypeExpression getExpression() {
    return expression;
  }

  /** Is this a prefix type constructor? */
  public boolean isPrefix() {
    return prefix;
  }
}
