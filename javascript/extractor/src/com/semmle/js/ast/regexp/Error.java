package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/**
 * An error encountered while parsing a regular expression.
 */
public class Error extends SourceElement {
	private final int code;

	public Error(SourceLocation loc, Number code) {
		super(loc);
		this.code = code.intValue();
	}

	/**
	 * The error code.
	 */
	public int getCode() {
		return code;
	}
}
