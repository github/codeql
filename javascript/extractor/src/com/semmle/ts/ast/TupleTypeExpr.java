package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** A tuple type, such as <tt>[number, string]</tt>. */
public class TupleTypeExpr extends TypeExpression {
  private final List<ITypeExpression> elementTypes;

  public TupleTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes) {
    super("TupleTypeExpr", loc);
    this.elementTypes = elementTypes;
  }

  public List<ITypeExpression> getElementTypes() {
    return elementTypes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
