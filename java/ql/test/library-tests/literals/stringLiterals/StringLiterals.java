package stringLiterals;

import java.io.File;

public class StringLiterals {
	String[] strings = {
		"",
		"hello,\tworld",
		"hello,\u0009world",
		"\u0061", // 'a'
		"\0",
		"\uFFFF",
		"\ufFfF",
		"\"",
		"\'",
		"\n",
		"\\",
		"test \123", // octal escape sequence for 'S'
		"\1234", // octal escape followed by '4'
		"\0000", // octal escape \000 followed by '0'
		"\u0061567", // escape sequence for 'a' followed by "567"
		"\u1234567", // '\u1234' followed by "567"
		"\uaBcDeF\u0aB1", // '\uABCD' followed by "eF" followed by '\u0AB1'
		"\uD800\uDC00", // surrogate pair
		"\uDBFF\uDFFF", // U+10FFFF
		// Unpaired surrogates
		"\uD800",
		"\uDC00",
		"hello\uD800hello\uDC00world", // malformed surrogates
		// Using Unicode escapes (which are handled during pre-processing)
		"\u005C\u0022", // escaped double quote ("\"")
		\u0022\u0061\u0022, // "a"
	};

	// The concatenation (`+`) is not a string literal
	String[] stringConcatenation = {
		// CodeQL erroneously reports this as one literal, see https://github.com/github/codeql/issues/5469
		"hello" + "world",
		null + "a",
		"a" + null,
		"a" + 1,
		1 + "a",
		"a" + true,
		true + "a",
		"a" + 'b',
		'b' + "a",
	};

	Object[] nonStringLiterals = {
		'a',
		'"',
		true,
		null,
		0,
		File.pathSeparator
	};

	String nonLiteral;
}
