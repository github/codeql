package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A TypeScript expression of form <tt>E!</tt>, asserting that <tt>E</tt> is not null. */
public class NonNullAssertion extends Expression {
  private final Expression expression;

  public NonNullAssertion(SourceLocation loc, Expression expression) {
    super("NonNullAssertion", loc);
    this.expression = expression;
  }

  public Expression getExpression() {
    return expression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
