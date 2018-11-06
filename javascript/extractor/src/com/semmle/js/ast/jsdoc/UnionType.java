package com.semmle.js.ast.jsdoc;

import java.util.List;

import com.semmle.js.ast.SourceLocation;

/**
 * A union type expression.
 */
public class UnionType extends CompoundType {
	public UnionType(SourceLocation loc, List<JSDocTypeExpression> elements) {
		super("UnionType", loc, elements);
	}

	@Override
	public String pp() {
		return "(" + super.pp("|") + ")";
	}

	@Override
	public void accept(Visitor v) {
		v.visit(this);
	}
}
