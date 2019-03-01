package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import java.util.ArrayList;
import java.util.List;

/** Common backing class for {@linkplain ClassDeclaration} and {@linkplain ClassExpression}. */
public class AClass implements INodeWithSymbol {
  private final Identifier id;
  private final List<TypeParameter> typeParameters;
  private final Expression superClass;
  private final List<ITypeExpression> superInterfaces;
  private final ClassBody body;
  private final List<Decorator> decorators;
  private int typeSymbol = -1;

  public AClass(
      Identifier id,
      List<TypeParameter> typeParameters,
      Expression superClass,
      List<ITypeExpression> superInterfaces,
      ClassBody body) {
    this.id = id;
    this.typeParameters = typeParameters;
    this.superClass = superClass;
    this.superInterfaces = superInterfaces;
    this.body = body;
    this.decorators = new ArrayList<Decorator>();
  }

  public Identifier getId() {
    return id;
  }

  public boolean hasId() {
    return id != null;
  }

  public List<TypeParameter> getTypeParameters() {
    return typeParameters;
  }

  public boolean hasTypeParameters() {
    return !typeParameters.isEmpty();
  }

  public Expression getSuperClass() {
    return superClass;
  }

  public boolean hasSuperClass() {
    return superClass != null;
  }

  public List<ITypeExpression> getSuperInterfaces() {
    return superInterfaces;
  }

  public ClassBody getBody() {
    return body;
  }

  public void addDecorators(List<Decorator> decorators) {
    this.decorators.addAll(decorators);
  }

  public List<Decorator> getDecorators() {
    return decorators;
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
