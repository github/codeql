package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import com.semmle.util.data.IntList;
import java.util.Collections;
import java.util.List;

/** An arrow function expression such as <code>(x) =&gt; x*x</code>. */
public class ArrowFunctionExpression extends AFunctionExpression {
  public ArrowFunctionExpression(
      SourceLocation loc, List<Expression> params, Node body, Boolean generator, Boolean async) {
    super(
        "ArrowFunctionExpression",
        loc,
        null,
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

  public ArrowFunctionExpression(
      SourceLocation loc,
      List<Expression> params,
      Node body,
      Boolean generator,
      Boolean async,
      List<TypeParameter> typeParameters,
      List<ITypeExpression> parameterTypes,
      ITypeExpression returnType,
      IntList optionalParameterIndices) {
    super(
        "ArrowFunctionExpression",
        loc,
        null,
        params,
        body,
        generator,
        async,
        typeParameters,
        parameterTypes,
        Collections.emptyList(),
        returnType,
        null,
        optionalParameterIndices);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
