package com.semmle.util.data;

import java.io.Serializable;

/**
 * Untyped base-class for the generic {@link Tuple1}, {@link Tuple2}, ... <i>etc.</i>
 * <p>
 * This class also functions as a zero-element tuple.
 * </p>
 */
public class TupleN implements Serializable
{
	private static final long serialVersionUID = -1799116497122427806L;

	/**
	 * Get the n'th value contained by this {@link TupleN}.
	 *
	 * @param n The zero-based index of the value to be returned.
	 * @return The n'th value, or null if n is out of range.
	 */
	public final Object value (int n)
	{
		return n < 0 || n > size() ? null : value_(n);
	}

	/** Internal method for obtaining the n'th value (n is guaranteed to be in-range). */
	protected Object value_ (int n)
	{
		return null;
	}

	/**
	 * Get the number of values contained by this {@link TupleN}.
	 */
	public int size ()
	{
		return 0;
	}

	/**
	 * Return a plain string representation of the contained value (where null is represented by the
	 * empty string).
	 * <p>
	 * Sub-classes shall implement a comma-separated concatenation.
	 * </p>
	 */
	public String toPlainString ()
	{
		return "";
	}

	/**
	 * Get a parenthesized, comma-separated string representing the values contained by this
	 * {@link TupleN}. Null values are represented by an empty string.
	 */
	@Override
	public final String toString ()
	{
		return "(" + toPlainString() + ")";
	}

	@Override
	public int hashCode ()
	{
		return 0;
	}

	@Override
	public boolean equals (Object obj)
	{
		return obj == this || (obj !=null && obj.getClass().equals(getClass()));
	}

	/**
	 * Convenience method implementing objects.equals(object, object), which is not available due to a
	 * java version restriction.
	 */
	protected static boolean equal(Object obj1, Object obj2)
	{
		if (obj1 == null) {
			return obj2 == null;
		}
		return obj1.equals(obj2);
	}
}
