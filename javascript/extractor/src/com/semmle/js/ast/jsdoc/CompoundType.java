package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** Common superclass of {@link ArrayType} and {@link UnionType}. */
public abstract class CompoundType extends JSDocTypeExpression {
  private final List<JSDocTypeExpression> elements;

  public CompoundType(String type, SourceLocation loc, List<JSDocTypeExpression> elements) {
    super(loc, type);
    this.elements = elements;
  }

  protected String pp(String sep) {
    StringBuilder sb = new StringBuilder();
    for (JSDocTypeExpression element : elements) {
      if (sb.length() > 0) sb.append(sep);
      sb.append(element.pp());
    }
    return sb.toString();
  }

  /** The element type expressions of this compound type. */
  public List<JSDocTypeExpression> getElements() {
    return elements;
  }
}
