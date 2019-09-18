package com.semmle.js.ast;

/**
 * A default export declaration of the form
 *
 * <pre>
 *   export default function f() { return 23; };
 * </pre>
 *
 * or
 *
 * <pre>
 *   export default 42;
 * </pre>
 */
public class ExportDefaultDeclaration extends ExportDeclaration {
  /**
   * Either an {@linkplain Expression} or a {@linkplain FunctionDeclaration} or a {@linkplain
   * ClassDeclaration}.
   */
  private final Node declaration;

  public ExportDefaultDeclaration(SourceLocation loc, Node declaration) {
    super("ExportDefaultDeclaration", loc);
    this.declaration = declaration;
  }

  public Node getDeclaration() {
    return declaration;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
