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
import freemarker.core.ParserConfiguration;

@Controller
public class FreemarkerSSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);

		Template t = new Template(name, reader); // $hasTemplateInjection
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);
		Configuration cfg = new Configuration();

		Template t = new Template(name, reader, cfg); // $hasTemplateInjection
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Reader reader = new StringReader(code);
		Configuration cfg = new Configuration();

		Template t = new Template(name, reader, cfg, "UTF-8"); // $hasTemplateInjection
	}

	@GetMapping(value = "bad4")
	public void bad4(HttpServletRequest request) {
		String name = "ttemplate";
		String sourceCode = request.getParameter("sourceCode");
		Configuration cfg = new Configuration();

		Template t = new Template(name, sourceCode, cfg); // $hasTemplateInjection
	}

	@GetMapping(value = "bad5")
	public void bad5(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		Reader reader = new StringReader(code);

		Template t = new Template(name, sourceName, reader, cfg); // $hasTemplateInjection
	}

	@GetMapping(value = "bad6")
	public void bad6(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		ParserConfiguration customParserConfiguration = new Configuration();
		Reader reader = new StringReader(code);

		Template t =
				new Template(name, sourceName, reader, cfg, customParserConfiguration, "UTF-8"); // $hasTemplateInjection
	}

	@GetMapping(value = "bad7")
	public void bad7(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");
		Configuration cfg = new Configuration();
		ParserConfiguration customParserConfiguration = new Configuration();
		Reader reader = new StringReader(code);

		Template t = new Template(name, sourceName, reader, cfg, "UTF-8"); // $hasTemplateInjection
	}

	@GetMapping(value = "bad8")
	public void bad8(HttpServletRequest request) {
		String code = request.getParameter("code");
		StringTemplateLoader stringLoader = new StringTemplateLoader();

		stringLoader.putTemplate("myTemplate", code); // $hasTemplateInjection
	}

	@GetMapping(value = "bad9")
	public void bad9(HttpServletRequest request) {
		String code = request.getParameter("code");
		StringTemplateLoader stringLoader = new StringTemplateLoader();

		stringLoader.putTemplate("myTemplate", code, 0); // $hasTemplateInjection
	}

	@GetMapping(value = "good1")
	public void good1(HttpServletRequest request) {
		HashMap<Object, Object> root = new HashMap();
		String code = request.getParameter("code");
		root.put("code", code);
		Configuration cfg = new Configuration();
		Template temp = cfg.getTemplate("test.ftlh");
		OutputStreamWriter out = new OutputStreamWriter(System.out);
		temp.process(root, out); // Safe
	}
}
