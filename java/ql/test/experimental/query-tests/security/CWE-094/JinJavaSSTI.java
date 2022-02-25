import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.String;
import java.io.Reader;
import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;

import com.hubspot.jinjava.*;
import com.hubspot.jinjava.JinjavaConfig;
import com.hubspot.jinjava.interpret.*;

@Controller
public class JinJavaSSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String template = request.getParameter("template");
		Jinjava jinjava = new Jinjava();
		Map<String, Object> context = new HashMap<>();
		// String render(String template, Map<String, ?> bindings)
		String renderedTemplate = jinjava.render(template, context);
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String template = request.getParameter("template");
		Jinjava jinjava = new Jinjava();
		Map<String, Object> bindings = new HashMap<>();
		// RenderResult renderForResult (String template, Map<String, ?> bindings)
		RenderResult renderResult = jinjava.renderForResult(template, bindings);
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String template = request.getParameter("template");
		Jinjava jinjava = new Jinjava();
		Map<String, Object> bindings = new HashMap<>();
		JinjavaConfig renderConfig = new JinjavaConfig();

		// RenderResult renderForResult (String template, Map<String, ?> bindings,
		// JinjavaConfig renderConfig)
		RenderResult renderResult = jinjava.renderForResult(template, bindings, renderConfig);
	}
}
