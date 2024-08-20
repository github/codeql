package com.semmle.util.exception;

import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Simple functions for printing exceptions. This is intended for use
 * in debug output, not for formatting for user consumption
 */
public class Exceptions {

	/**
	 * Compose a String with the same format as that output by {@link Throwable#printStackTrace()}.
	 */
	public static String printStackTrace(Throwable t)
	{
		StringWriter stringWriter = new StringWriter();
		t.printStackTrace(new PrintWriter(stringWriter));
		return stringWriter.toString();
	}

	/**
	 * Print an exception in a readable format with all information,
	 * including the type, message, stack trace, and nested exceptions
	 */
	public static String print(Throwable t) {
		return printDetailed(t, true);
	}

	/**
	 * Print an exception in a somewhat readable format fitting on one line.
	 * Most of the time simply using <code>print</code> is preferable
	 */
	public static String printShort(Throwable t) {
		return printDetailed(t, false);
	}

	/**
	 * Ignore an exception. This method does nothing, but should be called
	 * (with a reasonable message) to document the reason why the exception does
	 * not need to be used.
	 */
	public static void ignore(Throwable e, String message) {

	}

	/**
	 * Print an exception in a long format, possibly producing multiple
	 * lines if the appropriate flag is passed
	 * @param multiline if <code>true</code>, produce multiple lines of output
	 */
	private static String printDetailed(Throwable t, boolean multiline) {
		StringBuilder sb = new StringBuilder();

		Throwable current = t;
		while (current != null) {
			printOneException(current, multiline, sb);
			Throwable cause = current.getCause();
			if (cause == current)
				current = null;
			else
				current = cause;

			if (current != null) {
				if (multiline)
					sb.append("\n\n ... caused by:\n\n");
				else
					sb.append(", caused by: ");
			}
		}

		return sb.toString();
	}

	private static void printOneException(Throwable t, boolean multiline, StringBuilder sb) {
		sb.append(multiline ? t.toString() : t.toString().replace('\n', ' ').replace('\r', ' '));
		boolean first = true;
		for (StackTraceElement e : t.getStackTrace()) {
			if (first)
				sb.append(multiline ? "\n" : " - [");
			else
				sb.append(multiline ? "\n" : ", ");
			first = false;
			sb.append(e.toString());
		}
		if (!multiline)
			 sb.append("]");
	}

	/** A stand-in replacement for `assert` that throws a {@link CatastrophicError} and isn't compiled out. */
	public static void assertion(boolean cond, String message) {
		if(!cond)
			throw new CatastrophicError(message);
	}
	
	/**
	 * Turn the given {@link Throwable} into a {@link RuntimeException} by wrapping it if necessary.
	 */
	public static RuntimeException asUnchecked(Throwable t) {
		if (t instanceof RuntimeException)
			return (RuntimeException)t;
		else
			return new RuntimeException(t);
	}
	
	/**
	 * Throws an arbitrary {@link Throwable}, wrapping in a runtime exception if necessary.
	 * Unlike {@link #asUnchecked} it preserves subclasses of {@link Error}.
	 */
	public static <T> T rethrowUnchecked(Throwable t) {
		if (t instanceof RuntimeException) {
			throw (RuntimeException) t;
		} else if (t instanceof Error) {
			throw (Error) t;
		}
		throw new RuntimeException(t);
	}


}
