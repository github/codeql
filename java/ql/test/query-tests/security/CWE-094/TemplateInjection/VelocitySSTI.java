import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.String;
import java.io.Reader;
import java.io.StringReader;
import java.io.OutputStreamWriter;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.LinkedList;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.context.AbstractContext;
import org.apache.velocity.context.Context;
import org.apache.velocity.Template;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.resource.util.StringResourceRepository;
import org.apache.velocity.runtime.resource.util.StringResourceRepositoryImpl;

@Controller
public class VelocitySSTI {
	String sourceName = "sourceName";

	@GetMapping(value = "bad1")
	public void bad1(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code"); // $ Source

		VelocityContext context = null;

		String s = "We are using $project $name to render this.";
		StringWriter w = new StringWriter();
		Velocity.evaluate(context, w, "mystring", code); // $ Alert
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code"); // $ Source

		VelocityContext context = null;

		String s = "We are using $project $name to render this.";
		StringWriter w = new StringWriter();
		StringReader reader = new StringReader(code);

		Velocity.evaluate(context, w, "mystring", reader); // $ Alert
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code"); // $ Source

		RuntimeServices runtimeServices = null;
		StringReader reader = new StringReader(code);
		runtimeServices.parse(reader, new Template()); // $ Alert
	}

	@GetMapping(value = "good1")
	public void good1(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		StringReader reader = new StringReader("test");

		Velocity.evaluate(context, w, "mystring", reader); // Safe
	}

	@GetMapping(value = "bad5")
	public void bad5(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code"); // $ Source

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		VelocityEngine engine = null;
		engine.mergeTemplate("testtemplate.vm", "UTF-8", context, w); // Safe
		AbstractContext ctx = null;
		ctx.put("key", code);
		engine.evaluate(ctx, null, null, (String) null); // Safe
		engine.evaluate(ctx, null, null, (Reader) null); // Safe
		engine.evaluate(null, null, null, code); // $ Alert
		engine.evaluate(null, null, null, new StringReader(code)); // $ Alert
	}

	@GetMapping(value = "good2")
	public void good2(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		Template t = new Template();
		t.merge(context, w); // Safe
		t.merge(context, w, new LinkedList<String>()); // Safe

	}

	@GetMapping(value = "bad6")
	public void bad6(HttpServletRequest request) {
		String code = request.getParameter("code"); // $ Source

		StringResourceRepository repo = new StringResourceRepositoryImpl();
		repo.putStringResource("woogie2", code); // $ Alert

	}
}
