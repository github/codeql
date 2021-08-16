import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class ExternalApiUsage {
	public static void main(String[] args) {
		List<?> foo = new ArrayList(); // already supported
		Map<String, Object> map = new HashMap<>();
		map.put("foo", new Object());

		Duration d = java.time.Duration.ofMillis(1000); // not supported

		long l = "foo".length(); // not interesting

		System.out.println(d);
		System.out.println(map);
		System.out.println(foo);
	}
}
