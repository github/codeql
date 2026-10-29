public class Parser
{
	public void parse(String input) {
		int pos = 0;
		// ...
		// AVOID: Empty block
		while (input.charAt(pos++) != '=') { }
		// ...
	}
}
