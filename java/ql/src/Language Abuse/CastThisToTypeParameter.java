public class CastThisToTypeParameter {
	private abstract static class BadBaseNode<T extends BadBaseNode<T>> {
		public abstract T getParent();

		public T getRoot() {
			// BAD: relies on derived types to use the right pattern
			T cur = (T)this;
			while(cur.getParent() != null) {
				cur = cur.getParent();
			}
			return cur;
		}
	}
}