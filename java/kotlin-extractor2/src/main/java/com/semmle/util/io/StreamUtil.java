package com.semmle.util.io;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.nio.charset.StandardCharsets;

import com.semmle.util.exception.CatastrophicError;

/**
 * Utility methods concerning {@link InputStream}s and {@link OutputStream}s.
 */
public class StreamUtil
{
	/**
	 * Copy all bytes that can be read from an {@link InputStream}, into an {@link OutputStream}.
	 *
	 * @param inputStream The InputStream from which to read, until an
	 *          {@link InputStream#read(byte[])} operation returns indicating that the input stream
	 *          has reached its end.
	 * @param outputStream The OutputStream to which all bytes read from {@code inputStream} should be
	 *          written.
	 * @return The number of bytes copied.
	 * @throws IOException from {@link InputStream#read(byte[])} or
	 *           {@link OutputStream#write(byte[], int, int)}
	 * @throws CatastrophicError if either of the streams is {@code null}
	 */
	public static long copy(InputStream inputStream, OutputStream outputStream) throws IOException
	{
		nullCheck(inputStream, outputStream);

		// Copy byte data
		long   total = 0;
		byte[] bytes = new byte[1024];
		int    read;
		while ((read = inputStream.read(bytes)) > 0) {
			outputStream.write(bytes, 0, read);
			total += read;
		}
		return total;
	}
	
	/**
	 * Copy all chars that can be read from a {@link Reader}, into a {@link Writer}.
	 *
	 * @param reader The Reader from which to read, until a {@link Reader#read(char[])} operation
	 *            returns indicating that the reader has reached its end.
	 * @param writer The Writer to which all characters read from {@code reader} should be written.
	 * @return The number of bytes copied.
	 * @throws IOException from {@link Reader#read(char[])} or
	 *             {@link Writer#write(char[], int, int)}
	 * @throws CatastrophicError if either of the streams is {@code null}
	 */
	public static long copy(Reader reader, Writer writer) throws IOException
	{
		nullCheck(reader, writer);

		// Copy byte data
		long   total = 0;
		char[] chars = new char[1024];
		int    read;
		while ((read = reader.read(chars)) > 0) {
			writer.write(chars, 0, read);
			total += read;
		}
		return total;
	}

	/**
	 * Copy at most {@code length} bytes from an {@link InputStream}, into an {@link OutputStream}.
	 * <p>
	 * Note that this method will busy-wait during periods for which the {@code inputStream} cannot
	 * supply any data, but has not reached its end.
	 * </p>
	 *
	 * @param inputStream The InputStream from which to read, until {@code length} bytes have
	 *          been read or {@link InputStream#read(byte[], int, int)} operation returns
	 *          indicating that the input stream has reached its end.
	 * @param outputStream The OutputStream to which all bytes read from {@code inputStream} should be
	 *          written.
	 * @param length The maximum number of bytes to copy
	 * @return The number of bytes copied.
	 * @throws IOException from {@link InputStream#read(byte[], int, int)} or
	 *           {@link OutputStream#write(byte[], int, int)}
	 * @throws CatastrophicError if either of the streams is {@code null}
	 */
	public static long limitedCopy(InputStream inputStream, OutputStream outputStream, long length) throws IOException
	{
		nullCheck(inputStream, outputStream);

		// Copy byte data
		long   total = 0;
		byte[] bytes = new byte[1024];
		int    read;
		while ((read = inputStream.read(bytes, 0, (int) Math.min(bytes.length, length))) > 0) {
			outputStream.write(bytes, 0, read);
			length -= read;
			total += read;
		}
		return total;
	}

	private static void nullCheck(Object input, Object output) {
		CatastrophicError.throwIfAnyNull(input, output);
	}

	/**
	 * Skips over and discards n bytes of data from an input stream. If n is negative then no bytes are skipped.
	 * @param stream the InputStream
	 * @param n the number of bytes to be skipped.
	 * @return false if the end-of-file was reached before successfully skipping n bytes
	 */
	public static boolean skip(InputStream stream, long n) throws IOException {
		if (n <= 0)
			return true;
		long toSkip = n - 1;

		while (toSkip > 0) {
			long skipped = stream.skip(toSkip);
			if (skipped == 0) {
				if(stream.read() == -1)
					return false;
				else
					skipped++;
			}
			toSkip -= skipped;
		}
		if(stream.read() == -1)
			return false;
		else
			return true;
	}

	/**
	 * Reads n bytes from the input stream and returns them. This method will block
	 * until all n bytes are available. If the end of the stream is reached before n bytes are
	 * read it returns just the read bytes.
	 *
	 * @param stream the InputStream
	 * @param n the number of bytes to read
	 * @return the read bytes
	 * @throws IOException if an IOException occurs when accessing the stream
	 * @throws IllegalArgumentException if n is negative
	 */
	public static byte[] readN(InputStream stream, int n) throws IOException {
		if (n < 0) throw new IllegalArgumentException("n must be positive");

		ByteArrayOutputStream bOut = new ByteArrayOutputStream();
		limitedCopy(stream, bOut, n);
		return bOut.toByteArray();
	}

	/**
	 * Reads bytes from the input stream into the given buffer. This method will block
	 * until all bytes are available. If the end of the stream is reached before enough bytes are
	 * read it reads as much as it can.
	 *
	 * @param stream the InputStream
	 * @param buf the buffer to read into
	 * @param offset the offset to read into
	 * @param length the number of bytes to read
	 * @return the total number of read bytes
	 * @throws IOException if an IOException occurs when accessing the stream
	 * @throws IllegalArgumentException if n is negative
	 */
	public static int read(InputStream stream, byte[] buf, int offset, int length) throws IOException {
		if (length < 0) throw new IllegalArgumentException("length must be positive");

		// Copy byte data
		int total = 0;
		int read;
		while ((read = stream.read(buf, offset, length)) > 0) {
			length -= read;
			total += read;
		}

		return total;
	}

	/**
	 * Convenience method for constructing a buffered reader with a UTF8 charset.
	 */
	public static BufferedReader newUTF8BufferedReader(InputStream inputStream) {
		return new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
	}

	/**
	 * Convenience method for constructing a buffered writer with a UTF8 charset.
	 */
	public static BufferedWriter newUTF8BufferedWriter(OutputStream outputStream) {
		return new BufferedWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8));
	}

}
