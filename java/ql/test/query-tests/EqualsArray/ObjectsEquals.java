import java.util.Arrays;
import java.util.Objects;

class ObjectsEquals {
	void compare(int[] first, int[] second, String[] strings, Object[] objects,
			int[][] nested, int[][] otherNested, long[] longs) {
		Objects.equals(first, second); // $ Alert
		Objects.equals(strings, objects); // $ Alert
		Objects.equals(objects, strings); // $ Alert
		Objects.equals(nested, otherNested); // $ Alert
		java.util.Objects.equals(first, second); // $ Alert

		java.util.Objects.equals(first, null);
		java.util.Objects.equals(null, first);
		java.util.Objects.equals(first, longs);
		java.util.Objects.equals(first, "not an array");
		java.util.Objects.equals("first", "second");
		java.util.Objects.deepEquals(first, second);
		Arrays.equals(first, second);
		Arrays.deepEquals(nested, otherNested);
		CustomObjects.equals(first, second);
	}

	static class CustomObjects {
		static boolean equals(Object first, Object second) {
			return java.util.Objects.deepEquals(first, second);
		}
	}
}
