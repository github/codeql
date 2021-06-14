import java.util.Arrays;
import java.util.List;

class ArraysTest {
	public static void taintSteps(String[] source) {





		Arrays.deepToString(source);


		Arrays.toString(source);


		Arrays.parallelPrefix(source, (x, y) -> x + y);
		Arrays.parallelPrefix(source, 0, 10, (x, y) -> x + y);
		Arrays.parallelSetAll(source, x -> Integer.toString(x));
		Arrays.setAll(source, x -> Integer.toString(x));
	}
}

