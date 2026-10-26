package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** An expression of form <code>E satisfies T</code>. */
public class SatisfiesExpr extends Expression {
  private final Expression expression;
  private final ITypeExpression typeAnnotation;

  public SatisfiesExpr(
      SourceLocation loc,
      Expression expression,
      ITypeExpression typeAnnotation) {
    super("SatisfiesExpr", loc);
    this.expression = expression;
    this.typeAnnotation = typeAnnotation;
  }

  public Expression getExpression() {
    return expression;
  }

  public ITypeExpression getTypeAnnotation() {
    return typeAnnotation;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
