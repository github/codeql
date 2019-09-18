package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

/** An array pattern as in <code>var [x, y] = z;</code>. */
public class ArrayPattern extends Expression implements DestructuringPattern {
  private final List<Expression> elements, rawElements;
  private final List<Expression> defaults;
  private final Expression restPattern;

  public ArrayPattern(SourceLocation loc, List<Expression> elements) {
    super("ArrayPattern", loc);
    this.rawElements = elements;
    this.elements = new ArrayList<Expression>(elements.size());
    this.defaults = new ArrayList<Expression>(elements.size());
    Expression rest = null;
    for (Expression element : elements) {
      if (element instanceof RestElement) {
        rest = ((RestElement) element).getArgument();
      } else {
        if (element instanceof AssignmentPattern) {
          AssignmentPattern assgn = (AssignmentPattern) element;
          this.defaults.add(assgn.getRight());
          this.elements.add(assgn.getLeft());
        } else {
          this.defaults.add(null);
          this.elements.add(element);
        }
      }
    }
    this.restPattern = rest;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /**
   * The element patterns of the array pattern; omitted element patterns are represented by
   * {@literal null}.
   */
  public List<Expression> getElements() {
    return elements;
  }

  /** The default expressions for the element patterns of the array pattern. */
  public List<Expression> getDefaults() {
    return defaults;
  }

  /** Return the rest pattern of this array pattern, if any. */
  public Expression getRest() {
    return restPattern;
  }

  /** Does this array pattern have a rest pattern? */
  public boolean hasRest() {
    return restPattern != null;
  }

  /**
   * The raw element patterns of the array pattern; patterns with defaults are represented as {@link
   * AssignmentPattern}s.
   */
  public List<Expression> getRawElements() {
    return rawElements;
  }
}
