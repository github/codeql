package com.semmle.util.exception;

public abstract class NestedError extends RuntimeException {

	private static final long serialVersionUID = -3145876396931008989L;

	public NestedError(String message) {
		super(message);
	}

	public NestedError(Throwable throwable) {
		super(throwable);
	}

	public NestedError(String message, Throwable throwable) {
		super(buildMessage(message, throwable), throwable);
	}

	/**
	 * Subclasses should not need to call this directly -- just call the
	 * two-argument super constructor.
	 */
	private static String buildMessage(String message, Throwable throwable) {
		if (throwable == null)
			return message;

		while (throwable.getCause() != null && throwable.getCause() != throwable)
			throwable = throwable.getCause();
		String banner = "eventual cause: " + throwable.getClass().getSimpleName();
		String rootmsg = throwable.getMessage();
		if (rootmsg == null) {
			// Don't amend the banner
		} else {
			int p = rootmsg.indexOf('\n');
			if (p >= 0)
				rootmsg = rootmsg.substring(0, p) + "...";
			if (rootmsg.length() > 100)
				rootmsg = rootmsg.substring(0, 80) + "...";
			banner += " \"" + rootmsg + "\"";
		}
		if (message.contains(banner))
			return message;
		else
			return message + "\n(" + banner + ")";
	}

}
