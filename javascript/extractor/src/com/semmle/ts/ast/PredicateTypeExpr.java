package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A type of form <code>E is T</code>, <code>asserts E is T</code> or <code>asserts E</code> where <code>E</code> is
 * a parameter name or <code>this</code> and <code>T</code> is a type.
 */
public class PredicateTypeExpr extends TypeExpression {
  private final ITypeExpression expression;
  private final ITypeExpression type;
  private final boolean hasAssertsKeyword;

  public PredicateTypeExpr(
      SourceLocation loc,
      ITypeExpression expression,
      ITypeExpression type,
      boolean hasAssertsKeyword) {
    super("PredicateTypeExpr", loc);
    this.expression = expression;
    this.type = type;
    this.hasAssertsKeyword = hasAssertsKeyword;
  }

  /** Returns the <code>E</code> in <code>E is T</code>. */
  public ITypeExpression getExpression() {
    return expression;
  }

  /** Returns the <code>T</code> in <code>E is T</code>. */
  public ITypeExpression getTypeExpr() {
    return type;
  }

  public boolean hasAssertsKeyword() {
    return hasAssertsKeyword;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
