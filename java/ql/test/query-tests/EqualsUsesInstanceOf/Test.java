import java.util.Comparator;

class Test {

	static class CustomComparator<T> implements Comparator<T> {
		@Override
		public int compare(Object o1, Object o2) {
			return 0;
		}
	}

	static class TestComparator extends CustomComparator {
		int val;
		@Override
		public boolean equals(Object o) {
			if (o instanceof TestComparator) {
				return ((TestComparator)o).val == val;
			}
			return false;
		}
	}
}