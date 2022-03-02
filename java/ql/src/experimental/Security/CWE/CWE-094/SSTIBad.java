@Controller
public class VelocitySSTI {

	@GetMapping(value = "bad")
	public void bad(HttpServletRequest request) {
		Velocity.init();

		String code = request.getParameter("code");

		VelocityContext context = new VelocityContext();

		context.put("name", "Velocity");
		context.put("project", "Jakarta");

		StringWriter w = new StringWriter();
		// evaluate( Context context, Writer out, String logTag, String instring )
		Velocity.evaluate(context, w, "mystring", code);
	}
}
