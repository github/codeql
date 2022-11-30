import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

class SupportedExternalApis {
	public static void main(String[] args) throws Exception {
		StringBuilder builder = new StringBuilder();
		builder.append("foo");  // supported
		builder.toString();  // supported

		Map<String, Object> map = new HashMap<>();
		map.put("foo", new Object()); // supported

		Duration d = java.time.Duration.ofMillis(1000); // not supported
	}
}
