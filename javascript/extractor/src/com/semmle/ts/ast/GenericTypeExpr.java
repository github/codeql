package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** An instantiation of a named type, such as <tt>Array&lt;number&gt;</tt> */
public class GenericTypeExpr extends TypeExpression {
  private final ITypeExpression typeName; // Always Identifier or MemberExpression
  private final List<ITypeExpression> typeArguments;

  public GenericTypeExpr(
      SourceLocation loc, ITypeExpression typeName, List<ITypeExpression> typeArguments) {
    super("GenericTypeExpr", loc);
    this.typeName = typeName;
    this.typeArguments = typeArguments;
  }

  public ITypeExpression getTypeName() {
    return typeName;
  }

  public List<ITypeExpression> getTypeArguments() {
    return typeArguments;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
