package com.semmle.js.ast;

import java.util.List;

import com.semmle.ts.ast.ITypeExpression;

/**
 * A <code>new</code> expression.
 */
public class NewExpression extends InvokeExpression {
	public NewExpression(SourceLocation loc, Expression callee, List<ITypeExpression> typeArguments, List<Expression> arguments) {
		super("NewExpression", loc, callee, typeArguments, arguments, false, false);
	}

	@Override
	public <Q, A> A accept(Visitor<Q, A> v, Q q) {
		return v.visit(this, q);
	}
}
