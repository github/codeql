package com.semmle.util.exception;

import java.util.Arrays;

/**
 * This is a standard Semmle unchecked exception.
 * Usage of this should follow the guidelines described in docs/semmle-unchecked-exceptions.md
 */
public class CatastrophicError extends NestedError {

	private static final long serialVersionUID = 4132771414092814913L;

	public CatastrophicError(String message) {
		super(message);
	}

	public CatastrophicError(Throwable throwable) {
		super(throwable);
	}

	public CatastrophicError(String message, Throwable throwable) {
		super(message,throwable);
	}

	/**
	 * Utility method for throwing a {@link CatastrophicError} with the given {@code message} if the given
	 * {@code condition} is true.
	 */
	public static void throwIf(boolean condition, String message)
	{
		if (condition) {
			throw new CatastrophicError(message);
		}
	}

	/**
	 * Utility method for throwing a {@link CatastrophicError} if the given {@code object} is null.
	 * <p>
	 * See {@link #throwIfAnyNull(Object...)} which may be more convenient for checking multiple
	 * arguments.
	 * </p>
	 */
	public static void throwIfNull(Object object)
	{
		if (object == null) {
			throw new CatastrophicError("null object");
		}
	}

	/**
	 * Utility method for throwing a {@link CatastrophicError} with the given {@code message} if the given
	 * {@code object} is null.
	 * <p>
	 * See {@link #throwIfAnyNull(Object...)} which may be more convenient for checking multiple
	 * arguments.
	 * </p>
	 */
	public static void throwIfNull (Object object, String message)
	{
		if (object == null) {
			throw new CatastrophicError(message);
		}
	}

	/**
	 * Throw a {@link CatastrophicError} if any of the given {@code objects} is null.
	 * <p>
	 * If a {@link CatastrophicError} is thrown, its message will indicate <i>all</i> null arguments by index.
	 * </p>
	 * <p>
	 * See {@link #throwIfNull(Object, String)} which may be a fraction more efficient if there's only
	 * one argument, and allows an 'optional' message parameter.
	 * </p>
	 */
	public static void throwIfAnyNull (Object ... objects)
	{
		/*
		 * Check each argument for nullity, and start building a set of index strings iff at least one
		 * is non-null
		 */
		String[] nullArgs = null;
		for (int argNum = 0; argNum < objects.length; ++argNum) {
			if (objects[argNum] == null) {
				nullArgs = nullArgs == null ? new String[1] : Arrays.copyOf(nullArgs, nullArgs.length+1);
				nullArgs[nullArgs.length-1] = "" + argNum;
			}
		}
		if (nullArgs != null) {
			// Compose a message describing which arguments are null
			StringBuffer strBuf = new StringBuffer();
			if (nullArgs.length == 0) {
				strBuf.append("null argument(s)");
			} else {
				strBuf.append("null argument" + (nullArgs.length > 1 ? "s: " : ": ") + nullArgs[0]);
				for (int i = 1; i < nullArgs.length; ++i) {
					strBuf.append(", " + nullArgs[i]);
				}
			}
			String message = strBuf.toString();
			throw new CatastrophicError(message);
		}
	}

	/**
	 * Convenience method for use in constructors that assign a parameter to a
	 * field, assuming the former to be non-null.
	 *
	 * @param t A non-null value of type {@code T}.
	 * @return {@code t}
	 * @throws CatastrophicError if {@code t} is null.
	 * @see #throwIfNull(Object)
	 */
	public static <T> T nonNull(T t) {
		throwIfNull(t);
		return t;
	}
}
