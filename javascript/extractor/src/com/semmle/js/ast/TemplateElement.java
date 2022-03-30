package com.semmle.js.ast;

/** An element in a template literal. */
public class TemplateElement extends Expression {
  private final Object cooked;
  private final String raw;
  private final boolean tail;

  public TemplateElement(SourceLocation loc, Object cooked, String raw, Boolean tail) {
    super("TemplateElement", loc);
    this.cooked = cooked;
    this.raw = raw;
    this.tail = tail == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The "cooked" value of the template element. */
  public Object getCooked() {
    return cooked;
  }

  /** The raw value of the template element. */
  public String getRaw() {
    return raw;
  }

  /** Is this the tail element? */
  public boolean isTail() {
    return tail;
  }
}
