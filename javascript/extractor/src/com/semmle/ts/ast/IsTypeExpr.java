package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A type of form <tt>E is T</tt> where <tt>E</tt> is a parameter name or <tt>this</tt> and
 * <tt>T</tt> is a type.
 */
public class IsTypeExpr extends TypeExpression {
  private final ITypeExpression left; // Always Identifier or KeywordTypeExpr (in case of 'this')
  private final ITypeExpression right;

  public IsTypeExpr(SourceLocation loc, ITypeExpression left, ITypeExpression right) {
    super("IsTypeExpr", loc);
    this.left = left;
    this.right = right;
  }

  public ITypeExpression getLeft() {
    return left;
  }

  public ITypeExpression getRight() {
    return right;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
