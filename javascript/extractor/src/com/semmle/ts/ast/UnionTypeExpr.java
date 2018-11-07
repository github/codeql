package com.semmle.ts.ast;

import java.util.List;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A union type such as <tt>number | string | boolean</tt>. */
public class UnionTypeExpr extends TypeExpression {
	private final List<ITypeExpression> elementTypes;

	public UnionTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes) {
		super("UnionTypeExpr", loc);
		this.elementTypes = elementTypes;
	}

	/** The members of the union; always contains at least two types. */
	public List<ITypeExpression> getElementTypes() {
		return elementTypes;
	}

	@Override
	public <C, R> R accept(Visitor<C, R> v, C c) {
		return v.visit(this, c);
	}
}
