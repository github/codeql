import bsh.Interpreter;
import javax.servlet.http.HttpServletRequest;
import org.springframework.scripting.bsh.BshScriptEvaluator;
import org.springframework.scripting.support.StaticScriptSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BeanShellInjection {

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String code = request.getParameter("code");
		BshScriptEvaluator evaluator = new BshScriptEvaluator();
		evaluator.evaluate(new StaticScriptSource(code)); //bad
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) throws Exception {
		String code = request.getParameter("code");
		Interpreter interpreter = new Interpreter();
		interpreter.eval(code);  //bad
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String code = request.getParameter("code");
		StaticScriptSource staticScriptSource = new StaticScriptSource("test");
		staticScriptSource.setScript(code);
		BshScriptEvaluator evaluator = new BshScriptEvaluator();
		evaluator.evaluate(staticScriptSource);  //bad
	}
}
