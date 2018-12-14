package com.semmle.ts.ast;

import java.util.List;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A tuple type, such as <tt>[number, string]</tt>.
 */
public class TupleTypeExpr extends TypeExpression {
	private final List<ITypeExpression> elementTypes;

	public TupleTypeExpr(SourceLocation loc, List<ITypeExpression> elementTypes) {
		super("TupleTypeExpr", loc);
		this.elementTypes = elementTypes;
	}

	public List<ITypeExpression> getElementTypes() {
		return elementTypes;
	}

	@Override
	public <C, R> R accept(Visitor<C, R> v, C c) {
		return v.visit(this, c);
	}
}
