package com.semmle.util.exception;

/**
 * An exception thrown in cases where it is impossible to
 * throw the (checked) Java {@link InterruptedException},
 * eg. in visitors
 */
public class InterruptedError extends RuntimeException {

	private static final long serialVersionUID = 9163340147606765395L;

	public InterruptedError() { }

	public InterruptedError(String message, Throwable cause) {
		super(message, cause);
	}

	public InterruptedError(String message) {
		super(message);
	}

	public InterruptedError(Throwable cause) {
		super(cause);
	}

}
