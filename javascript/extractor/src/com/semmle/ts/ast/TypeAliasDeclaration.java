package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class TypeAliasDeclaration extends Statement implements INodeWithSymbol {
  private final Identifier name;
  private final List<TypeParameter> typeParameters;
  private final ITypeExpression definition;
  private int typeSymbol = -1;

  public TypeAliasDeclaration(
      SourceLocation loc,
      Identifier name,
      List<TypeParameter> typeParameters,
      ITypeExpression definition) {
    super("TypeAliasDeclaration", loc);
    this.name = name;
    this.typeParameters = typeParameters;
    this.definition = definition;
  }

  public Identifier getId() {
    return name;
  }

  public List<TypeParameter> getTypeParameters() {
    return typeParameters;
  }

  public boolean hasTypeParameters() {
    return !typeParameters.isEmpty();
  }

  public ITypeExpression getDefinition() {
    return definition;
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
