package com.semmle.util.exception;

/**
 * This is a standard Semmle unchecked exception.
 * Usage of this should follow the guidelines described in docs/semmle-unchecked-exceptions.md
 */
public class UserError extends NestedError {

	private static final long serialVersionUID = 4132771414092814913L;

	private final boolean reportAsInfoMessage;
	
	public UserError(String message) {
		this(message, false);
	}
	
	/**
	 * A user-visible error
	 * 
	 * @param message The message to display
	 * @param reportAsInfoMessage If <code>true</code>, report as information only - not an error
	 */
	public UserError(String message, boolean reportAsInfoMessage) {
		super(message);
		this.reportAsInfoMessage = reportAsInfoMessage;
	}
	
	public UserError(String message, Throwable throwable) {
		super(message,throwable);
		this.reportAsInfoMessage = false;
	}
	
	/**
	 * If <code>true</code>, report the message without interpreting it as a fatal error
	 */
	public boolean reportAsInfoMessage() {
		return reportAsInfoMessage;
	}

	@Override
	public String toString() {
		// The message here should always be meaningful enough that we can return that.
		return getMessage() != null ? getMessage() : super.toString();
	}

}
