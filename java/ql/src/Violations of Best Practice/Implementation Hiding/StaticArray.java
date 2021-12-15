public class Display {
	// AVOID: Array constant is vulnerable to mutation.
	public static final String[] RGB = {
		"FF0000", "00FF00", "0000FF"
	};
	
	void f() {
		// Re-assigning the "constant" is legal.
		RGB[0] = "00FFFF";
	}
}