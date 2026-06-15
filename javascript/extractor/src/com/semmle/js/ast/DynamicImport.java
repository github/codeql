package com.semmle.js.ast;

public class DynamicImport extends Expression {
  private final Expression source;
  private final Expression attributes;

  public DynamicImport(SourceLocation loc, Expression source, Expression attributes) {
    super("DynamicImport", loc);
    this.source = source;
    this.attributes = attributes;
  }

  public Expression getSource() {
    return source;
  }

  /**
   * Returns the second "argument" provided to the import, such as <code>{ "with": { type: "json" }}
   * </code>.
   */
  public Expression getAttributes() {
    return attributes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
