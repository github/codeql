package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** An expression of form <code>E as T</code> or <code>&lt;T&gt; E</code>. */
public class TypeAssertion extends Expression {
  private final Expression expression;
  private final ITypeExpression typeAnnotation;
  private final boolean isAsExpression;

  public TypeAssertion(
      SourceLocation loc,
      Expression expression,
      ITypeExpression typeAnnotation,
      boolean isAsExpression) {
    super("TypeAssertion", loc);
    this.expression = expression;
    this.typeAnnotation = typeAnnotation;
    this.isAsExpression = isAsExpression;
  }

  public Expression getExpression() {
    return expression;
  }

  public ITypeExpression getTypeAnnotation() {
    return typeAnnotation;
  }

  /**
   * True if this is an assertion of form <tt>E as T</tt>, as opposed to the old syntax <code>
   * &lt;T&gt; E</code>.
   */
  public boolean isAsExpression() {
    return isAsExpression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
