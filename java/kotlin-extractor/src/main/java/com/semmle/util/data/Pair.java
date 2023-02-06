package com.semmle.util.data;


/**
 * An (immutable) ordered pair of values.
 * <p>
 * Pairs are compared with structural equality: <code>(x,y) = (x', y')</code> iff <code>x=x'</code>
 * and <code>y=y'</code>.
 * </p>
 *
 * @param <X> the type of the first component of the pair
 * @param <Y> the type of the second component of the pair
 */
public class Pair<X,Y> extends Tuple2<X, Y>
{
	private static final long serialVersionUID = -2871892357006076659L;
	
	/*
	 * Constructor and factory
	 */


	/**
	 * Create a new pair of values
	 * @param x the first component of the pair
	 * @param y the second component of the pair
	 */
	public Pair(X x, Y y) {
		super(x, y);
	}

	/**
	 * Create a new pair of values. This behaves identically
	 * to the constructor, but benefits from type inference
	 * @param x the first component of the pair
	 * @param y the second component of the pair
	 */
	public static <X,Y> Pair<X,Y> make(X x, Y y) {
		return new Pair<X,Y>(x, y);
	}

	/*
	 * Getters
	 */

	/**
	 * Get the first component of this pair
	 * @return the first component of the pair
	 */
	public X fst() {
		return value0();
	}

	/**
	 * Get the second component of this pair
	 * @return the second component of the pair
	 */
	public Y snd() {
		return value1();
	}

}
