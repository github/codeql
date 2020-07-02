import java.util.Arrays;
import java.util.List;

class ArraysTest {
	public static void taintSteps(String[] source) {
		Arrays.asList();
		Arrays.asList("one");
		Arrays.asList("two", "three");
		Arrays.copyOf(source, 10);
		Arrays.copyOfRange(source, 0, 10);
		Arrays.deepToString(source);
		Arrays.spliterator(source);
		Arrays.stream(source);
		Arrays.toString(source);
		Arrays.fill(source, "value");
		Arrays.fill(source, 0, 10, "data");
		Arrays.parallelPrefix(source, (x, y) -> x + y);
		Arrays.parallelPrefix(source, 0, 10, (x, y) -> x + y);
		Arrays.parallelSetAll(source, x -> Integer.toString(x));
		Arrays.setAll(source, x -> Integer.toString(x));
	}
}

