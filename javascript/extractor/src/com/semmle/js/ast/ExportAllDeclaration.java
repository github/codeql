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
  private final Expression assertion;

  public ExportAllDeclaration(SourceLocation loc, Literal source, Expression assertion) {
    super("ExportAllDeclaration", loc);
    this.source = source;
    this.assertion = assertion;
  }

  public Literal getSource() {
    return source;
  }

  public Expression getAssertion() {
    return assertion;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
