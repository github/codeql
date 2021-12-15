package com.semmle.js.ast;

public class DynamicImport extends Expression {
  private final Expression source;

  public DynamicImport(SourceLocation loc, Expression source) {
    super("DynamicImport", loc);
    this.source = source;
  }

  public Expression getSource() {
    return source;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
