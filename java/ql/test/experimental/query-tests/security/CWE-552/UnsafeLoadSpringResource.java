package com.example;

import java.io.File;
import java.io.FileReader;
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
			Reader in = new FileReader(clr.getFilename());
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
		if (fileName.startsWith("/safe_dir") && !fileName.contains("..")) {
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
		
		if (fileName.startsWith("/safe_dir") && !fileName.contains("..")) {
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
	// Note it is not detected without the generic `resource.getInputStream()` check
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

		if (fileName.startsWith("/safe_dir") && !fileName.contains("..")) {
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
}
