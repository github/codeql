package com.semmle.ts.ast;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/**
 * A type error emitted by the TypeScript compiler.
 */
public class TypeErrorDetails extends SourceElement {
	private int code;
	private String message;
	
	public TypeErrorDetails(SourceLocation location, int code, String message) {
		super(location);
		this.code = code;
		this.message = message;
	}
	
	public int getCode() {
		return code;
	}
	
	public String getMessage() {
		return message;
	}
}
