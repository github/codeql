package remove_type_mismatch;

class B<E> {
	static interface I {}
	
	java.util.Collection<I> c;
	
	void test(E e) {
		c.remove(e);
	}
}