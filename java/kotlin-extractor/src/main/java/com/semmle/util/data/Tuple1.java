package com.semmle.util.data;

import java.io.Serializable;


/**
 * Tuple of one typed element.
 * <p>
 * Note that this is a sub-class of {@link TupleN} and a super-class of {@link Tuple2},
 * {@link Tuple3}, and any subsequent extensions in a similar vein.
 * </p>
 */
public class Tuple1 <Type0> extends TupleN
{
	/**
	 * Serializable variant of {@link Tuple1}.
	 */
	public static class SerializableTuple1<T0 extends Serializable>
		extends Tuple1<T0> implements Serializable {

		private static final long serialVersionUID = -7989122667707773448L;

		public SerializableTuple1() {
		}

		public SerializableTuple1(T0 t0) {
			super(t0);
		}
	}

	private static final long serialVersionUID = -4317563803154647477L;

	/** The single contained value. */
	protected Type0 _value0;


	/** Construct a new {@link Tuple1} with a null value. */
	public Tuple1 () {}

	/** Construct a new {@link Tuple1} with the given value. */
	public Tuple1 (Type0 value0)
	{
		_value0 = value0;
	}

	/** Construct a new {@link Tuple1} with the given value. */
	public static <Type0> Tuple1<Type0> make(Type0 value0)
	{
		return new Tuple1<Type0>(value0);
	}

	/**
	 * Get the value contained by this {@link Tuple1}.
	 */
	public final Type0 value0 ()
	{
		return _value0;
	}

	@Override
	protected Object value_ (int n)
	{
		return _value0;
	}

	/**
	 * Return the number of elements in this {@link Tuple1}.
	 * <p>
	 * Sub-classes shall override this method to increase its value accordingly.
	 * </p>
	 */
	@Override
	public int size ()
	{
		return 1;
	}

	/**
	 * Return a plain string representation of the contained value (where null is represented by the
	 * empty string).
	 * <p>
	 * Sub-classes shall implement a comma-separated concatenation.
	 * </p>
	 */
	@Override
	public String toPlainString ()
	{
		return _value0 == null ? "" : _value0.toString();
	}

	@Override
	public int hashCode ()
	{
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((_value0 == null) ? 0 : _value0.hashCode());
		return result;
	}

	@Override
	public boolean equals (Object obj)
	{
		return obj == this || (super.equals(obj) && equal(((Tuple1<?>)obj)._value0, _value0));
	}

}
