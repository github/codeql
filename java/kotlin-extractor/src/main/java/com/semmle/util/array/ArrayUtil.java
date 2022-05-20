package com.semmle.util.array;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

import com.semmle.util.basic.ObjectUtil;

/**
 * Convenience methods for manipulating arrays.
 */
public class ArrayUtil
{
	
	/**
	 * A number slightly smaller than the maximum length of an array on most vms. 
	 * This matches the constant in ArrayList.
	 */
	public static final int MAX_ARRAY_LENGTH = Integer.MAX_VALUE - 8;

	/**
	 * Comparator for primitive int values.
	 */
	public static interface IntComparator
	{
		/**
		 * Compare ints {@code a} and {@code b}, returning a negative value if {@code a} is 'less' than
		 * {@code b}, zero if they are equal, otherwise a positive value.
		 */
		public int compare (int a, int b);
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(boolean[] array, boolean value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(byte[] array, byte value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(char[] array, char value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(double[] array, double value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(float[] array, float value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}


	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no such element.
	 */
	public static int findFirst(int[] array, int value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no element for which {@code value.equals(element)} is true.
	 *
	 * @see #findFirstSame(Object[], Object)
	 */
	public static <T> int findFirst(T[] array, T value)
	{
		for(int i=0; i<array.length; ++i) {
			if (ObjectUtil.equals(value, array[i])) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * Find the index of the first occurrence of the given {@code value} in the given {@code array},
	 * returning -1 if there is no element for which {@code value == element}.
	 *
	 * @see #findFirstSame(Object[], Object)
	 */
	public static <T> int findFirstSame(T[] array, T value)
	{
		for(int i=0; i<array.length; ++i) {
			if (value == array[i])
				return i;
		}
		return -1;
	}

	/**
	 * Query whether the given {@code array} contains any element equal to the given {@code element}.
	 */
	public static boolean contains (int element, int ... array)
	{
		return findFirst(array, element) != -1;
	}

	

	/**
	 * Query whether the given {@code array} contains any element equal to the given {@code element}.
	 */
	@SafeVarargs
	public static <T> boolean contains (T element, T ... array)
	{
		return findFirst(array, element) != -1;
	}

	/**
	 * Construct a new array with length increased by one, containing all elements of a given array
	 * followed by an additional element.
	 */
	public static <T> T[] append (T[] array, T element)
	{
		array = Arrays.copyOf(array, array.length + 1);
		array[array.length-1] = element;
		return array;
	}

	/**
	 * Construct a new array containing the concatenation of the elements in a number of arrays.
	 *
	 * @param arrays The arrays to concatenate; may be null (in which case the result will be null).
	 *          Null elements will be treated as empty arrays.
	 * @return If {@code arrays} is null, a null array, otherwise a newly allocated array containing
	 *         the elements of every non-null array in {@code arrays} concatenated consecutively.
	 */
	public static byte[] concatenate (byte[] ... arrays)
	{
		// Quick break-out if arrays is null
		if (arrays == null) {
			return null;
		}
		// Find the total length that will be required
		int totalLength = 0;
		for(byte[] array : arrays) {
			totalLength += array == null ? 0 : array.length;
		}
		// Allocate a new array for the concatenation
		byte[] concatenation = new byte[totalLength];
		// Copy each non-null array into the concatenation
		int offset = 0;
		for(byte[] array : arrays) {
			if (array != null) {
				System.arraycopy(array, 0, concatenation, offset, array.length);
				offset += array.length;
			}
		}

		return concatenation;
	}

	/** Trivial short-hand for building an array (returns {@code elements} unchanged). */
	public static <T> T[] toArray (T ... elements)
	{
		return elements;
	}
	
	/**
	 * Swap two elements in an array.
	 *
	 * @param array The array containing the elements to be swapped; must be non-null.
	 * @param index1 The index of the first element to swap; must be in-bounds.
	 * @param index2 The index of the second element to swap; must be in-bounds.
	 * @return The given {@code array}.
	 */
	public static int[] swap (int[] array, int index1, int index2)
	{
		int value     = array[index1];
		array[index1] = array[index2];
		array[index2] = value;

		return array;
	}

	/**
	 * Returns a fresh Set containing all the elements in the array.
	 *
	 * @param <T>
	 *            the class of the objects in the array
	 * @param array
	 *            the array containing the elements
	 * @return a Set containing all the elements in the array.
	 */
	@SafeVarargs
	public static <T> Set<T> asSet (T ... array)
	{
		Set<T> ts = new LinkedHashSet<>();
		Collections.addAll(ts, array);
		return ts;
	}
}
