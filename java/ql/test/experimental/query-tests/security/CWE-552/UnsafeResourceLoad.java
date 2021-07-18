import java.io.IOException;
import java.io.InputStream;

import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

public class UnsafeResourceLoad extends HttpServlet {
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: Request loading constructed from `ServletContext` with user controlled input 
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String path = req.getParameter("path");

		// /WEB-INF/web.xml or /pages/public_page.jsp/../../WEB-INF/web.xml works!!!
		URL url = req.getServletContext().getResource(path);

		// create a urlconnection object
		URLConnection urlConnection = url.openConnection();
	}

	@Override
	// BAD: Request loading constructed from `ClassLoader` with user controlled input 
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String path = req.getParameter("path");

		// ../../WEB-INF/web.xml, or ../../pages/sec_page.jsp, or ../../pages/public_page.jsp/../../WEB-INF/web.xml works!!!
		// Cannot access resources outside of the application's web root /webapps/s3-listener
		InputStream in = getClass().getClassLoader().getResourceAsStream(path);
	}

    private URL getResourceUrl(String resourcePath, HttpServletRequest req) throws IOException {
		String resourceBasePath = req.getServletContext().getRealPath(BASE_PATH);

		String realPath = req.getServletContext().getRealPath(resourcePath);

		if (!isValidResourcePath(resourceBasePath, resourcePath)) {
			return null;
		}

		return req.getServletContext().getResource(resourcePath);
	}

	private boolean isValidResourcePath(String resourceBasePath, String resourcePath) {
		Path requestedPath = Paths.get(resourceBasePath).resolve(resourcePath).normalize();
		return requestedPath.startsWith(resourceBasePath);
	}

	@Override
	// GOOD: Request loading constructed from `ServletContext` with path normalization and comparison 
	public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String path = req.getParameter("path");

		URL url = getResourceUrl(path, req);

		// create a urlconnection object
		URLConnection urlConnection = url.openConnection();
	}

	@Override
	// GOOD: Request loading constructed from `ClassLoader` with path normalization and comparison
	protected void doHead(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = req.getParameter("path");

		String resourceBasePath = req.getServletContext().getRealPath(BASE_PATH);
		Path requestedPath = Paths.get(resourceBasePath).resolve(path).normalize();

		if (requestedPath.startsWith(resourceBasePath)) {
			InputStream in = getClass().getClassLoader().getResourceAsStream(path);
		}
	}

	// BAD: Request loading constructed from `ClassLoader` with path comparison but without `..` navigation character check
	protected void doHead2(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = req.getParameter("path");

		if (path.startsWith(BASE_PATH)) {
			InputStream in = getClass().getClassLoader().getResourceAsStream(path);
		}
	}

	// GOOD: Request loading constructed from `ClassLoader` with path comparison and navigation check
	protected void doHead3(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = req.getParameter("path");

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			InputStream in = getClass().getClassLoader().getResourceAsStream(path);
		}
	}
}
