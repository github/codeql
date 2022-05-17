package com.example;

import java.io.File;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.util.ResourceUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Sample class of Spring RestController */
@RestController
public class UnsafeLoadSpringResource {
	@GetMapping("/file1")
	//BAD: Get resource from ClassPathResource without input validation
	public String getFileContent1(@RequestParam(name="fileName") String fileName) {
		// A request such as the following can disclose source code and application configuration
		// fileName=/../../WEB-INF/views/page.jsp
		// fileName=/com/example/package/SampleController.class
		ClassPathResource clr = new ClassPathResource(fileName);
		char[] buffer = new char[4096];
		StringBuilder out = new StringBuilder();
		try {
			Reader in = new InputStreamReader(clr.getInputStream(), "UTF-8");
			for (int numRead; (numRead = in.read(buffer, 0, buffer.length)) > 0; ) {
				out.append(buffer, 0, numRead);
			}
		} catch (IOException ie) {
			ie.printStackTrace();
		}
		return out.toString();
	}

	@GetMapping("/file1a")
	//GOOD: Get resource from ClassPathResource with input path validation
	public String getFileContent1a(@RequestParam(name="fileName") String fileName) {
		String result = null;
		if (!isInvalidPath(fileName) && !isInvalidEncodedPath(fileName)) {
			ClassPathResource clr = new ClassPathResource(fileName);
			char[] buffer = new char[4096];
			StringBuilder out = new StringBuilder();
			try {
				Reader in = new InputStreamReader(clr.getInputStream(), "UTF-8");
				for (int numRead; (numRead = in.read(buffer, 0, buffer.length)) > 0; ) {
					out.append(buffer, 0, numRead);
				}
			} catch (IOException ie) {
				ie.printStackTrace();
			}
			result = out.toString();
		}
		return result;
	}

	@GetMapping("/file2")
	//BAD: Get resource from ResourceUtils without input validation
	public String getFileContent2(@RequestParam(name="fileName") String fileName) {
		String content = null;
		
		try {
			// A request such as the following can disclose source code and system configuration
			// fileName=/etc/hosts
			// fileName=file:/etc/hosts
			// fileName=/opt/appdir/WEB-INF/views/page.jsp
			File file = ResourceUtils.getFile(fileName);
			//Read File Content
			content = new String(Files.readAllBytes(file.toPath()));
		} catch (IOException ie) {
			ie.printStackTrace();
		}
		return content;
	}

	@GetMapping("/file2a")
	//GOOD: Get resource from ResourceUtils with input path validation
	public String getFileContent2a(@RequestParam(name="fileName") String fileName) {
		String content = null;
		
		if (!isInvalidPath(fileName) && !isInvalidEncodedPath(fileName)) {
			try {
				File file = ResourceUtils.getFile(fileName);
				//Read File Content
				content = new String(Files.readAllBytes(file.toPath()));
			} catch (IOException ie) {
				ie.printStackTrace();
			}
		}
		return content;
	}

	@Autowired
	ResourceLoader resourceLoader;

	@GetMapping("/file3")
	//BAD: Get resource from ResourceLoader (same as application context) without input validation
	public String getFileContent3(@RequestParam(name="fileName") String fileName) {
		String content = null;

		try {
			// A request such as the following can disclose source code and system configuration
			// fileName=/WEB-INF/views/page.jsp
			// fileName=/WEB-INF/classes/com/example/package/SampleController.class
			// fileName=file:/etc/hosts
			Resource resource = resourceLoader.getResource(fileName);

			char[] buffer = new char[4096];
			StringBuilder out = new StringBuilder();

			Reader in = new InputStreamReader(resource.getInputStream(), "UTF-8");
			for (int numRead; (numRead = in.read(buffer, 0, buffer.length)) > 0; ) {
				out.append(buffer, 0, numRead);
			}
			content = out.toString();
		} catch (IOException ie) {
			ie.printStackTrace();
		}
		return content;
	}

	@GetMapping("/file3a")
	//GOOD: Get resource from ResourceLoader (same as application context) with input path validation
	public String getFileContent3a(@RequestParam(name="fileName") String fileName) {
		String content = null;

		if (!isInvalidPath(fileName) && !isInvalidEncodedPath(fileName)) {
			try {
				Resource resource = resourceLoader.getResource(fileName);

				char[] buffer = new char[4096];
				StringBuilder out = new StringBuilder();

				Reader in = new InputStreamReader(resource.getInputStream(), "UTF-8");
				for (int numRead; (numRead = in.read(buffer, 0, buffer.length)) > 0; ) {
					out.append(buffer, 0, numRead);
				}
				content = out.toString();
			} catch (IOException ie) {
				ie.printStackTrace();
			}
		}
		return content;
	}

	/**
	 * Check whether the given path contains invalid escape sequences.
	 * @param path the path to validate
	 * @return {@code true} if the path is invalid, {@code false} otherwise
	 * @see Referenced code for path validation fix in https://github.com/mpgn/CVE-2019-3799
	 */
	private boolean isInvalidEncodedPath(String path) {
		if (path.contains("%")) {
			try {
				// Use URLDecoder (vs UriUtils) to preserve potentially decoded UTF-8 chars
				String decodedPath = URLDecoder.decode(path, "UTF-8");
				if (isInvalidPath(decodedPath)) {
					return true;
				}
				decodedPath = processPath(decodedPath);
				if (isInvalidPath(decodedPath)) {
					return true;
				}
			} catch (IllegalArgumentException | UnsupportedEncodingException ex) {
				// Should never happen...
			}
		}
		return false;
	}

	/**
	 * Process the given resource path.
	 * <p>The default implementation replaces:
	 * <ul>
	 * <li>Backslash with forward slash.
	 * <li>Duplicate occurrences of slash with a single slash.
	 * <li>Any combination of leading slash and control characters (00-1F and 7F)
	 * with a single "/" or "". For example {@code "  / // foo/bar"}
	 * becomes {@code "/foo/bar"}.
	 * </ul>
	 * @since 3.2.12
	 * @see Referenced code for path validation fix in https://github.com/mpgn/CVE-2019-3799
	 */
	protected String processPath(String path) {
		path = StringUtils.replace(path, "\\", "/");
		path = cleanDuplicateSlashes(path);
		return cleanLeadingSlash(path);
	}

	/** @see Referenced code for path validation fix in https://github.com/mpgn/CVE-2019-3799 **/
	private String cleanDuplicateSlashes(String path) {
		StringBuilder sb = null;
		char prev = 0;
		for (int i = 0; i < path.length(); i++) {
			char curr = path.charAt(i);
			try {
				if ((curr == '/') && (prev == '/')) {
					if (sb == null) {
						sb = new StringBuilder(path.substring(0, i));
					}
					continue;
				}
				if (sb != null) {
					sb.append(path.charAt(i));
				}
			} finally {
				prev = curr;
			}
		}
		return sb != null ? sb.toString() : path;
	}

	/** @see Referenced code for path validation fix in https://github.com/mpgn/CVE-2019-3799 **/
	private String cleanLeadingSlash(String path) {
		boolean slash = false;
		for (int i = 0; i < path.length(); i++) {
			if (path.charAt(i) == '/') {
				slash = true;
			}
			else if (path.charAt(i) > ' ' && path.charAt(i) != 127) {
				if (i == 0 || (i == 1 && slash)) {
					return path;
				}
				return (slash ? "/" + path.substring(i) : path.substring(i));
			}
		}
		return (slash ? "/" : "");
	}

	/**
	 * Identifies invalid resource paths. By default rejects:
	 * <ul>
	 * <li>Paths that contain "WEB-INF" or "META-INF"
	 * <li>Paths that contain "../" after a call to
	 * {@link org.springframework.util.StringUtils#cleanPath}.
	 * <li>Paths that represent a {@link org.springframework.util.ResourceUtils#isUrl
	 * valid URL} or would represent one after the leading slash is removed.
	 * </ul>
	 * <p><strong>Note:</strong> this method assumes that leading, duplicate '/'
	 * or control characters (e.g. white space) have been trimmed so that the
	 * path starts predictably with a single '/' or does not have one.
	 * @param path the path to validate
	 * @return {@code true} if the path is invalid, {@code false} otherwise
	 * @since 3.0.6
	 * @see Referenced code for path validation fix in https://github.com/mpgn/CVE-2019-3799
	 */
	protected boolean isInvalidPath(String path) {
		if (path.contains("WEB-INF") || path.contains("META-INF")) {
			return true;
		}
		if (path.contains(":/")) {
			String relativePath = (path.charAt(0) == '/' ? path.substring(1) : path);
			if (ResourceUtils.isUrl(relativePath) || relativePath.startsWith("url:")) {
				return true;
			}
		}
		if (path.contains("..") && StringUtils.cleanPath(path).contains("../")) {
			return true;
		}
		return false;
	}
}
