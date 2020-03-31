package com.semmle.js.ast;

import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.util.data.IntList;
import java.util.ArrayList;
import java.util.List;

public class AFunction<B> {
  private final Identifier id;
  private final List<IPattern> params, allParams;
  private final List<Expression> rawParams, defaults;
  private final IPattern rest;
  private final B body;
  private final boolean generator, async;
  private final List<TypeParameter> typeParameters;
  private final ITypeExpression returnType;
  private final List<ITypeExpression> parameterTypes;
  private final ITypeExpression thisParameterType;
  private final List<DecoratorList> parameterDecorators;
  private final IntList optionalParameterIndices;

  public static final IntList noOptionalParams = IntList.create(0, 0);

  public AFunction(
      Identifier id,
      List<Expression> params,
      B body,
      boolean generator,
      boolean async,
      List<TypeParameter> typeParameters,
      List<ITypeExpression> parameterTypes,
      List<DecoratorList> parameterDecorators,
      ITypeExpression returnType,
      ITypeExpression thisParameterType,
      IntList optionalParameterIndices) {
    this.id = id;
    this.params = new ArrayList<IPattern>(params.size());
    this.defaults = new ArrayList<Expression>(params.size());
    this.parameterTypes = parameterTypes;
    this.body = body;
    this.generator = generator;
    this.async = async;
    this.rawParams = params;
    this.typeParameters = typeParameters;
    this.returnType = returnType;
    this.thisParameterType = thisParameterType;
    this.parameterDecorators = parameterDecorators;
    this.optionalParameterIndices = optionalParameterIndices;

    IPattern rest = null;
    for (Expression param : params) {
      if (param instanceof RestElement) {
        rest = (IPattern) ((RestElement) param).getArgument();
      } else if (param instanceof AssignmentPattern) {
        AssignmentPattern ap = (AssignmentPattern) param;
        this.params.add((IPattern) ap.getLeft());
        this.defaults.add(ap.getRight());
      } else {
        // workaround for parser bug, which currently (erroneously) accepts
        // async arrow functions with parens around their parameters
        param = param.stripParens();
        this.params.add((IPattern) param);
        this.defaults.add(null);
      }
    }
    this.rest = rest;

    this.allParams = new ArrayList<IPattern>(this.params);
    if (rest != null) this.allParams.add(rest);
  }

  /** Does this function have a name? */
  public boolean hasId() {
    return id != null;
  }

  public Identifier getId() {
    return id;
  }

  public List<IPattern> getParams() {
    return params;
  }

  public boolean hasDefault(int i) {
    return i < defaults.size();
  }

  public Expression getDefault(int i) {
    if (i >= defaults.size()) return null;
    return defaults.get(i);
  }

  public boolean hasRest() {
    return rest != null;
  }

  public IPattern getRest() {
    return rest;
  }

  public B getBody() {
    return body;
  }

  public boolean isGenerator() {
    return generator;
  }

  public boolean isAsync() {
    return async;
  }

  public List<IPattern> getAllParams() {
    return allParams;
  }

  public List<Expression> getRawParams() {
    return rawParams;
  }

  public ITypeExpression getReturnType() {
    return returnType;
  }

  public boolean hasParameterType(int i) {
    return getParameterType(i) != null;
  }

  public ITypeExpression getParameterType(int i) {
    if (i >= parameterTypes.size()) return null;
    return parameterTypes.get(i);
  }

  public List<ITypeExpression> getParameterTypes() {
    return parameterTypes;
  }

  public List<TypeParameter> getTypeParameters() {
    return typeParameters;
  }

  public ITypeExpression getThisParameterType() {
    return thisParameterType;
  }

  public List<DecoratorList> getParameterDecorators() {
    return parameterDecorators;
  }

  public IntList getOptionalParmaeterIndices() {
    return optionalParameterIndices;
  }
}
