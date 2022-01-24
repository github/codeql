package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A type of form <code>typeof E</code> where <code>E</code> is an expression that takes the form of a
 * qualified name.
 */
public class TypeofTypeExpr extends TypeExpression {
  private final ITypeExpression expression; // Always Identifier or MemberExpression.

  public TypeofTypeExpr(SourceLocation loc, ITypeExpression expression) {
    super("TypeofTypeExpr", loc);
    this.expression = expression;
  }

  public ITypeExpression getExpression() {
    return expression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
