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
		String code = request.getParameter("code");

		VelocityContext context = null;

		String s = "We are using $project $name to render this.";
		StringWriter w = new StringWriter();
		// evaluate( Context context, Writer out, String logTag, String instring )
		Velocity.evaluate(context, w, "mystring", code);
	}

	@GetMapping(value = "bad2")
	public void bad2(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = null;

		String s = "We are using $project $name to render this.";
		StringWriter w = new StringWriter();
		StringReader reader = new StringReader(code);

		// evaluate(Context context, Writer writer, String logTag, Reader reader)
		Velocity.evaluate(context, w, "mystring", reader);
	}

	@GetMapping(value = "bad3")
	public void bad3(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		RuntimeServices runtimeServices = new RuntimeServices();
		StringReader reader = new StringReader(code);
		runtimeServices.parse(reader, new Template());
	}

	@GetMapping(value = "bad4")
	public void bad4(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		StringReader reader = new StringReader("test");

		Velocity.evaluate(context, w, "mystring", reader);
	}

	@GetMapping(value = "bad5")
	public void bad5(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		VelocityEngine.mergeTemplate("testtemplate.vm", "UTF-8", context, w);
	}

	@GetMapping(value = "bad6")
	public void bad6(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		Template t = new Template();
		t.merge(context, w);
	}

	@GetMapping(value = "bad7")
	public void bad7(HttpServletRequest request) {
		String name = "ttemplate";
		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();
		context.put("code", code);

		StringWriter w = new StringWriter();
		Template t = new Template();
		t.merge(context, w, new LinkedList<String>());
	}

	@GetMapping(value = "bad8")
	public void bad8(HttpServletRequest request) {
		String code = request.getParameter("code");

		StringResourceRepository repo = new StringResourceRepositoryImpl();
		repo.putStringResource("woogie2", code);

	}
}
