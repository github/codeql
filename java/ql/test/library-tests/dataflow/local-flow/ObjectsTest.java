import java.util.Objects;

class ObjectsTest {
	public static void valueSteps() {
		sink(Objects.requireNonNull(source()));
		sink(Objects.requireNonNull(source(), "message"));
		sink(Objects.requireNonNull(source(), () -> "value1"));
		sink(Objects.requireNonNullElse(source(), source()));
		sink(Objects.requireNonNullElseGet(source(), () -> "value2"));
		sink(Objects.toString(null, source()));
	}
	private static <T> T source() { return null; }
	private static void sink(Object o) {}
}
