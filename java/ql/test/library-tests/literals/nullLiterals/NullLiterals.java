package nullLiterals;

public class NullLiterals {
	Object[] nulls = {
		null,
		// Using Unicode escapes (which are handled during pre-processing)
		\u006E\u0075\u006C\u006C, // null
	};

	// The operation expressions (e.g. cast) are not a literal
	Object[] operations = {
		(Object) null,
	};

	Object[] nonNullLiterals = {
		"null",
		0,
		Boolean.FALSE,
	};

	Object nonLiteral;
}
