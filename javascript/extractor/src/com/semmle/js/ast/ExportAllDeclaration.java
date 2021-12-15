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

  public ExportAllDeclaration(SourceLocation loc, Literal source) {
    super("ExportAllDeclaration", loc);
    this.source = source;
  }

  public Literal getSource() {
    return source;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
