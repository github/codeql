package com.semmle.js.ast;

import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.util.data.IntList;
import java.util.List;

/**
 * A function expression, which may be either an {@link ArrowFunctionExpression} or a normal {@link
 * FunctionExpression}.
 */
public abstract class AFunctionExpression extends Expression implements IFunction {
  private final AFunction<? extends Node> fn;
  private int symbol = -1;
  private int declaredSignature = -1;

  public AFunctionExpression(
      String type,
      SourceLocation loc,
      Identifier id,
      List<Expression> params,
      Node body,
      Boolean generator,
      Boolean async,
      List<TypeParameter> typeParameters,
      List<ITypeExpression> parameterTypes,
      List<DecoratorList> parameterDecorators,
      ITypeExpression returnType,
      ITypeExpression thisParameterType,
      IntList optionalParameterIndices) {
    super(type, loc);
    this.fn =
        new AFunction<Node>(
            id,
            params,
            body,
            generator == Boolean.TRUE,
            async == Boolean.TRUE,
            typeParameters,
            parameterTypes,
            parameterDecorators,
            returnType,
            thisParameterType,
            optionalParameterIndices);
  }

  public AFunctionExpression(String type, SourceLocation loc, AFunction<? extends Node> fn) {
    super(type, loc);
    this.fn = fn;
  }

  @Override
  public Identifier getId() {
    return fn.getId();
  }

  @Override
  public List<IPattern> getParams() {
    return fn.getParams();
  }

  @Override
  public boolean hasDefault(int i) {
    return fn.hasDefault(i);
  }

  @Override
  public Expression getDefault(int i) {
    return fn.getDefault(i);
  }

  @Override
  public IPattern getRest() {
    return fn.getRest();
  }

  @Override
  public Node getBody() {
    return fn.getBody();
  }

  @Override
  public boolean hasRest() {
    return fn.hasRest();
  }

  public boolean hasId() {
    return fn.hasId();
  }

  public boolean isGenerator() {
    return fn.isGenerator();
  }

  public boolean isAsync() {
    return fn.isAsync();
  }

  public List<IPattern> getAllParams() {
    return fn.getAllParams();
  }

  @Override
  public List<Expression> getRawParameters() {
    return fn.getRawParams();
  }

  public ITypeExpression getReturnType() {
    return fn.getReturnType();
  }

  public boolean hasParameterType(int i) {
    return fn.hasParameterType(i);
  }

  public ITypeExpression getParameterType(int i) {
    return fn.getParameterType(i);
  }

  public List<ITypeExpression> getParameterTypes() {
    return fn.getParameterTypes();
  }

  public List<TypeParameter> getTypeParameters() {
    return fn.getTypeParameters();
  }

  public ITypeExpression getThisParameterType() {
    return fn.getThisParameterType();
  }

  public List<DecoratorList> getParameterDecorators() {
    return fn.getParameterDecorators();
  }

  @Override
  public boolean hasDeclareKeyword() {
    return false;
  }

  @Override
  public int getSymbol() {
    return symbol;
  }

  @Override
  public void setSymbol(int symbol) {
    this.symbol = symbol;
  }

  @Override
  public int getDeclaredSignatureId() {
    return declaredSignature;
  }

  @Override
  public void setDeclaredSignatureId(int id) {
    declaredSignature = id;
  }

  public IntList getOptionalParameterIndices() {
    return fn.getOptionalParmaeterIndices();
  }
}
