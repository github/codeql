package com.semmle.ts.ast;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.MemberDefinition;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.Visitor;
import java.util.List;

/** A TypeScript interface declaration. */
public class InterfaceDeclaration extends Statement implements INodeWithSymbol {
  private final Identifier name;
  private final List<TypeParameter> typeParameters;
  private final List<ITypeExpression> superInterfaces;
  private final List<MemberDefinition<?>> body;
  private int typeSymbol = -1;

  public InterfaceDeclaration(
      SourceLocation loc,
      Identifier name,
      List<TypeParameter> typeParameters,
      List<ITypeExpression> superInterfaces,
      List<MemberDefinition<?>> body) {
    super("InterfaceDeclaration", loc);
    this.name = name;
    this.typeParameters = typeParameters;
    this.superInterfaces = superInterfaces;
    this.body = body;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public Identifier getName() {
    return name;
  }

  public List<TypeParameter> getTypeParameters() {
    return typeParameters;
  }

  public boolean hasTypeParameters() {
    return !typeParameters.isEmpty();
  }

  public List<MemberDefinition<?>> getBody() {
    return body;
  }

  public List<ITypeExpression> getSuperInterfaces() {
    return superInterfaces;
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
