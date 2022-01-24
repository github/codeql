package charLiterals;

public class CharLiterals {
	char[] chars = {
		'a',
		'\u0061', // 'a'
		'\u0000',
		'\uFFFF',
		'\ufFfF',
		'\0',
		'\n',
		'"',
		'\\',
		'\'',
		'\123', // octal escape sequence for 'S'
		// CodeQL uses U+FFFD for unpaired surrogates, see https://github.com/github/codeql/issues/6611
		'\uD800', // high surrogate
		'\uDC00', // low surrogate
		// Using Unicode escapes (which are handled during pre-processing)
		'\u005C\u005C', // escaped backslash
		'\u005C\u0027', // escaped single quote
		\u0027a\u0027, // 'a'
	};

	// + and - are not part of the literal
	int[] charsWithSign = {
		+'a',
		-'a',
	};

	// The operation expression (e.g. `+`) is not a literal
	int[] numericOperations = {
		'a' + 'b',
	};

	Object[] nonCharLiterals = {
		"a",
		"",
		"\uD800\uDC00", // surrogate pair
		0,
		Character.MIN_VALUE,
	};

	char nonLiteral;
}
