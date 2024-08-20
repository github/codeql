package com.semmle.util.concurrent;

import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;


/**
 * Utility methods related to Threads.
 */
public enum ThreadUtil
{
	/** Singleton instance of {@link ThreadUtil}. */
	SINGLETON;

	/**
	 * Sleep for {@code millis} milliseconds.
	 * <p>
	 * Unlike {@link Thread#sleep(long)} (which is wrapped), this method does not throw an
	 * {@link InterruptedException}, rather in the event of interruption it either throws an
	 * {@link CatastrophicError} (if {@code allowInterrupt} is false), or accepts the interruption and
	 * returns false.
	 * </p>
	 *
	 * @return true if a sleep of {@code millis} milliseconds was performed without interruption, or
	 *         false if an interruption occurred.
	 */
	public static boolean sleep(long millis, boolean allowInterrupt)
	{
		try {
			Thread.sleep(millis);
		}
		catch (InterruptedException ie) {
			if (allowInterrupt) {
				Exceptions.ignore(ie, "explicitly permitted interruption");
				return false;
			}
			else {
				throw new CatastrophicError("Interrupted", ie);
			}
		}
		return true;
	}
}
