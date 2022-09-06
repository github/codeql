import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
public class DotRegexSpring {
	private static final String PROTECTED_PATTERN = "/protected/.*";
	private static final String CONSTRAINT_PATTERN = "/protected/xyz\\.xml";
	
	@GetMapping("param")
	// BAD: A string with line return e.g. `/protected/%0dxyz` can bypass the path check
	public String withParam(@RequestParam String path, Model model) throws UnsupportedEncodingException {
		Pattern p = Pattern.compile(PROTECTED_PATTERN);
		path = decodePath(path);
		Matcher m = p.matcher(path);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (model.getAttribute("secAttr") == null || !model.getAttribute("secAttr").equals("secValue")) {
				return "redirect:login";
			}
		}
		// Not protected page - render content
		return path;
	}

	@GetMapping("{path}")
	// BAD: A string with line return e.g. `%252Fprotected%252F%250dxyz` can bypass the path check
	public RedirectView withPathVariable1(@PathVariable String path, Model model) throws UnsupportedEncodingException {
		Pattern p = Pattern.compile(PROTECTED_PATTERN);
		path = decodePath(path);
		Matcher m = p.matcher(path);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (model.getAttribute("secAttr") == null || !model.getAttribute("secAttr").equals("secValue")) {
				RedirectView redirectView = new RedirectView("login", true);
				return redirectView;
			}
		}
		return null;
	}
	
	@GetMapping("/sp/{path}")
	// GOOD: A string with line return e.g. `%252Fprotected%252F%250dxyz` cannot bypass the path check
	public String withPathVariable2(@PathVariable String path, Model model) throws UnsupportedEncodingException {
		Pattern p = Pattern.compile(CONSTRAINT_PATTERN);
		path = decodePath(path);
		Matcher m = p.matcher(path);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (model.getAttribute("secAttr") == null || !model.getAttribute("secAttr").equals("secValue")) {
				return "redirect:login";
			}	
		}
		// Not protected page - render content
		return path;
	}

	private String decodePath(String path) throws UnsupportedEncodingException {
		while (path.indexOf("%") > -1) {
			path = URLDecoder.decode(path, "UTF-8");
		}
		return path;
	}
}
