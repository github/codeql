package com.semmle.util.data;

import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.semmle.util.exception.CatastrophicError;

/**
 * Encapsulate the creation of message digests from strings.
 * 
 * <p>
 * This class acts as a (partial) output stream, until the <code>getDigest()</code> method is
 * called. After this the class can no longer be used, except to repeatedly call
 * {@link #getDigest()}.
 * 
 * <p>
 * UTF-8 is used internally as the {@link Charset} for this class when converting Strings to bytes.
 */
public class StringDigestor {
	private static final Charset UTF8 = Charset.forName("UTF-8");
	private static final String NULL_STRING = "<null>";
	private static final int CHUNK_SIZE = 32;

	private MessageDigest digest;
	private byte[] digestBytes;
	private final byte[] buf = new byte[CHUNK_SIZE * 3]; // A Java char becomes at most 3 bytes of UTF-8

	/**
	 * Create a StringDigestor using SHA-1, ready to accept data
	 */
	public StringDigestor() {
		this("SHA-1");
	}

	/**
	 * @param digestAlgorithm the algorithm to use in the internal {@link MessageDigest}.
	 */
	public StringDigestor(String digestAlgorithm) {
		try {
			digest = MessageDigest.getInstance(digestAlgorithm);
		} catch (NoSuchAlgorithmException e) {
			throw new CatastrophicError("StringDigestor failed to find the required digest algorithm: " + digestAlgorithm, e);
		}
	}

	public void reset() {
		if (digestBytes == null) throw new CatastrophicError("API violation: Digestor is not finished.");
		digest.reset();
		digestBytes = null;
	}

	/**
	 * Write an object into this digestor. This converts the object to a
	 * string using toString(), writes the length, and then writes the
	 * string itself.
	 */
	public StringDigestor write(Object toAppend) {
		String str;
		if (toAppend == null) {
			str = NULL_STRING;
		} else {
			str = toAppend.toString();
		}
		writeBinaryInt(str.length());
		writeNoLength(str);
		return this;
	}

	/**
	 * Write the given string without prefixing it by its length. 
	 */
	public StringDigestor writeNoLength(Object toAppend) {
		String s = toAppend.toString();
		int len = s.length();
		int i = 0;
		while(i + CHUNK_SIZE < len) {
			i = writeUTF8(s, i, i + CHUNK_SIZE);
		}
		writeUTF8(s, i, len);
		return this;
	}

	private int writeUTF8(String s, int begin, int end) {
		if (digestBytes != null) throw new CatastrophicError("API violation: Digestor is finished.");
		byte[] buf = this.buf;
		int len = 0;
		for(int i = begin; i < end; ++i) {
			int c = s.charAt(i);
			if (c <= 0x7f) {
				buf[len++] = (byte)c;
			} else if (c <= 0x7ff) {
				buf[len] = (byte)(0xc0 | (c >> 6));
				buf[len+1] = (byte)(0x80 | (c & 0x3f));
				len += 2;
			} else if (c < 0xd800 || c > 0xdfff) {
				buf[len] = (byte)(0xe0 | (c >> 12));
				buf[len+1] = (byte)(0x80 | ((c >> 6) & 0x3f));
				buf[len+2] = (byte)(0x80 | (c & 0x3f));
				len += 3;
			} else if (i + 1 < end) {
				int c2 = s.charAt(i + 1);
				if (c > 0xdbff || c2 < 0xdc00 || c2 > 0xdfff) {
					// Invalid UTF-16
				} else {
					c = 0x10000 + ((c - 0xd800) << 10) + (c2 - 0xdc00);
					buf[len] = (byte)(0xf0 | (c >> 18));
					buf[len+1] = (byte)(0x80 | ((c >> 12) & 0x3f));
					buf[len+2] = (byte)(0x80 | ((c >> 6) & 0x3f));
					buf[len+3] = (byte)(0x80 | (c & 0x3f));
					len += 4;
					++i;
				}
			} else {
				--end;
				break;
			}
		}
		digest.update(buf, 0, len);
		return end;
	}

	/**
	 * Write an array of raw bytes to the digestor. This appends the contents
	 * of the array to the accumulated data used for the digest.
	 */
	public StringDigestor writeBytes(byte[] data) {
		if (digestBytes != null) throw new CatastrophicError("API violation: Digestor is finished.");
		digest.update(data);
		return this;
	}

	/**
	 * Return the hex-encoded digest as a {@link String}.
	 * 
	 * Get the digest from the data previously appended using <code>write(Object)</code>.
	 * After this is called, the instance's {@link #write(Object)} and {@link #writeBytes(byte[])}
	 * methods may no longer be used.
	 */
	public String getDigest() {
		if (digestBytes == null) {
			digestBytes = digest.digest();
		}
		return StringUtil.toHex(digestBytes);
	}

	public static String digest(Object o) {
		StringDigestor digestor = new StringDigestor();
		digestor.writeNoLength(o);
		return digestor.getDigest();
	}

	/** Compute a git-style SHA for the given string. */
	public static String gitBlobSha(String content) {
		byte[] bytes = content.getBytes(UTF8);
		return digest("blob " + bytes.length + "\0" + content);
	}

	/**
	 * Convert an int to a byte[4] using its little-endian 32bit representation, and append the
	 * resulting bytes to the accumulated data used for the digest.
	 */
	public StringDigestor writeBinaryInt(int i) {
		if (digestBytes != null) throw new CatastrophicError("API violation: Digestor is finished.");
		byte[] buf = this.buf;
		buf[0] = (byte)(i & 0xff);
		buf[1] = (byte)((i >>> 8) & 0xff);
		buf[2] = (byte)((i >>> 16) & 0xff);
		buf[3] = (byte)((i >>> 24) & 0xff);
		digest.update(buf, 0, 4);
		return this;
	}
}
