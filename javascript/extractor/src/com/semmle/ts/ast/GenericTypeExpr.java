package com.semmle.ts.ast;

import java.util.List;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * An instantiation of a named type, such as <tt>Array&lt;number&gt;</tt>
 */
public class GenericTypeExpr extends TypeExpression {
	final private ITypeExpression typeName; // Always Identifier or MemberExpression
	final private List<ITypeExpression> typeArguments;

	public GenericTypeExpr(SourceLocation loc, ITypeExpression typeName, List<ITypeExpression> typeArguments) {
		super("GenericTypeExpr", loc);
		this.typeName = typeName;
		this.typeArguments = typeArguments;
	}

	public ITypeExpression getTypeName() {
		return typeName;
	}

	public List<ITypeExpression> getTypeArguments() {
		return typeArguments;
	}

	@Override
	public <C, R> R accept(Visitor<C, R> v, C c) {
		return v.visit(this, c);
	}
}
