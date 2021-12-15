import javax.servlet.Servlet;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import java.io.IOException;
import java.net.URL;

public class ServletMain implements Servlet {
	public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
	}

	public void init(ServletConfig servletConfig) throws ServletException {
	}

	public ServletConfig getServletConfig() {
		return null;
	}

	public String getServletInfo() {
		return null;
	}

	public void destroy() {
	}

	// BAD - Implement a main method in servlet.
	public static void main(String[] args) throws Exception {
		// Connect to my server
		URL url = new URL("https://www.example.com");
		url.openConnection();
	}
}
