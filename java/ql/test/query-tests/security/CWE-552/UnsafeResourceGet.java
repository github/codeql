package com.example;

import java.io.InputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.net.URI;
import java.net.URL;
import java.net.URISyntaxException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

import io.undertow.server.handlers.resource.FileResourceManager;
import io.undertow.server.handlers.resource.Resource;
import org.jboss.vfs.VFS;
import org.jboss.vfs.VirtualFile;

public class UnsafeResourceGet extends HttpServlet {
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: getResource constructed from `ServletContext` without input validation
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		// A sample request /fake.jsp/../WEB-INF/web.xml can load the web.xml file
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
		if (path.startsWith(BASE_PATH)) {
			URL url = sc.getResource(path.toString());

			InputStream in = url.openStream();
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}

	// GOOD: getResource constructed from `ServletContext` with null check only
	protected void doGetGood2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		PrintWriter writer = response.getWriter();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		// A sample request /fake.jsp/../WEB-INF/web.xml can load the web.xml file
		URL url = sc.getResource(requestUrl);
		if (url == null) {
			writer.println("Requested source not found");
		}
	}

	// GOOD: getResource constructed from `ServletContext` with `equals` check
	protected void doGetGood3(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		ServletContext sc = request.getServletContext();

		if (requestUrl.equals("/public/crossdomain.xml")) {
			URL url = sc.getResource(requestUrl);

			InputStream in = url.openStream();
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}

	@Override
	// BAD: getResourceAsStream constructed from `ServletContext` without input validation
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");
		ServletOutputStream out = response.getOutputStream();

		// A sample request /fake.jsp/../WEB-INF/web.xml can load the web.xml file
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

		if (!requestPath.contains("..") && requestPath.startsWith("/trusted")) {
			InputStream in = request.getServletContext().getResourceAsStream(requestPath);
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}

	@Override
	// BAD: getResource constructed from `Class` without input validation
	protected void doHead(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		// A sample request /fake.jsp/../../../WEB-INF/web.xml can load the web.xml file
		// Note the class is in two levels of subpackages and `Class.getResource` starts from its own directory
		URL url = getClass().getResource(requestUrl);

		InputStream in = url.openStream();
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	// GOOD: getResource constructed from `Class` with input validation
	protected void doHeadGood(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		Path path = Paths.get(requestUrl).normalize().toRealPath();
		if (path.startsWith(BASE_PATH)) {
			URL url = getClass().getResource(path.toString());

			InputStream in = url.openStream();
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}

	@Override
	// BAD: getResourceAsStream constructed from `ClassLoader` without input validation
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		// A sample request /fake.jsp/../../../WEB-INF/web.xml can load the web.xml file
		// Note the class is in two levels of subpackages and `ClassLoader.getResourceAsStream` starts from its own directory
		InputStream in = getClass().getClassLoader().getResourceAsStream(requestPath);
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	// GOOD: getResourceAsStream constructed from `ClassLoader` with input validation
	protected void doPutGood(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");
		ServletOutputStream out = response.getOutputStream();

		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		if (!requestPath.contains("..") && requestPath.startsWith("/trusted")) {
			InputStream in = getClass().getClassLoader().getResourceAsStream(requestPath);
			byte[] buf = new byte[4 * 1024];  // 4K buffer
			int bytesRead;
			while ((bytesRead = in.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
	}

	// BAD: getResource constructed from `ClassLoader` without input validation
	protected void doPutBad(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestUrl = request.getParameter("requestURL");
		ServletOutputStream out = response.getOutputStream();

		// A sample request /fake.jsp/../../../WEB-INF/web.xml can load the web.xml file
		// Note the class is in two levels of subpackages and `ClassLoader.getResource` starts from its own directory
		URL url = getClass().getClassLoader().getResource(requestUrl);

		InputStream in = url.openStream();
		byte[] buf = new byte[4 * 1024];  // 4K buffer
		int bytesRead;
		while ((bytesRead = in.read(buf)) != -1) {
			out.write(buf, 0, bytesRead);
		}
	}

	// BAD: getResource constructed using Undertow IO without input validation
	protected void doPutBad2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");

		try {
			FileResourceManager rm = new FileResourceManager(VFS.getChild(new URI("/usr/share")).getPhysicalFile());
			Resource rs = rm.getResource(requestPath);

			VirtualFile overlay = VFS.getChild(new URI("EAP_HOME/modules/"));
			// Do file operations
			overlay.getChild(rs.getPath());
		} catch (URISyntaxException ue) {
			throw new IOException("Cannot parse the URI");
		}
	}

	// GOOD: getResource constructed using Undertow IO with input validation
	protected void doPutGood2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String requestPath = request.getParameter("requestPath");

		try {
			FileResourceManager rm = new FileResourceManager(VFS.getChild(new URI("/usr/share")).getPhysicalFile());
			Resource rs = rm.getResource(requestPath);

			VirtualFile overlay = VFS.getChild(new URI("EAP_HOME/modules/"));
			String path = rs.getPath();
			if (path.startsWith("/trusted_path") && !path.contains("..")) {
				// Do file operations
				overlay.getChild(path);
			}
		} catch (URISyntaxException ue) {
			throw new IOException("Cannot parse the URI");
		}
	}
}
