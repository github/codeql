package com.semmle.ts.ast;

import com.semmle.js.ast.Decorator;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class EnumDeclaration extends Statement implements INodeWithSymbol {
  private final boolean isConst;
  private final boolean hasDeclareKeyword;
  private final List<Decorator> decorators;
  private final Identifier id;
  private List<EnumMember> members;
  private int typeSymbol = -1;

  public EnumDeclaration(
      SourceLocation loc,
      boolean isConst,
      boolean hasDeclareKeyword,
      List<Decorator> decorators,
      Identifier id,
      List<EnumMember> members) {
    super("EnumDeclaration", loc);
    this.isConst = isConst;
    this.hasDeclareKeyword = hasDeclareKeyword;
    this.decorators = decorators;
    this.id = id;
    this.members = members;
  }

  public boolean isConst() {
    return isConst;
  }

  public boolean hasDeclareKeyword() {
    return hasDeclareKeyword;
  }

  public List<Decorator> getDecorators() {
    return decorators;
  }

  public Identifier getId() {
    return id;
  }

  public List<EnumMember> getMembers() {
    return members;
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
