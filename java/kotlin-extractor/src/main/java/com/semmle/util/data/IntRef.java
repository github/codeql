package com.semmle.util.data;

/**
 * A mutable reference to a primitive int. Specialised to avoid
 * boxing.
 *
 */
public class IntRef {
	private int value;
	
	public IntRef(int value) {
		this.value = value;
	}
	
	public int get() { return value; }
	public void set(int value) { this.value = value; }
	public void inc() { value++; }
	public void add(int val) { value += val; };
}
