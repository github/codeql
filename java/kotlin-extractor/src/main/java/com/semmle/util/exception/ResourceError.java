package com.semmle.util.exception;

/**
 * This is a standard Semmle unchecked exception.
 * Usage of this should follow the guidelines described in docs/semmle-unchecked-exceptions.md
 */
public class ResourceError extends NestedError {

	private static final long serialVersionUID = 4132771414092814913L;

	public ResourceError(String message) {
		super(message);
	}

	@Deprecated // A ResourceError may be presented to the user, so should always have a message
	public ResourceError(Throwable throwable) {
		super(throwable);
	}
	
	public ResourceError(String message, Throwable throwable) {
		super(message,throwable);
	}

	@Override
	public String toString() {
		// The message here should always be meaningful enough that we can return that.
		return getMessage() != null ? getMessage() : super.toString();
	}
	
}
