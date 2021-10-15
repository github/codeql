class InexactVarArg
{
	private static void length(Object... objects) {
		System.out.println(objects.length);
	}

	public static void main(String[] args) {
		String[] words = { "apple", "banana", "cherry" };
		String[][] lists = { words, words };
		length(words);	// avoid: Argument does not clarify
		length(lists);	// which parameter type is used.
	}
}
