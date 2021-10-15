package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A conditional type annotation, such as <code>T extends any[] ? A : B</code>. */
public class ConditionalTypeExpr extends TypeExpression {
  private ITypeExpression checkType;
  private ITypeExpression extendsType;
  private ITypeExpression trueType;
  private ITypeExpression falseType;

  public ConditionalTypeExpr(
      SourceLocation loc,
      ITypeExpression checkType,
      ITypeExpression extendsType,
      ITypeExpression trueType,
      ITypeExpression falseType) {
    super("ConditionalTypeExpr", loc);
    this.checkType = checkType;
    this.extendsType = extendsType;
    this.trueType = trueType;
    this.falseType = falseType;
  }

  public ITypeExpression getCheckType() {
    return checkType;
  }

  public ITypeExpression getExtendsType() {
    return extendsType;
  }

  public ITypeExpression getTrueType() {
    return trueType;
  }

  public ITypeExpression getFalseType() {
    return falseType;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
