import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

@Controller
public class UrlForwardTest extends HttpServlet implements Filter {

	// Spring `ModelAndView` test cases
	@GetMapping("/bad1")
	public ModelAndView bad1(String url) {
		return new ModelAndView(url); // $ hasTaintFlow
	}

	@GetMapping("/bad2")
	public ModelAndView bad2(String url) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName(url); // $ hasTaintFlow
		return modelAndView;
	}

	// Spring `"forward:"` prefix test cases
	@GetMapping("/bad3")
	public String bad3(String url) {
		return "forward:" + url + "/swagger-ui/index.html"; // $ hasTaintFlow
	}

	@GetMapping("/bad4")
	public ModelAndView bad4(String url) {
		ModelAndView modelAndView = new ModelAndView("forward:" + url); // $ hasTaintFlow
		return modelAndView;
	}

	// Not relevant for this query since redirecting instead of forwarding
	// This result should be found by the `java/unvalidated-url-redirection` query instead.
	@GetMapping("/redirect")
	public ModelAndView redirect(String url) {
		ModelAndView modelAndView = new ModelAndView("redirect:" + url);
		return modelAndView;
	}

	// `RequestDispatcher` test cases from a Spring `GetMapping` entry point
	@GetMapping("/bad5")
	public void bad5(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher(url).include(request, response); // $ hasTaintFlow
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad6")
	public void bad6(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").include(request, response); // $ hasTaintFlow
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad7")
	public void bad7(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").forward(request, response); // $ hasTaintFlow
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/good1")
	public void good1(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/index.jsp?token=" + url).forward(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// BAD: appended to a prefix without path sanitization
	@GetMapping("/bad8")
	public void bad8(String urlPath, HttpServletRequest request, HttpServletResponse response) {
		try {
			String url = "/pages" + urlPath;
			request.getRequestDispatcher(url).forward(request, response); // $ hasTaintFlow
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// GOOD: appended to a prefix with path sanitization
	@GetMapping("/good2")
	public void good2(String urlPath, HttpServletRequest request, HttpServletResponse response) {
		try {
			while (urlPath.contains("%")) {
				urlPath = URLDecoder.decode(urlPath, "UTF-8");
			}

			if (!urlPath.contains("..") && !urlPath.startsWith("/WEB-INF")) {
				// Note: path injection sanitizer does not account for string concatenation instead of a `startswith` check
				String url = "/pages" + urlPath;
				request.getRequestDispatcher(url).forward(request, response);
			}

		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// `RequestDispatcher` test cases from non-Spring entry points
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: Request dispatcher from servlet path without check
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();
		// A sample payload "/%57EB-INF/web.xml" can bypass this `startsWith` check
		if (path != null && !path.startsWith("/WEB-INF")) {
			request.getRequestDispatcher(path).forward(request, response); // $ hasTaintFlow
		} else {
			chain.doFilter(request, response);
		}
	}

	// BAD: Request dispatcher from servlet path with check that does not decode
	// the user-supplied path; could bypass check with ".." encoded as "%2e%2e".
	public void doFilter2(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getRequestDispatcher(path).forward(request, response); // $ hasTaintFlow
		} else {
			chain.doFilter(request, response);
		}
	}

	// GOOD: Request dispatcher from servlet path with whitelisted string comparison
	public void doFilter3(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();

		if (path.equals("/comaction")) {
			request.getRequestDispatcher(path).forward(request, response);
		} else {
			chain.doFilter(request, response);
		}
	}

	@Override
	// BAD: Request dispatcher constructed from `ServletContext` without input validation
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		ServletConfig cfg = getServletConfig();
		if (action.equals("Login")) {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL); // $ hasTaintFlow
			rd.forward(request, response);
		}
	}

	@Override
	// BAD: Request dispatcher constructed from `HttpServletRequest` without input validation
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			RequestDispatcher rd = request.getRequestDispatcher(returnURL); // $ hasTaintFlow
			rd.forward(request, response);
		}
	}

	@Override
	// GOOD: Request dispatcher with a whitelisted URI
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else if (action.equals("Register")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Register.jsp");
			rd.forward(request, response);
		}
	}

	// BAD: Request dispatcher without path traversal check
	protected void doHead1(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		// A sample payload "/pages/welcome.jsp/../WEB-INF/web.xml" can bypass the `startsWith` check
		if (path.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(path).include(request, response); // $ hasTaintFlow
		}
	}

	// BAD: Request dispatcher with path traversal check that does not decode
	// the user-supplied path; could bypass check with ".." encoded as "%2e%2e".
	protected void doHead2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response); // $ hasTaintFlow
		}
	}

	// BAD: Request dispatcher with path normalization and comparison, but
	// does not decode before normalization.
	protected void doHead3(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		// Since not decoded before normalization, "%2e%2e" can remain in the path
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		if (requestedPath.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response); // $ hasTaintFlow
		}
	}

	// BAD: Request dispatcher with negation check and path normalization, but without URL decoding.
	protected void doHead4(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		// Since not decoded before normalization, "/%57EB-INF" can remain in the path and pass the `startsWith` check.
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		if (!requestedPath.startsWith("/WEB-INF") && !requestedPath.startsWith("/META-INF")) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response); // $ hasTaintFlow
		}
	}

	// BAD: Request dispatcher with path traversal check and single URL decoding; may be vulnerable to double-encoding
	protected void doHead5(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		path = URLDecoder.decode(path, "UTF-8");

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response); // $ hasTaintFlow
		}
	}

	// GOOD: Request dispatcher with path traversal check and URL decoding in a loop to avoid double-encoding bypass
	protected void doHead6(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		if (path.contains("%")){
			while (path.contains("%")) {
				path = URLDecoder.decode(path, "UTF-8");
			}
		}

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// GOOD: Request dispatcher with URL encoding check and path traversal check
	protected void doHead7(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		if (!path.contains("%")){
			if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
				request.getServletContext().getRequestDispatcher(path).include(request, response);
			}
		}
	}

	// BAD: Request dispatcher without URL decoding before WEB-INF and path traversal checks
	protected void doHead8(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		if (path.contains("%")){ // incorrect check
			if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
				request.getServletContext().getRequestDispatcher(path).include(request, response); // $ hasTaintFlow
			}
		}
	}

	// GOOD: Request dispatcher with WEB-INF, path traversal, and URL encoding checks
	protected void doHead9(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			if (!path.contains("%")){ // correct check
				request.getServletContext().getRequestDispatcher(path).include(request, response);
			}
		}
	}

	// GOOD: Request dispatcher with path traversal check and URL decoding in a loop to avoid double-encoding bypass
	protected void doHead10(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		while (path.contains("%")) {
			path = URLDecoder.decode(path, "UTF-8");
		}

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// GOOD: Request dispatcher with path traversal check and URL decoding in a loop to avoid double-encoding bypass
	protected void doHead11(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		// FP: we don't currently handle the scenario where the
		// `path.contains("%")` check is stored in a variable.
		boolean hasEncoding = path.contains("%");
		while (hasEncoding) {
			path = URLDecoder.decode(path, "UTF-8");
			hasEncoding = path.contains("%");
		}

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response); // $ SPURIOUS: hasTaintFlow
		}
	}

	// BAD: `StaplerResponse.forward` without any checks
	public void generateResponse(StaplerRequest req, StaplerResponse rsp, Object obj) throws IOException, ServletException {
		String url = req.getParameter("target");
		rsp.forward(obj, url, req); // $ hasTaintFlow
	}

	// QHelp example
	private static final String VALID_FORWARD = "https://cwe.mitre.org/data/definitions/552.html";

	protected void doGet2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		// BAD: a request parameter is incorporated without validation into a URL forward
		sc.getRequestDispatcher(request.getParameter("target")).forward(request, response); // $ hasTaintFlow

		// GOOD: the request parameter is validated against a known fixed string
		if (VALID_FORWARD.equals(request.getParameter("target"))) {
			sc.getRequestDispatcher(VALID_FORWARD).forward(request, response);
		}
	}

	// GOOD: char `?` appended before the user input
	private static final String LOGIN_URL = "/UI/Login";

	public void doPost2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		StringBuilder forwardUrl = new StringBuilder(200);
		forwardUrl.append(LOGIN_URL);

		String queryString = request.getQueryString();

		forwardUrl.append('?').append(queryString);

		String fUrl = forwardUrl.toString();

		ServletConfig config = getServletConfig();

        RequestDispatcher dispatcher = config.getServletContext().getRequestDispatcher(fUrl);
        dispatcher.forward(request, response);
	}
}
