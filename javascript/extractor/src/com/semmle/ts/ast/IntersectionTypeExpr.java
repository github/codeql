package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

/**
 * An intersection type such as <tt>T&amp;S</tt>, denoting the intersection of type <tt>T</tt> and
 * type <tt>S</tt>.
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
