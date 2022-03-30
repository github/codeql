package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;
import java.util.List;

/** A function call expression such as <code>f(1, 1)</code>. */
public class CallExpression extends InvokeExpression {
  public CallExpression(
      SourceLocation loc,
      Expression callee,
      List<ITypeExpression> typeArguments,
      List<Expression> arguments,
      Boolean optional,
      Boolean onOptionalChain) {
    super("CallExpression", loc, callee, typeArguments, arguments, optional, onOptionalChain);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
