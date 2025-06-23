import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.String;
import java.io.Reader;
import java.io.StringReader;

import com.mitchellbosecke.pebble.PebbleEngine;
import com.mitchellbosecke.pebble.template.*;

@Controller
public class PebbleSSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String templateName = request.getParameter("templateName"); // $ Source
		PebbleEngine engine = new PebbleEngine.Builder().build();
		PebbleTemplate compiledTemplate = engine.getTemplate(templateName); // $ Alert
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String templateName = request.getParameter("templateName"); // $ Source
		PebbleEngine engine = new PebbleEngine.Builder().build();
		PebbleTemplate compiledTemplate = engine.getLiteralTemplate(templateName); // $ Alert
	}
}
