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

	// (1) ORIGINAL
	@GetMapping("/bad1")
	public ModelAndView bad1(String url) {
		return new ModelAndView(url); // $ hasUrlForward
	}

	@GetMapping("/bad2")
	public ModelAndView bad2(String url) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName(url); // $ hasUrlForward
		return modelAndView;
	}

	@GetMapping("/bad3")
	public String bad3(String url) {
		return "forward:" + url + "/swagger-ui/index.html"; // $ hasUrlForward
	}

	@GetMapping("/bad4")
	public ModelAndView bad4(String url) {
		ModelAndView modelAndView = new ModelAndView("forward:" + url); // $ hasUrlForward
		return modelAndView;
	}

	@GetMapping("/bad5")
	public void bad5(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher(url).include(request, response); // $ hasUrlForward
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad6")
	public void bad6(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").include(request, response); // $ hasUrlForward
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@GetMapping("/bad7")
	public void bad7(String url, HttpServletRequest request, HttpServletResponse response) {
		try {
			request.getRequestDispatcher("/WEB-INF/jsp/" + url + ".jsp").forward(request, response); // $ hasUrlForward
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

	// (2) UnsafeRequestPath
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: Request dispatcher from servlet path without check
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();
		// A sample payload "/%57EB-INF/web.xml" can bypass this `startsWith` check
		if (path != null && !path.startsWith("/WEB-INF")) {
			request.getRequestDispatcher(path).forward(request, response); // $ hasUrlForward
		} else {
			chain.doFilter(request, response);
		}
	}

	// GOOD: Request dispatcher from servlet path with check
	public void doFilter2(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getRequestDispatcher(path).forward(request, response);
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

	// (3) UnsafeServletRequestDispatch
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
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL); // $ hasUrlForward
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
			RequestDispatcher rd = request.getRequestDispatcher(returnURL); // $ hasUrlForward
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
	protected void doHead2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		// A sample payload "/pages/welcome.jsp/../WEB-INF/web.xml" can bypass the `startsWith` check
		// The payload "/pages/welcome.jsp/../../%57EB-INF/web.xml" can bypass the check as well since RequestDispatcher will decode `%57` as `W`
		if (path.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(path).include(request, response); // $ hasUrlForward
		}
	}

	// GOOD: Request dispatcher with path traversal check
	protected void doHead3(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// GOOD: Request dispatcher with path normalization and comparison
	protected void doHead4(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		// /pages/welcome.jsp/../../WEB-INF/web.xml becomes /WEB-INF/web.xml
		// /pages/welcome.jsp/../../%57EB-INF/web.xml becomes /%57EB-INF/web.xml
		if (requestedPath.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
		}
	}

	// FN: Request dispatcher with negation check and path normalization, but without URL decoding
	// When promoting this query, consider using FlowStates to make `getRequestDispatcher` a sink
	// only if a URL-decoding step has NOT been crossed (i.e. make URLDecoder.decode change the
	// state to a different value than the one required at the sink).
	// TODO: but does this need to take into account URLDecoder.decode in a loop...?
	protected void doHead5(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		if (!requestedPath.startsWith("/WEB-INF") && !requestedPath.startsWith("/META-INF")) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response); // $ MISSING: hasUrlForward
		}
	}

	// GOOD: Request dispatcher with path traversal check and URL decoding
	protected void doHead6(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		boolean hasEncoding = path.contains("%");
		while (hasEncoding) {
			path = URLDecoder.decode(path, "UTF-8");
			hasEncoding = path.contains("%");
		}

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// New Tests (i.e. Added by me)
	public void generateResponse(StaplerRequest req, StaplerResponse rsp, Object obj) throws IOException, ServletException {
		String url = req.getParameter("target");
		rsp.forward(obj, url, req); // $ hasUrlForward
	}

}
