package com.semmle.util.data;

import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.regex.Pattern;

import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;

public class StringUtil {

	private static final Random RANDOM = new Random();

	private static final DecimalFormat DOUBLE_FORMATTER;
	static {
		// Specify the root locale to ensure we use the "." decimal separator
		DOUBLE_FORMATTER = new DecimalFormat(
				"#.######",
				new DecimalFormatSymbols(Locale.ROOT)
		);
		DecimalFormatSymbols decimalFormatSymbols = DOUBLE_FORMATTER.getDecimalFormatSymbols();
		decimalFormatSymbols.setNaN("NaN");
		decimalFormatSymbols.setInfinity("Infinity");
		DOUBLE_FORMATTER.setDecimalFormatSymbols(decimalFormatSymbols);
	}

	public static String box(List<String> strings) {
		List<String> lines = new ArrayList<>();
		for (String s : strings)
			for (String line : lines(s))
				lines.add(line);

		int length = 0;
		for (String s : lines)
			length = Math.max(length, s.length());

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < length + 6; i++)
			sb.append('*');
		for (String s : lines) {
			sb.append("\n*  ");
			sb.append(s);
			for (int i = 0; i < length - s.length(); i++)
				sb.append(' ');
			sb.append("  *");
		}
		sb.append('\n');
		for (int i = 0; i < length + 6; i++)
			sb.append('*');
		return sb.toString();
	}

	public static String escapeStringLiteralForRegexp(String literal, String charsToPreserve) {
		final String charsToEscape = "(){}[].^$+\\*?";
		StringBuilder buf = new StringBuilder();
		for(int i = 0; i < literal.length(); i++) {
			char c = literal.charAt(i);
			if(charsToEscape.indexOf(c) != -1 && charsToPreserve.indexOf(c) == -1) {
				buf.append("\\").append(c);
			}
			else {
				buf.append(c);
			}
		}
		return buf.toString();
	}

	public static String pad(int minWidth, Padding pad, String s) {

		int length = s.length();
		int toPad = minWidth - length;

		if (toPad > 0) {
			int left;
			int right;
			switch (pad) {
			case LEFT:
				left = 0;
				right = toPad;
				break;
			case RIGHT:
				left = toPad;
				right = 0;
				break;
			case CENTRE:
				left = toPad / 2;
				right = toPad - left;
				break;
			default:
				throw new CatastrophicError("Unknown padding kind: " + pad);
			}

			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < left; i++)
				sb.append(' ');
			sb.append(s);
			for (int i = 0; i < right; i++)
				sb.append(' ');

			return sb.toString();
		} else
			return s;

	}

	public static List<String> pad(Padding pad, Collection<String> strings) {
		List<String> result = new ArrayList<>(strings.size());
		int maxWidth = 0;
		for (String s : strings)
			maxWidth = Math.max(maxWidth, s.length());
		for (String s : strings)
			result.add(pad(maxWidth, pad, s));
		return result;
	}

	public static List<String> pad(Padding pad, String... strings) {
		List<String> result = new ArrayList<>(strings.length);
		int maxWidth = 0;
		for (String s : strings)
			maxWidth = Math.max(maxWidth, s.length());
		for (String s : strings)
			result.add(pad(maxWidth, pad, s));
		return result;
	}

	public static void padTable(List<String[]> rows, Padding... pad) {
		int width = pad.length;
		int[] maxLengths = new int[width];
		for (String[] row : rows) {
			if (row.length != width)
				throw new CatastrophicError("padTable can only be used with a rectangular table. Expected " + width +
						" columns but found row: " + Arrays.toString(row));
			for (int i = 0; i < width; i++)
				maxLengths[i] = Math.max(maxLengths[i], row[i].length());
		}
		for (String[] row : rows)
			for (int i = 0; i < width; i++)
				row[i] = pad(maxLengths[i], pad[i], row[i]);
	}

	public static String glue(String separator, Iterable<?> values) {
		StringBuilder sb = new StringBuilder();
		boolean first = true;
		for (Object o : values) {
			if (first)
				first = false;
			else
				sb.append(separator);
			sb.append(o == null ? "<null>" : o.toString());
		}
		return sb.toString();
	}

	public static String glue(String separator, Object[] values) {
		return glue(separator, Arrays.asList(values));
	}

	public static String glue(String separator, String... values) {
		return glue(separator, (Object[]) values);
	}

	public static enum Padding { LEFT, RIGHT, CENTRE }


	/**
	 * Return a new String with any of the four characters !#:= replaced with a back-slash escaped
	 * equivalent, and any newline characters replaced by a back-slash n.
	 * <p>
	 * This allows the String to be used in a .properties file (assuming it does not contain any
	 * extended unicode characters, which must be converted to unicode escapes).
	 * </p>
	 * <p>
	 * Note that <b>it does not ensure that the String can be used as a <i>key</i> in a .properties
	 * file</b>, which requires additional escaping of any spaces.
	 * </p>
	 *
	 * @param string The String to escape; must not be null.
	 * @return The given {@code string} with a back-slash inserted before each instance of any of the
	 *         four characters: #!:=
	 * @see #escapePropertiesValue(String)
	 */
	public static String escapePropertiesValue (String string)
	{
		return string.replace("!", "\\!")
		             .replace(":", "\\:")
		             .replace("#", "\\#")
		             .replace("=", "\\=")
		             .replace("\n", "\\n");
	}

	/**
	 * See {@link #escapePropertiesValue(String)}. This method also escapes spaces, so that the
	 * {@code string} can be used as a .properties key.
	 *
	 * @param string The String to escape; must not be null.
	 * @return The given {@code string} with a back-slash inserted before each instance of any of the
	 *         four characters: #!:= or the space character, and newlines replaced by a backslash n.
	 */
	public static String escapePropertiesKey (String string)
	{
		return escapePropertiesValue(string).replace(" ", "\\ ");
	}

	/**
	 * Print a float in a locale-independent way suitable for reading with Double.valueOf().
	 */
	public static String printFloat(double value) {
		if (Math.abs(value) > 999999999999999.0 && !Double.isInfinite(value)) {
			// `DecimalFormat` for `double` loses precision on large numbers,
			// printing the least significant digits as all 0.
			return DOUBLE_FORMATTER.format(new BigDecimal(value));
		} else {
			return DOUBLE_FORMATTER.format(value);
		}
	}

	public static String escapeHTML(String s) {
		if (s == null) return null;

		int length = s.length();
		// initialize a StringBuilder with initial capacity of twice the size of the string,
		// except when its size is zero, or when doubling the size causes overflow
		StringBuilder sb = new StringBuilder(length * 2 > 0 ? length * 2 : length);
		for (int i = 0; i < length; i++) {
			char c = s.charAt(i);
			switch (c) {
			case '<':
				sb.append("&lt;");
				break;
			case '>':
				sb.append("&gt;");
				break;
			case '&':
				sb.append("&amp;");
				break;
			case '"':
				sb.append("&quot;");
				break;
			case '\'':
				sb.append("&#39;");
				break;
			// be careful with this one (non-breaking white space)
			/*
			case ' ':
				sb.append("&nbsp;");
				break;*/

			default:
				sb.append(c);
				break;
			}
		}
		return sb.toString();
	}

	/**
	 * Escape special characters in the given string like JSON.stringify does
	 * (see ECMAScript 5.1, Section 15.12.3).
	 */
	public static String escapeJSON(String str) {
		if (str == null)
			return null;
		StringBuilder res = new StringBuilder();
		for (int i=0, n=str.length(); i<n; ++i) {
			char c = str.charAt(i);
			switch (c) {
			case '"':  res.append("\\\""); break;
			case '\\': res.append("\\\\"); break;
			case '\b': res.append("\\b"); break;
			case '\f': res.append("\\f"); break;
			case '\n': res.append("\\n"); break;
			case '\r': res.append("\\r"); break;
			case '\t': res.append("\\t"); break;
			default:
				if (c < ' ')
					res.append(String.format("\\u%04x", Integer.valueOf(c)));
				else
					res.append(c);
			}
		}
		return res.toString();
	}

	// we don't include curly brackets although they're mentioned in the spec as escapable,
	// because they don't actually do anything
	private static final List<Character> specialMarkdownChars = Arrays.asList(
			'\\', '`', '_', '*', '(', ')', '[', ']', '#', '+', '-', '.', '!');
	/**
	 * Escape special markdown characters in the given string.
	 */
	public static String escapeMarkdown(String str) {
		return escapeMarkdown(specialMarkdownChars, str);
	}

	/**
	 * Escape special markdown characters in the given string.
	 */
	public static String escapeMarkdown(List<Character> specialMarkdownChars, String str) {
		if (str == null)
			return null;
		StringBuilder res = new StringBuilder();

		boolean escapeOctothorp = true;
		for (int i=0, n=str.length(); i<n; ++i) {
			char c = str.charAt(i);
			if (specialMarkdownChars.contains(c) && (c != '#' || escapeOctothorp))
				res.append("\\").append(c);
			else
				res.append(c);

			// If this character is an '&' and the next character is an '#' it will not be escaped.
			// This is to avoid escaping it in HTML entities, e.g. &#x2603;.
			escapeOctothorp = (c != '&');
		}
		return res.toString();
	}

	/**
	 * Make a QL string literal for the given string, using escapes for non-printable characters
	 * where possible. The return value includes the surrounding double-quote characters.
	 */
	public static String makeQLStringLiteral(String value) {
		StringBuilder sb = new StringBuilder();
		sb.append('\"');
		for (char c : value.toCharArray()) {
			switch (c) {
			case '\\':
				sb.append("\\\\");
				break;
			case '\n':
				sb.append("\\n");
				break;
			case '\"':
				sb.append("\\\"");
				break;
			case '\r':
				sb.append("\\r");
				break;
			case '\t':
				sb.append("\\t");
				break;
			default:
				sb.append(c);
				break;
			}
		}
		sb.append('\"');
		return sb.toString();
	}

	/**
	 * Wrap a long text to a given number of columns. The wrapping is done
	 * naively: At least one word is on every line, and the first word to
	 * push the line length above the value of <code>cols</code> marks the
	 * start of a new line (and ends up on the new line). For this method,
	 * "word" means sequence of non-whitespace characters.
	 * @param text The text that should be wrapped.
	 * @param cols The number of characters to permit on each line; it is
	 *           only exceeded if there are single words that are longer.
	 * @return The text with sequences of whitespace before words that would
	 *           exceed the permitted width replaced with '\n'.
	 */
	public static String wrap(String text, int cols) {
		if(text == null)
			return null;
		List<String> lines = new ArrayList<>();
		int lineStart = -1; int wordStart = -1; int col = 0;
		for (int cur = 0; cur < text.length(); cur++) {
			if (text.charAt(cur) == '\n') {
				// Forced new line.
				if (lineStart < 0) {
					// Empty new line.
					lines.add("");
				} else {
					lines.add(text.substring(lineStart, cur).trim());
				}
				lineStart = -1;
				wordStart = -1;
				col = 0;
			} else if (Character.isWhitespace(text.charAt(cur))) {
				// Possible break.
				if (col > cols) {
					// Break is needed.
					if (lineStart < 0) {
						// Long run of whitespace.
						continue;
					} else if (wordStart < 0) {
						// Sequence of whitespace went over after real word.
						String line = text.substring(lineStart, cur).trim();
						if (line.length() > 0) lines.add(line);
						lineStart = -1;
					} else if (wordStart > lineStart) {
						// Word goes onto new line.
						lines.add(text.substring(lineStart, wordStart - 1).trim());
						lineStart = wordStart;
						col = cur - lineStart + 1;
						wordStart = -1;
					} else {
						// Word is a line on its own.
						lines.add(text.substring(wordStart, cur).trim());
						lineStart = -1;
						wordStart = -1;
					}
				} else {
					// No break, but new word
					wordStart = -1;
				}
			} else {
				if (lineStart < 0) {
					lineStart = cur;
					col = 0;
				}
				if (wordStart < 0)
					wordStart = cur;
			}
			if (lineStart >= 0)
				col++;
		}
		if (lineStart > -1)
			lines.add(text.substring(lineStart).trim());
		return glue("\n", lines);
	}

	/**
	 * Get the first word of the given string, delimited by whitespace. Leading whitespace
	 * is ignored.
	 */
	public static String firstWord(String s) {
		s = s.trim();
		int i = 0;
		while (i < s.length() && !Character.isWhitespace(s.charAt(i)))
			i++;
		return s.substring(0, i);
	}

	/**
	 * Strip the first word (delimited by whitespace, leading whitespace ignored) and get the
	 * remainder of the string, trimmed.
	 */
	public static String stripFirstWord(String s) {
		s = s.trim();
		int i = 0;
		while (i < s.length() && !Character.isWhitespace(s.charAt(i)))
			i++;
		return s.substring(i).trim();
	}

	/**
	 * Trim leading and trailing occurrences of a character from a string
	 * @param str the string to trim
	 * @param c the character to remove
	 * @return A string whose value is <code>str</code>, with any leading and trailing occurrences of <code>c</code> removed,
	 *    or <code>str</code> if it has no leading or trailing occurrences of <code>c</code>.
	 */
	public static String trim(String str, char c) {
		return trim(str, c, true, true);
	}

	public static String trim(String str, char c, boolean trimLeading, boolean trimTrailing) {
		int begin = 0;
		int end = str.length();

		if (trimLeading) {
			while ((begin < end) && (str.charAt(begin) == c)) {
				begin++;
			}
		}
		if (trimTrailing) {
			while ((begin < end) && (str.charAt(end - 1) == c)) {
				end--;
			}
		}
		if ((begin > 0) || (end < str.length()))
			str = str.substring(begin, end);
		return str;
	}

	public static String trimTrailingWhitespace(String str) {
		int begin = 0;
		int end = str.length();
		while((begin < end) && (Character.isWhitespace(str.charAt(end-1)))) {
			end--;
		}
		if (end < str.length())
			str = str.substring(begin, end);
		return str;
	}

	private static final Charset UTF8_CHARSET = Charset.forName("UTF-8");

	/**
	 * Invert the conversion performed by {@link #stringToBytes(String)}.
	 */
	public static String bytesToString(byte[] bytes)
	{
		return new String(bytes, 0, bytes.length, UTF8_CHARSET);
	}

	public static String bytesToString(byte[] bytes, int offset, int length) {
		return new String(bytes, offset, length, UTF8_CHARSET);
	}

	/** Convert a String into a sequence of bytes (according to a UTF-8 representation of the String). */
	public static byte[] stringToBytes (String str)
	{
		return str.getBytes(Charset.forName("UTF-8"));
	}

	/**
	 * Compute a SHA-1 sum for the given String.
	 * <p>
	 * The SHA-1 is obtained by first converting the String to bytes, which is Charset-dependent,
	 * though this method always uses {@link #stringToBytes(String)}.
	 * </p>
	 *
	 * @see #toHex(byte[])
	 */
	public static byte[] stringToSHA1 (String str)
	{
		MessageDigest messageDigest;
		try {
			messageDigest = MessageDigest.getInstance("SHA-1");
			return messageDigest.digest(stringToBytes(str));
		}
		catch (NoSuchAlgorithmException e) {
			throw new CatastrophicError("Failed to obtain MessageDigest for computing SHA-1", e);
		}

	}

	/**
	 * Constructs a string that repeats the repeatee the specified number of times.
	 * For example, repeat("foo", 3) would return "foofoofoo".
	 *
	 * @param repeatee	The string to be repeated.
	 * @param times		The number of times to repeat it.
	 * @return			The result of repeating the repeatee the specified number of times.
	 */
	public static String repeat(String repeatee, int times) {
		if (times == 0)
			return "";
		return new String(new char[times]).replace("\0", repeatee);
	}

	/**
	 * Computes the lower-case version of the given string in a way that is independent
	 * of the system default locale.
	 * @param s A string value to lowercase.
	 * @return The value of {@code s} with all English letters converted to lower-case.
	 */
	public static String lc(String s) {
		return s.toLowerCase(Locale.ENGLISH);
	}

	/**
	 * Computes the upper-case version of the given string in a way that is independent
	 * of the system default locale.
	 * @param s A string value to uppercase.
	 * @return The value of {@code s} with all English letters converted to upper-case.
	 */
	public static String uc(String s) {
		return s.toUpperCase(Locale.ENGLISH);
	}

	public static String ucfirst(String s) {
		if( s.isEmpty() || !Character.isLowerCase(s.charAt(0)))
			return s;
		else
			return uc(s.substring(0,1))+s.substring(1);
	}

	private static final Pattern lineEnding = Pattern.compile("\r\n|\r|\n");
	/**
	 * Regex to match line endings using look-behind,
	 * so that line separators can be included in the split lines.
	 * \r\n is matched eagerly, i.e. we only match on \r individually if it is not followed by \n.
	 */
	private static final Pattern lineEndingIncludingSeparators = Pattern.compile("(?<=(\r\n|\r(?!\n)|\n))");

	/**
	 * Get the lines in a given string. All known style of line terminator (CRLF, CR, LF)
	 * are recognised. Trailing empty lines are not returned, and the resulting strings
	 * do not include the line separators.
	 */
	public static String[] lines(String s) {
		return lines(s, false, true);
	}

	/**
	 * Get the lines in a given string, including the line separators.
	 * All known style of line terminator (CRLF, CR, LF) are recognised.
	 * Trailing empty strings are not returned (but lines containing only separators are).
	 */
	public static String[] linesWithSeparators(String s) {
		return lines(s, true, true);
	}

	/**
	 * Get the lines in a given string. All known style of line terminator (CRLF, CR, LF)
	 * are recognised. The resulting strings do not include the line separators. If
	 * {@code squishTrailing} is <code>true</code>, trailing empty lines are not included
	 * in the result; otherwise, they will appear as empty strings.
	 */
	public static String[] lines(String s, boolean squishTrailing) {
		return lines(s, false, squishTrailing);
	}

	/**
	 * Gets the lines in a given string. All known style of line terminator (CRLF, CR, LF)
	 * are recognised.
	 * If {@code includeSeparators} is <code>true</code>, then the line separators are included
	 * at the end of their corresponding lines; otherwise they are dropped.
	 * If {@code squishTrailing} is <code>true</code>, then trailing empty lines are not included
	 * in the result; otherwise, they will appear as empty strings.
	 */
	public static String[] lines(String s, boolean includeSeparators, boolean squishTrailing) {
		if (s.length() == 0)
			return new String[0];
		Pattern pattern = includeSeparators ? lineEndingIncludingSeparators : lineEnding;
		return pattern.split(s, squishTrailing ? 0 : -1);
	}

	/**
	 * Replace all line endings in the given string with \n
	 */
	public static String toUnixLineEndings(String s) {
		return lineEnding.matcher(s).replaceAll("\n");
	}

	/**
	 * Get a boolean indicating whether the string contains line separators
	 * All known style of line terminator (CRLF, CR, LF) are recognised.
	 */
	public static boolean isMultiLine(String s) {
		return lineEnding.matcher(s).find();
	}

	private static final Pattern whitespace = Pattern.compile("\\s+");
	/**
	 * Get the words (i.e. whitespace-delimited chunks of non-whitespace) from the given string.
	 * Empty words are not included -- this means that the result is a zero-length array for
	 * an input string that consists entirely of whitespace.
	 */
	public static String[] words(String s) {
		s = s.trim();
		if (s.length() == 0)
			return new String[0];
		return whitespace.split(s);
	}

	/**
	 * Split a string into paragraphs (delimited by empty lines). Line endings are not preserved.
	 */
	public static String[] paragraphs(String s) {
		List<String> paragraphs = new ArrayList<>();

		StringBuilder paragraph = new StringBuilder();
		boolean emptyParagraph = true;

		for (String line : StringUtil.lines(s)) {
			if (line.isEmpty()) {
				// line only has line endings, i.e. is between paragraphs.
				if (!emptyParagraph)
					paragraphs.add(paragraph.toString());
				paragraph = new StringBuilder();
				emptyParagraph = true;
			} else {
				if(paragraph.length() != 0)
					paragraph.append(' ');
				paragraph.append(line);
				emptyParagraph = false;
			}
		}
		if (!emptyParagraph)
			paragraphs.add(paragraph.toString());
		return paragraphs.toArray(new String[0]);
	}

	private static final char[] HEX_CHARS = "0123456789abcdef".toCharArray();

	/** Convert an array of bytes into an array of lower-case hex digits. */
	public static String toHex (byte ... bytes)
	{
		StringBuilder strBldr = new StringBuilder(bytes.length * 2);
		char[] hexchars = HEX_CHARS;
		for (byte b : bytes) {
			strBldr.append(hexchars[(b >>> 4) & 0xF]).append(hexchars[b & 0xF]);
		}
		return strBldr.toString();

	}

	 /**
	  * Convert String of hexadecimal digits to an array of bytes.
	  * @throws NumberFormatException if string does not have an even length or
	  *            contains invalid characters.
	  */
	public static byte[] fromHex(String string) {
		int len = string.length();
		if(len % 2 != 0)
			throw new NumberFormatException("Hexadecimal string should have an even number of characters.");
		byte[] data = new byte[len / 2];
		int index = 0;
		for (int i = 0; i < len; i += 2) {
			int a = Character.digit(string.charAt(i), 16);
			if(a == -1)
				throw new NumberFormatException("Invalid character in hexadecimal string: " + string.charAt(i));
			int b = Character.digit(string.charAt(i+1), 16);
			if(b == -1)
				throw new NumberFormatException("Invalid character in hexadecimal string: " + string.charAt(i+1));
			data[index] = (byte) ((a << 4) | b);
			index++;
		}
		return data;
	}

	/**
	 * Return a 8 character String describing the duration in {@code nanoSeconds}.
	 * <p>
	 * The duration will be scaled and expressed using the appropriate units: nano-, micro-, milli-,
	 * seconds, minutes, hours, days, or years.
	 * </p>
	 */
	public static String getDurationString (long nanoSeconds)
	{
		char sign   = nanoSeconds < 0 ? '-' : '+';
		nanoSeconds = nanoSeconds < 0 ? -nanoSeconds : nanoSeconds;
		if (nanoSeconds < 1e4) {
			return sign + getDurationString(nanoSeconds, 1,   "[ns]");
		}
		else if (nanoSeconds < 1e7) {
			return sign + getDurationString(nanoSeconds, 1e3, "[us]");
		}
		else if (nanoSeconds < 1e10) {
			return sign + getDurationString(nanoSeconds, 1e6, "[ms]");
		}
		else if (nanoSeconds < 1e13) {
			return sign + getDurationString(nanoSeconds, 1e9, "[s] ");
		}
		else if (nanoSeconds < 60e13) {
			return sign + getDurationString(nanoSeconds, 60e9, "[m] ");
		}
		else if (nanoSeconds < 3600e13) {
			return sign + getDurationString(nanoSeconds, 3600e9, "[h] ");
		}
		else if (nanoSeconds < 86400e13) {
			return sign + getDurationString(nanoSeconds, 86400e9, "[d] ");
		}
		else {
			return sign + getDurationString(nanoSeconds, 31536000e9, "[y] ");
		}
	}

	/**
	 * Return a four character representation of the given duration in {@code nanoSeconds}, divided by
	 * the given {@code divisor} and suffixed with the given {@code unit}.
	 *
	 * @param nanoSeconds The duration to express; must be non-negative.
	 * @see #getDurationString(long)
	 */
	private static String getDurationString (long nanoSeconds, double divisor, String unit)
	{
		// Format as a 4 character floating point
		String scaledStr = String.format("%-4f", nanoSeconds / divisor).substring(0, 4);
		// Replace a trailing decimal with a space
		return (scaledStr.endsWith(".") ? scaledStr.replace(".", " ") : scaledStr) + unit;
	}

	/**
	 * Parse an Integer from the given {@code string}, returning null if parsing failed for any
	 * reason.
	 */
	public static Integer parseInteger (String string)
	{
		// Quick break-out if string is null
		if (string == null) {
			return null;
		}
		// Attempt to parse an integer
		try {
			return Integer.parseInt(string);
		}
		catch(NumberFormatException nfe) {
			Exceptions.ignore(nfe, "deliberate test");
			return null;
		}
	}

	/**
	 * Append to a given {@link StringBuilder} a sequence of Objects via their
	 * {@link Object#toString()} method, and return the StringBuilder.
	 */
	public static StringBuilder appendLine (StringBuilder strBldr, Object ... args)
	{
		for(Object arg : args) {
			strBldr.append(arg);
		}
		return strBldr.append("\n");
	}

	/**
	 * Compose a new String with every line prepended with a given prefix.
	 * <p>
	 * The final portion of the {@code text} that is not terminated with a newline character will be
	 * prefixed if and only if it is non-empty.
	 * </p>
	 *
	 * @param prefix The string that shall be prefixed to every line in {@code text}.
	 * @param text The string to split into lines and prefix.
	 */
	public static String prefixLines (String prefix, String text)
	{
		return text.replaceAll("(?m)^", prefix);
	}

	/**
	 * Count the number of times a character occurs in a string.
	 *
	 * @param str The string to search in.
	 * @param ch The character to look for.
	 */
	public static int count (String str, char ch)
	{
		int r = 0;
		for (int i = 0; i < str.length(); i++) {
			if (str.charAt(i) == ch) {
				r++;
			}
		}
		return r;
	}

	/**
	 * Add line numbers to the start of each line of the given {@code plainText}.
	 *
	 * @param plainText - some plain text, with lines distinguished by one of the standard
	 *            line-endings.
	 * @return the {@code plainText}, with 1-indexed line numbers inserted at the start of each
	 *         line. The line numbers will be of a fixed width comprising the length of the largest
	 *         line number.
	 */
	public static String addLineNumbers(String plainText) {
		/*
		 * Add line numbers to the plain text code sample.
		 */
		String[] lines = StringUtil.lines(plainText, false);
		// The maximum number of characters needed to represent the line number
		int lineColumnWidth = Integer.toString(lines.length).length();

		StringBuilder sampleWithLineNumbers = new StringBuilder();
		for (int i = 0; i < lines.length; i++) {
			boolean last = i == lines.length -1;
			sampleWithLineNumbers.append(String.format("%" + lineColumnWidth + "s  %s" + (last ? "" : "\n"), i + 1, lines[i]));
		}
		return sampleWithLineNumbers.toString();
	}

	// Pattern that matches a string of (at least one) decimal digits
	private static final Pattern DIGITS_PATTERN = Pattern.compile("[0-9]+");

	/** Return true iff the given string consists only of digits */
	public static boolean isDigits(String s) {
		return DIGITS_PATTERN.matcher(s).matches();
	}

	/**
	 * Determine whether a given {@code char} is an ASCII letter.
	 */
	public static boolean isAsciiLetter (char c)
	{
		return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
	}

	/**
	 * A {@link String} comparison function to hopefully help mitigate against timing attacks.
	 * Aims to be constant time in the length of the first argument however due to the nature
	 * of Java this is very hard to achieve reliably. Callers should not rely on this method
	 * being perfectly constant time and other defenses should be introduced as necessary
	 * to prevent timing attacks based on how critical it is to avoid them.
	 * <p>
	 * Each argument may safely be null.
	 * <p>
	 * Note there is a unit tests that asserts the timing properties of this method which is
	 * committed but not run by default. If any changes are made to the implementation then
	 * {@code StringUtilTests#secureIsEqualTiming} must be run manually.
	 */
	public static boolean secureIsEqual(String a, String b) {
		if (a == null) {
			// Since we are aiming for constant time in the length of the
			// first argument only, it is ok to bail out quickly if a is null.
			return b == null;
		}

		byte[] aBytes = stringToBytes(a);

		boolean definitelyDifferent = b == null || b.length() != a.length();
		byte[] bBytes = stringToBytes(definitelyDifferent ? a : b);
		byte[] randomBBytes = new byte[a.length()];
		RANDOM.nextBytes(randomBBytes);
		if (definitelyDifferent) {
			bBytes = randomBBytes;
		}

		int result = 0;
		for (int i = 0; i < aBytes.length; i++) {
			result |= aBytes[i] ^ bBytes[i];
		}
		return result == 0 && !definitelyDifferent;
	}

	public static String lineSeparator(){
		return System.getProperty("line.separator");
	}

	public static <T> String naturalGlue(String separator, String finalSeparator, Collection<T> values) {
		StringBuilder stringBuilder = new StringBuilder();
		Iterator<T> iterator = values.iterator();
		boolean first = true;
		if(iterator.hasNext()) {
			boolean hasNext = true;
			T current = iterator.next();
			while(hasNext) {
				hasNext = iterator.hasNext();
				T next = iterator.hasNext() ? iterator.next() : null;
				if(first) {
					first = false;
				}
				else if(!hasNext) {
					stringBuilder.append(finalSeparator);
				}
				else {
					stringBuilder.append(separator);
				}
				stringBuilder.append(current != null ? current : "<null>");
				current = next;
			}
		}
		return stringBuilder.toString();
	}

	/**
	 * Convert a CamelCase (or camelCase) string to spinal-case. Adjacent sequences of upper-case
	 * characters are treated as a single word, so that "getXML" would be converted to "get-xml".
	 * Where a lower-case character follows an upper-case character <i>after</i> a sequence of at
	 * least on upper-case character, the last upper-case character in the sequence is assumed to
	 * be the first letter of a new word, rather than the last letter of an acronym. Thus,
	 * "getXMLFile" becomes "get-xml-file" rather than "get-xmlfile" or "get-xmlf-ile".
	 *
	 * @return The spinal-cased equivalent of {@code camelCaseStr}, or null if it is null.
	 */
	public static String camelToSpinal(String camelCaseStr) {
		// Quick break-out if the string is null
		if (camelCaseStr == null)
			return null;
		// Convert to spinal-case
		String        lcStr   = camelCaseStr.toLowerCase(Locale.ENGLISH);
		StringBuilder strBldr = new StringBuilder();
		for(int i=0; i<camelCaseStr.length();) {
			if (camelCaseStr.charAt(i) != lcStr.charAt(i)) {
				if (i > 0) {
					// Next character is upper-case, and not at the start of the string,
					// so insert a preceding dash
					strBldr.append("-");
				}
				// Consume (append in l.c.) all contiguously following u.c. characters, except that
				// if a sequence of two or more u.c. characters occurs followed by a l.c. character
				// assume that the last u.c. character is the first in a new word and insert a -
				// preceding the new word.
				//
				// Thus getXML becomes get-xml, but getXMLFile becomes get-xml-file rather than
				// get-xmlfile.
				int numUc = 0;
				while(i<camelCaseStr.length() && camelCaseStr.charAt(i) != lcStr.charAt(i)) {
					if (  numUc > 0
					   && i+1 < camelCaseStr.length()
					   && camelCaseStr.charAt(i+1) == lcStr.charAt(i+1)
					   && isAsciiLetter(lcStr.charAt(i+1))) {
						strBldr.append("-").append(lcStr.charAt(i++));
						break;
					}
					strBldr.append(lcStr.charAt(i++));
					++numUc;
				}
			}
			// Consume (append) all contiguously following l.c. characters
			while(i<camelCaseStr.length() && camelCaseStr.charAt(i) == lcStr.charAt(i))
				strBldr.append(lcStr.charAt(i++));
		}

		return strBldr.toString();
	}

	public static String lowerCaseFirstLetter(String s) {
		if (s == null || s.isEmpty())
			return s;

		final char[] chars = s.toCharArray();
		chars[0] = Character.toLowerCase(chars[0]);
		return new String(chars);
	}

	/**
	 * Returns the string with double-quoted strings, single line comments and multiline comments
	 * removed.
	 * <p>
	 *
	 * @param ql The QL code string
	 * @param terminateStringsAtLineEnd If true, then strings are treated as ending at EOL;
	 * if false, unterminated strings result in an IllegalArgumentException.
	 *
	 * NB QL does not support multiline strings.
	 */
	public static String stripQlCommentsAndStrings(String ql, boolean terminateStringsAtLineEnd) {
		StringBuilder returnBuilder = new StringBuilder();
		// in a quoted string you must ignore both comment starters
		// in a multi-line comment you must ignore the other two (single line comment and string) starters
		// in a single line comment you can just eat up to the end of the line
		boolean inString = false;
		boolean inMultiLineComment = false;
		boolean inSingleLineComment = false;
		for (int i = 0; i < ql.length(); i++) {
			// String
			if (!inMultiLineComment && !inSingleLineComment && matchesAt(ql, i, "\"") && !isEscaped(ql, i)) {
				inString = !inString;
				continue;
			} else if (matchesEolAt(ql, i)) {
				if (terminateStringsAtLineEnd) {
					inString = false; // force strings to end at EOL - multi-line strings are invalid
				} else if (inString) {
					throw new IllegalArgumentException("Unterminated string found.");
				}
			}

			// Single-line comment
			if (!inString && !inMultiLineComment && matchesAt(ql, i, "//")) {
				inSingleLineComment = true;
				continue;
			} else if (inSingleLineComment && matchesEolAt(ql, i)) {
				inSingleLineComment = false;
			}

			// Multi-line comment
			if (!inString && !inSingleLineComment && matchesAt(ql, i, "/*")) {
				inMultiLineComment = true;
			} else if (inMultiLineComment && matchesAt(ql, i, "*/")) {
				inMultiLineComment = false;
				i++; // skip the next character (the '/') as well as this one

				continue;
			}

			if (inString || inMultiLineComment || inSingleLineComment) {
				continue;
			}

			returnBuilder.append(ql.charAt(i));
		}

		if (inString && !terminateStringsAtLineEnd) {
			throw new IllegalArgumentException("Unterminated string found.");
		}

		return returnBuilder.toString();
	}

	/**
	 * Calls (@link #stripQlCommentsAndStrings(String, boolean),
	 * passing {@code false} for the {@code terminateStringsAtLineEnd} parameter.
	 */
	public static String stripQlCommentsAndStrings(String ql) {
		return stripQlCommentsAndStrings(ql, false);
	}

	private static boolean matchesAt(String sourceString, int currentCharIndex, String subString) {
		if (currentCharIndex + subString.length() > sourceString.length()) {
			return false;
		}

		return sourceString.substring(currentCharIndex, currentCharIndex + subString.length()).equals(subString);
	}

	private static boolean matchesEolAt(String sourceString, int currentCharIndex ) {
		return matchesOneOfAt(sourceString, currentCharIndex, "\n", "\r");
	}

	private static boolean matchesOneOfAt(String sourceString, int currentCharIndex, String... subStrings) {
		for (String subString: subStrings) {
			if (matchesAt(sourceString, currentCharIndex, subString)) {
				return true;
			}
		}
		return false;
	}

	private static boolean isEscaped(String theString, int currentCharIndex) {
		if (currentCharIndex == 0) {
			return false;
		}
		return previousCharacter(theString, currentCharIndex) == '\\' && !isEscaped(theString, currentCharIndex-1);
	}

	private static char previousCharacter(String theString, int currentCharIndex) {
		if (currentCharIndex == 0) {
			return Character.MIN_VALUE;
		}
		return theString.charAt(currentCharIndex - 1);
	}

	/**
	 * Compare two arrays of strings. The two arrays are considered equal if they
	 * are either both null or contain equal elements in the same order (ignoring
	 * case).
	 *
	 * @param a
	 *            the first array
	 * @param a2
	 *            the second array
	 * @return true iff the elements in the arrays are equal when ignoring case
	 */
	public static boolean arrayEqualsIgnoreCase(String[] a, String[] a2) {
		if (a == null) return a2 == null;
		if (a2 == null) return false;
		if (a.length != a2.length) return false;
		for (int i = 0; i < a.length; i++) {
			if ((a[i] == null && a2[i] != null) || !a[i].equalsIgnoreCase(a2[i])) return false;
		}
		return true;
	}

	public static final Pattern NEWLINE_PATTERN = Pattern.compile("\n");

	/**
	 * Convert a string into a doc comment with the content as the body.
	 */
	public static String toCommentString(String content) {
		StringBuilder result = new StringBuilder();
		result.append("/**\n");
		String[] lines = StringUtil.lines(content);
		for (String line: lines) {
			result.append(" *" + line);
			result.append("\n");
		}
		result.append(" */");
		return result.toString();
	}

	/**
	 * Is {@code str} composed only of printable ASCII characters (excluding
	 * newline, carriage return and tab but including space)?
	 */
	public static boolean isPrintableAscii(String str) {
		if (str == null)
			return false;
		for(int i=0; i<str.length(); ++i) {
			if (!isPrintableAscii(str.charAt(i)))
				return false;
		}

		return true;
	}

	/**
	 * Is {@code c} a printable ASCII character (excluding newline, carriage
	 * return and tab, but including space)?
	 */
	public static boolean isPrintableAscii(char c) {
		return c >= 32 && c < 127;
	}

	/**
	 * Return true if {@code str} only contains characters which are either printable ASCII or ASCII whitespace
	 */
	public static boolean isAsciiText(String str) {
		for(int i=0; i<str.length(); ++i) {
			if (!isAsciiText(str.charAt(i)))
				return false;
		}

		return true;
	}

	/**
	 * Return true if {@code c} is either a printable ASCII character or ASCII whitespace character
	 */
	public static boolean isAsciiText(char c) {
		return (
			isPrintableAscii(c) ||
			c == '\t' ||
			c == '\n' ||
			c == '\r'
		);
	}

	/**
	 * Returns true if {@code str} contains ASCII characters < 32 or == 127,
	 * other than \n, \t, \r
	 */
	public static boolean containsControlCharacters(String str) {
		for (char c: str.toCharArray()) {
			if (isControlCharacter(c)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * "Control character" here means code point 127 (DEL),
	 * characters in C0 block [0, 31] excluding \t, \n, or \r
	 * or characters in C1 block [128, 159]
	 */
	public static boolean isControlCharacter(char c) {
		// C1 control characters run from 128-159
		// but Unicode above that is okay
		if (c > 159) {
			return false;
		}

		// Most of ASCII is okay
		if (c >= 32 && c < 127) {
			return false;
		}

		// Basic whitespace is okay
		if (c == '\t' ||
			c == '\n' ||
			c == '\r') {
			return false;
		}

		// If we've got this far, it must be a control character
		return true;
	}

}
