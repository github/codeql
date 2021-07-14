package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** A union type such as <code>number | string | boolean</code>. */
public class UnionTypeExpr extends TypeExpression {
  private final List<ITypeExpression> elementTypes;

  public UnionTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes) {
    super("UnionTypeExpr", loc);
    this.elementTypes = elementTypes;
  }

  /** The members of the union; always contains at least two types. */
  public List<ITypeExpression> getElementTypes() {
    return elementTypes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
