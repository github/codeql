import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import org.apache.commons.io.FileUtils;

class SupportedExternalApis {
	public static void main(String[] args) throws Exception {
		StringBuilder builder = new StringBuilder(); // uninteresting (parameterless constructor)
		builder.append("foo");  // supported summary
		builder.toString();  // supported summary

		Map<String, Object> map = new HashMap<>(); // uninteresting (parameterless constructor)
		map.put("foo", new Object()); // supported summary
		map.entrySet().iterator().next().getKey(); // nested class (Map.Entry), supported summaries (entrySet, iterator, next, getKey)

		Duration d = java.time.Duration.ofMillis(1000); // supported neutral summary

		URL github = new URL("https://www.github.com/"); // supported summary
		InputStream stream = github.openConnection().getInputStream(); // supported source (getInputStream), supported sink (openConnection)

		new FileWriter(new File("foo")); // supported sink (FileWriter), supported summary (File)
		new URL("http://foo").openStream(); // supported sink (openStream), supported summary (URL)

		File file = new File("foo"); // supported summary (File)
		FileUtils.deleteDirectory(file); // supported neutral summary (deleteDirectory)

		file.compareTo(file); // supported neutral sink (compareTo)
	}

    public static void doSendRedirect(HttpServletResponse req) throws ServletException, IOException {
        req.sendRedirect("myredirect"); // supported sink (sendRedirect)
    }
}
