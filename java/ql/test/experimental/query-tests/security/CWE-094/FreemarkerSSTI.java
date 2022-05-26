import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.String;
import java.io.Reader;
import java.io.StringReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;

import freemarker.template.Template;
import freemarker.template.Configuration;
import freemarker.cache.StringTemplateLoader;
import freemarker.template.ParserConfiguration;

@Controller
public class FreemarkerSSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);

		// Template(java.lang.String name, java.io.Reader reader)
		Template t = new Template(name, reader);
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);
		Configuration cfg = new Configuration();
		
		// Template(java.lang.String name, java.io.Reader reader, Configuration cfg)
		Template t = new Template(name, reader, cfg);
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);
		Configuration cfg = new Configuration();

		// Template(java.lang.String name, java.io.Reader reader, Configuration cfg,
		// java.lang.String encoding)
		Template t = new Template(name, reader, cfg, "UTF-8");
	}

	@GetMapping(value = "bad4")
	public void bad4(HttpServletRequest request) {
		String name = "ttemplate";
		String sourceCode = request.getParameter("sourceCode");
		Configuration cfg = new Configuration();

		// Template(java.lang.String name, java.lang.String sourceCode, Configuration
		// cfg)
		Template t = new Template(name, sourceCode, cfg);
	}

	@GetMapping(value = "bad5")
	public void bad5(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		Reader reader = new StringReader(code);

		// Template(java.lang.String name, java.lang.String sourceName, java.io.Reader
		// reader, Configuration cfg)
		Template t = new Template(name, sourceName, reader, cfg);
	}

	@GetMapping(value = "bad6")
	public void bad6(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		ParserConfiguration customParserConfiguration = new Configuration();
		Reader reader = new StringReader(code);

		// Template(java.lang.String name, java.lang.String sourceName, java.io.Reader
		// reader, Configuration cfg, ParserConfiguration customParserConfiguration,
		// java.lang.String encoding)
		Template t = new Template(name, sourceName, reader, cfg, customParserConfiguration, "UTF-8");
	}

	@GetMapping(value = "bad7")
	public void bad7(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		ParserConfiguration customParserConfiguration = new Configuration();
		Reader reader = new StringReader(code);

		// Template(java.lang.String name, java.lang.String sourceName, java.io.Reader
		// reader, Configuration cfg, java.lang.String encoding)
		Template t = new Template(name, sourceName, reader, cfg, "UTF-8");
	}

	@GetMapping(value = "bad8")
	public void bad8(HttpServletRequest request) {
		String code = request.getParameter("code");
		StringTemplateLoader stringLoader = new StringTemplateLoader();

		// void putTemplate(java.lang.String name, java.lang.String templateContent)
		stringLoader.putTemplate("myTemplate", code);
	}

	@GetMapping(value = "bad9")
	public void bad9(HttpServletRequest request) {
		String code = request.getParameter("code");
		StringTemplateLoader stringLoader = new StringTemplateLoader();
		
		// void putTemplate(java.lang.String name, java.lang.String templateContent,
		// long lastModified)
		stringLoader.putTemplate("myTemplate", code, 0);
	}

	@GetMapping(value = "bad10")
	public void bad10(HttpServletRequest request) {
		HashMap root = new HashMap();
		String code = request.getParameter("code");
        root.put("code", code);
		Configuration cfg = new Configuration();
        Template temp = cfg.getTemplate("test.ftlh");        
        OutputStreamWriter out = new OutputStreamWriter(System.out);
        temp.process(root, out);
	}
}
