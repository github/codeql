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
		// CodeQL uses U+FFFD for them, see https://github.com/github/codeql/issues/6611
		"\uD800",
		"\uDC00",
		"hello\uD800hello\uDC00world", // malformed surrogates
		// Using Unicode escapes (which are handled during pre-processing)
		"\u005C\u0022", // escaped double quote ("\"")
		\u0022\u0061\u0022, // "a"
	};

	String[] textBlocks = {
		// trailing whitespaces after """ (will be ignored)
		"""      	  
		test "text" and escaped \u0022
		""",
		// Indentation tests
		"""
			indented
		""",
		"""
	no indentation last line
		""", // Line is blank, therefore not indented
		"""
	indentation last line
		\s""", // Line is not blank therefore indented
		"""
			not-indented
			""",
		"""
		indented
	""",
			"""
		not-indented
		""",
		"""
		    spaces (only single space is trimmed)
			tab
			""",
		"""
			end on same line""",
		"""
		trailing spaces ignored:  	 
		not ignored: 	 \s
		""",
		"""
		3 quotes:""\"""",
		"""
		line \
		continuation \
		""",
		"""
		Explicit line breaks:\n
		\r\n
		\r
		""",
		// Using Unicode escapes (which are handled during pre-processing)
		// Currently not detected by StringLiteral.isTextBlock()
		\uuu0022"\u0022
		test
		\u0022\uu0022",
	};

	// The concatenation (`+`) is not a string literal
	String[] stringConcatenation = {
		// CodeQL erroneously reports this as one literal, see https://github.com/github/codeql/issues/5469
		"hello" + "world",
		"""
		hello""" + "world",
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
