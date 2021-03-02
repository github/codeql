package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/**
 * An intersection type such as <code>T&amp;S</code>, denoting the intersection of type <code>T</code> and
 * type <code>S</code>.
 */
public class IntersectionTypeExpr extends TypeExpression {
  private final List<ITypeExpression> elementTypes;

  public IntersectionTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes) {
    super("IntersectionTypeExpr", loc);
    this.elementTypes = elementTypes;
  }

  /** The members of the intersection type; always contains at least two types. */
  public List<ITypeExpression> getElementTypes() {
    return elementTypes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
