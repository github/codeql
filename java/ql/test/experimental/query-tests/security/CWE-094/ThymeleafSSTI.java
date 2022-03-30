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

import org.thymeleaf.*;
import org.thymeleaf.context.Context;

@Controller
public class ThymeleafSSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String code = request.getParameter("code");
		Context ctx = new Context();
		try {
			FileWriter fw = new FileWriter(new File("as"));
			TemplateEngine templateEngine = new TemplateEngine();
			templateEngine.process(code, ctx, fw);
		} catch (Exception e) {
		}
	}
}
