package booleanLiterals;

public class BooleanLiterals {
	boolean[] booleans = {
		true,
		false,
		// Using Unicode escapes (which are handled during pre-processing)
		\u0074\u0072\u0075\u0065, // true
	};

	// The operation expression (e.g. `&&`) is not a literal
	boolean[] logicOperations = {
		true && true,
		false && false,
		true && false,
		true || true,
		false || false,
		true || false,
	};

	Object[] nonBooleanLiterals = {
		"true",
		"false",
		1,
		0,
		Boolean.TRUE,
		Boolean.FALSE,
	};

	boolean nonLiteral;
}
