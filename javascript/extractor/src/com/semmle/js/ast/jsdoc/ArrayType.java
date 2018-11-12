package com.semmle.js.ast.jsdoc;

import java.util.List;

import com.semmle.js.ast.SourceLocation;

/**
 * An array type expression such as <code>[number]</code>.
 */
public class ArrayType extends CompoundType {
	public ArrayType(SourceLocation loc, List<JSDocTypeExpression> elements) {
		super("ArrayType", loc, elements);
	}

	@Override
	public String pp() {
		return "[" + super.pp(", ") + "]";
	}

	@Override
	public void accept(Visitor v) {
		v.visit(this);
	}
}
