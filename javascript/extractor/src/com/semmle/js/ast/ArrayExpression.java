package com.semmle.js.ast;

import java.util.List;

/** An array expression such as <code>[x, , "hello"]</code>. */
public class ArrayExpression extends Expression {
  private final List<Expression> elements;

  public ArrayExpression(SourceLocation loc, List<Expression> elements) {
    super("ArrayExpression", loc);
    this.elements = elements;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The elements of the array; omitted elements are represented by {@literal null}. */
  public List<Expression> getElements() {
    return elements;
  }
}
