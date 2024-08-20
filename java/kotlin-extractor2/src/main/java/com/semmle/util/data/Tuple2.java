package com.semmle.util.data;

import java.io.Serializable;


/**
 * Tuple of two typed elements.
 * <p>
 * Note that this is an extension of {@link Tuple1} and a super-class of {@link Tuple3} (and any
 * subsequent additions).
 * </p>
 */
public class Tuple2 <Type0, Type1> extends Tuple1<Type0>
{
	/**
	 * Serializable variant of {@link Tuple2}.
	 */
	public static class SerializableTuple2<T0 extends Serializable, T1 extends Serializable>
		extends Tuple2<T0, T1> implements Serializable {

		private static final long serialVersionUID = 1624467154864321244L;

		public SerializableTuple2() {
		}

		public SerializableTuple2(T0 t0, T1 t1) {
			super(t0, t1);
		}
	}

	private static final long serialVersionUID = -400406676673562583L;

	/** The additional element contained by this {@link Tuple2}. */
	protected Type1 _value1;

	/** Construct a new {@link Tuple2} with null values. */
	public Tuple2 () {}

	/** Construct a new {@link Tuple2} with the given values. */
	public Tuple2 (Type0 value0, Type1 value1)
	{
		super(value0);
		_value1 = value1;
	}

	/** Construct a new {@link Tuple2} with the given value. */
	public static <Type1, Type2> Tuple2<Type1, Type2> make(Type1 value0, Type2 value1)
	{
		return new Tuple2<Type1,Type2>(value0, value1);
	}

	/**
	 * Get the second value in this {@link Tuple2}.
	 */
	public final Type1 value1 ()
	{
		return _value1;
	}

	@Override
	protected Object value_ (int n)
	{
		return n == 2 ? _value1 : super.value_(n);
	}

	@Override
	public int size ()
	{
		return 2;
	}

	@Override
	public String toPlainString ()
	{
		return super.toPlainString() + ", " + (_value1 == null ? "" : _value1.toString());
	}

	@Override
	public int hashCode ()
	{
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((_value1 == null) ? 0 : _value1.hashCode());
		return result;
	}

	@Override
	public boolean equals (Object obj)
	{
		return obj == this || (super.equals(obj) && equal(((Tuple2<?,?>)obj)._value1, _value1));
	}

}
