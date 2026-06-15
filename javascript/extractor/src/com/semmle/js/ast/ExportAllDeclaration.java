package com.semmle.js.ast;

/**
 * A re-export declaration of the form
 *
 * <pre>
 *   export * from 'foo';
 * </pre>
 */
public class ExportAllDeclaration extends ExportDeclaration {
  private final Literal source;
  private final Expression attributes;

  public ExportAllDeclaration(SourceLocation loc, Literal source, Expression attributes) {
    super("ExportAllDeclaration", loc);
    this.source = source;
    this.attributes = attributes;
  }

  public Literal getSource() {
    return source;
  }

  public Expression getAttributes() {
    return attributes;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
