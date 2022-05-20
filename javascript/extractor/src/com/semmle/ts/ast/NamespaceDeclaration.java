package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class NamespaceDeclaration extends Statement implements INodeWithSymbol {
  private final Identifier name;
  private final List<Statement> body;
  private final boolean isInstantiated;
  private final boolean hasDeclareKeyword;
  private int symbol = -1;

  public NamespaceDeclaration(
      SourceLocation loc,
      Identifier name,
      List<Statement> body,
      boolean isInstantiated,
      boolean hasDeclareKeyword) {
    super("NamespaceDeclaration", loc);
    this.name = name;
    this.body = body;
    this.isInstantiated = isInstantiated;
    this.hasDeclareKeyword = hasDeclareKeyword;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public Identifier getName() {
    return name;
  }

  public List<Statement> getBody() {
    return body;
  }

  /**
   * Returns whether this is an instantiated namespace.
   *
   * <p>Non-instantiated namespaces only contain interface types, type aliases, and other
   * non-instantiated namespaces. The TypeScript compiler does not emit code for non-instantiated
   * namespaces.
   */
  public boolean isInstantiated() {
    return isInstantiated;
  }

  public boolean hasDeclareKeyword() {
    return hasDeclareKeyword;
  }

  @Override
  public int getSymbol() {
    return this.symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }
}
