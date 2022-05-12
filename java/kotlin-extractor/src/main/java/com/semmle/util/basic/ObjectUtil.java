package com.semmle.util.basic;

/**
 * Trivial utility methods.
 */
public class ObjectUtil {

	/** Query if {@code object1} and {@code object2} are reference-equal, or both null. */
	public static boolean isSame (Object object1, Object object2)
	{
		return object1 == object2; // Reference equality comparison is deliberate
	}

	/**
	 * Query if {@code object1} and {@code object2} are both null, or both non-null and equal
	 * according to {@link Object#equals(Object)} (applied as {@code object1.equals(object2)}).
	 */
	public static boolean equals (Object object1, Object object2)
	{
		return object1 == null ? object2 == null : object1.equals(object2);
	}

	/**
	 * Query whether {@code object} is equal to any element in {@code objects}, short-circuiting
	 * the evaluation if possible.
	 */
	public static boolean equalsAny (Object object, Object ... objects)
	{
		// Quick break-out if there are no objects to be equal to
		if (objects == null || objects.length == 0) {
			return false;
		}
		// Compare against each object in turn
		for(Object other : objects) {
			if (equals(object, other)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * Return {@code object1.compareTo(object2)}, but handle the case of null input by returning 0 if
	 * both objects are null, or 1 if only {@code object1} is null (implying that null is always
	 * 'greater' than non-null).
	 */
	public static <T1, T2 extends T1> int compareTo (Comparable<T1> object1, T2 object2)
	{
		if (object1 == null) {
			return object2 == null ? 0 : 1;
		}
		return object1.compareTo(object2);
	}

	/**
	 * Return {@code value} if non-null, otherwise {@code replacement}.
	 */
	public static <T> T replaceNull (T value, T replacement)
	{
		return value == null ? replacement : value;
	}
	
	@SafeVarargs
	public static <T> T nullCoalesce(T... values) {
		for(T value : values) {
			if (value != null) {
				return value;
			}
		}
		return null;
	}
}
