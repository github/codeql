@Controller
public class VelocitySSTI {

	@GetMapping(value = "good")
	public void good(HttpServletRequest request) {
		Velocity.init();
		VelocityContext context = new VelocityContext();

		context.put("name", "Velocity");
		context.put("project", "Jakarta");

		String s = "We are using $project $name to render this.";
		StringWriter w = new StringWriter();
		Velocity.evaluate(context, w, "mystring", s);
		System.out.println(" string : " + w);
	}
}
