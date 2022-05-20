import javax.servlet.http.HttpServletRequest;
import jdk.jshell.JShell;
import jdk.jshell.SourceCodeAnalysis;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class JShellInjection {

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String input = request.getParameter("code");
		JShell jShell = JShell.builder().build();
        // BAD: allow execution of arbitrary Java code
		jShell.eval(input);
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String input = request.getParameter("code");
		JShell jShell = JShell.builder().build();
		SourceCodeAnalysis sourceCodeAnalysis = jShell.sourceCodeAnalysis();
        // BAD: allow execution of arbitrary Java code
		sourceCodeAnalysis.wrappers(input);
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String input = request.getParameter("code");
		JShell jShell = JShell.builder().build();
		SourceCodeAnalysis.CompletionInfo info;
		SourceCodeAnalysis sca = jShell.sourceCodeAnalysis();
		for (info = sca.analyzeCompletion(input);
				info.completeness().isComplete();
				info = sca.analyzeCompletion(info.remaining())) {
			// BAD: allow execution of arbitrary Java code
			jShell.eval(info.source());
		}
	}
}