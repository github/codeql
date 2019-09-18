package com.semmle.ts.ast;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class EnumMember extends Node implements INodeWithSymbol {
  private final Identifier id;
  private final Expression initializer;
  private int typeSymbol = -1;

  public EnumMember(SourceLocation loc, Identifier id, Expression initializer) {
    super("EnumMember", loc);
    this.id = id;
    this.initializer = initializer;
  }

  public Identifier getId() {
    return id;
  }

  /**
   * Returns the initializer expression, or {@code null} if this enum member has no explicit
   * initializer.
   */
  public Expression getInitializer() {
    return initializer;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public int getSymbol() {
    return typeSymbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.typeSymbol = symbol;
  }
}
