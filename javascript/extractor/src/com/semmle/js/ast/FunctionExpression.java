package com.semmle.js.ast;

import com.semmle.ts.ast.DecoratorList;
import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.util.data.IntList;
import java.util.Collections;
import java.util.List;

/** A plain function expression. */
public class FunctionExpression extends AFunctionExpression {
  public FunctionExpression(
      SourceLocation loc,
      Identifier id,
      List<Expression> params,
      Node body,
      Boolean generator,
      Boolean async) {
    super(
        "FunctionExpression",
        loc,
        id,
        params,
        body,
        generator,
        async,
        Collections.emptyList(),
        Collections.emptyList(),
        Collections.emptyList(),
        null,
        null,
        AFunction.noOptionalParams);
  }

  public FunctionExpression(
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
    super(
        "FunctionExpression",
        loc,
        id,
        params,
        body,
        generator,
        async,
        typeParameters,
        parameterTypes,
        parameterDecorators,
        returnType,
        thisParameterType,
        optionalParameterIndices);
  }

  public FunctionExpression(SourceLocation loc, AFunction<? extends Node> fn) {
    super("FunctionExpression", loc, fn);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
