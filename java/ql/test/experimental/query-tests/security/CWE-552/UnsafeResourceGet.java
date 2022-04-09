import java.io.InputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.net.URL;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

public class UnsafeResourceGet extends HttpServlet {
	@Override
	// BAD: getResource constructed from `ServletContext` without input validation
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		URL url = sc.getResource(requestUrl);

		InputStream in = url.openStream();
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	// GOOD: getResource constructed from `ServletContext` with input validation
	protected void doGetGood(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		Path path = Paths.get(requestUrl).normalize().toRealPath();
		URL url = sc.getResource(path.toString());

		InputStream in = url.openStream();
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	@Override
	// BAD: getResourceAsStream constructed from `ServletContext` without input validation
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		InputStream in = request.getServletContext().getResourceAsStream(requestPath);
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	// GOOD: getResourceAsStream constructed from `ServletContext` with input validation
	protected void doPostGood(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		if (!requestPath.contains("..") && requestPath.startsWith("/trusted")) {
			InputStream in = request.getServletContext().getResourceAsStream(requestPath);
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}
}
