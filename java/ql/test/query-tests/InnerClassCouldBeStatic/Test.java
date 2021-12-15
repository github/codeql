class Test {
	static class Super<T>  {
		public void test() {}
	}
	class Sub<T> extends Super<T>  {
		public void test2() {
			test();
		}
	}
}
