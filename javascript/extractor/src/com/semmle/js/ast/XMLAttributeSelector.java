package com.semmle.js.ast;

public class XMLAttributeSelector extends Expression {
  final Expression attribute;
  final boolean computed;

  public XMLAttributeSelector(SourceLocation loc, Expression attribute, boolean computed) {
    super("XMLAttributeSelector", loc);
    this.attribute = attribute;
    this.computed = computed;
  }

  public Expression getAttribute() {
    return attribute;
  }

  public boolean isComputed() {
    return computed;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
