public class CastThisToTypeParameter {
	private abstract static class GoodBaseNode<T extends GoodBaseNode<T>> {
		public abstract T getSelf();
		public abstract T getParent();

		public T getRoot() {
			// GOOD: introduce an abstract method to enforce the constraint
			// that 'this' can be converted to T for derived types
			T cur = getSelf();
			while(cur.getParent() != null)
			{
				cur = cur.getParent();
			}
			return cur;
		}
	}

	private static class GoodConcreteNode extends GoodBaseNode<GoodConcreteNode> {
		private String name;
		private GoodConcreteNode parent;

		public GoodConcreteNode(String name, GoodConcreteNode parent)
		{
			this.name = name;
			this.parent = parent;
		}

		@Override
		public GoodConcreteNode getSelf() {
			return this;
		}

		@Override
		public GoodConcreteNode getParent() {
			return parent;
		}

		@Override
		public String toString() {
			return name;
		}
	}

	public static void main(String[] args) {
		GoodConcreteNode a = new GoodConcreteNode("a", null);
		GoodConcreteNode b = new GoodConcreteNode("b", a);
		GoodConcreteNode c = new GoodConcreteNode("c", a);
		GoodConcreteNode d = new GoodConcreteNode("d", b);
		GoodConcreteNode root = d.getRoot();
		System.out.println(a + " " + root);
	}
}