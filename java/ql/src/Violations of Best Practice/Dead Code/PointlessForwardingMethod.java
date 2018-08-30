import static java.lang.System.out;

public class PointlessForwardingMethod {
	private static class Bad {
		// Violation: This print does nothing but forward to the other one, which is not
		// called independently.
		public void print(String firstName, String lastName) {
			print(firstName + " " + lastName);
		}

		public void print(String fullName) {
			out.println("Pointless forwarding methods are bad, "  + fullName + "...");
		}
	}

	private static class Better1 {
		// Better: Merge the methods, using local variables to replace the parameters in
		// the original version.
		public void print(String firstName, String lastName) {
			String fullName = firstName + " " + lastName;
			out.println("Pointless forwarding methods are bad, " + fullName + "...");
		}
	}

	private static class Better2 {
		// Better: If there's no complicated logic, you can often remove the extra
		// variables entirely.
		public void print(String firstName, String lastName) {
			out.println(
				"Pointless forwarding methods are bad, " +
				firstName + " " + lastName + "..."
			);
		}
	}

	public static void main(String[] args) {
		new Bad().print("Foo", "Bar");
		new Better1().print("Foo", "Bar");
		new Better2().print("Foo", "Bar");
	}
}