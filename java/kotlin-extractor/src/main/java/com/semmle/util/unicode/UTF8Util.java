package com.semmle.util.unicode;

public class UTF8Util {
	/**
	 * Get the length (in Unicode code units, not code points) of the longest prefix of
	 * a string that can be UTF-8 encoded in no more than the given number of bytes.
	 *
	 * <p>
	 * Unencodable characters (such as lone surrogate halves or low surrogates
	 * that do not follow a high surrogate) are treated as being encoded in
	 * three bytes. This is safe since on encoding they will be replaced by
	 * a replacement character, which in turn will take at most three bytes to
	 * encode.
	 * </p>
	 *
	 * @param str string to encode
	 * @param maxEncodedLength maximum number of bytes for the encoded prefix
	 * @return length of the prefix
	 */
	public static int encodablePrefixLength(String str, int maxEncodedLength) {
		// no character takes more than three bytes to encode
		if (str.length() > maxEncodedLength / 3) {
			int encodedLength = 0;
			for (int i = 0; i < str.length(); ++i) {
				int oldI = i;
				char c = str.charAt(i);
				if (c <= 0x7f) {
					encodedLength += 1;
				} else if (c <= 0x7ff) {
					encodedLength += 2;
				} else if (Character.isHighSurrogate(c)) {
					// surrogate pairs take four bytes to encode
					if (i+1 < str.length() && Character.isLowSurrogate(str.charAt(i+1))) {
						encodedLength += 4;
						++i;
					} else {
						// lone high surrogate, assume length three
						encodedLength += 3;
					}
				} else {
					encodedLength += 3;
				}

				if (encodedLength > maxEncodedLength) {
					return oldI;
				}
			}
		}

		return str.length();
	}
}
