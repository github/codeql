import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

class ExternalApiUsage {
	public static void main(String[] args) {
		List<?> foo = new ArrayList(); // already supported
		Map<String, Object> map = new HashMap<>();
		map.put("foo", new Object());

		Duration d = java.time.Duration.ofMillis(1000); // supported as a neutral summary model

		long l = "foo".length(); // supported as a neutral summary model

		AtomicReference<String> ref = new AtomicReference<>(); // uninteresting (parameterless constructor)
		ref.set("foo"); // supported as a summary model
		ref.toString(); // not supported

		String.class.isAssignableFrom(Object.class); // parameter with generic type, supported as a neutral summary model

		System.out.println(d);
		System.out.println(map);
		System.out.println(foo);
	}
}
