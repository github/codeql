import javax.imageio.stream.FileImageInputStream;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.String;
import java.io.File;
import java.io.FileWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.Writer;
import java.util.Set;

import org.thymeleaf.*;
import org.thymeleaf.context.Context;

@Controller
public class ThymeleafSSTI {
	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String code = request.getParameter("code"); // $ Source[java/server-side-template-injection]
		try {
			TemplateEngine templateEngine = new TemplateEngine();
			templateEngine.process(code, (Set<String>) null, (Context) null); // $ Alert[java/server-side-template-injection]
			templateEngine.process(code, (Set<String>) null, (Context) null, (Writer) null); // $ Alert[java/server-side-template-injection]
			templateEngine.process(code, (Context) null); // $ Alert[java/server-side-template-injection]
			templateEngine.process(code, (Context) null, (Writer) null); // $ Alert[java/server-side-template-injection]
			templateEngine.processThrottled(code, (Set<String>) null, (Context) null); // $ Alert[java/server-side-template-injection]
			templateEngine.processThrottled(code, (Context) null); // $ Alert[java/server-side-template-injection]

			TemplateSpec spec = new TemplateSpec(code, "");
			templateEngine.process(spec, (Context) null); // $ Alert[java/server-side-template-injection]
			templateEngine.process(spec, (Context) null, (Writer) null); // $ Alert[java/server-side-template-injection]
			templateEngine.processThrottled(spec, (Context) null); // $ Alert[java/server-side-template-injection]
		} catch (Exception e) {
		}
	}
}
