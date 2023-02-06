package com.semmle.util.io;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.Arrays;
import java.util.regex.Pattern;

import com.semmle.util.array.ArrayUtil;
import com.semmle.util.data.IntRef;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.FileUtil;

/**
 * A class that allows bulk operations on entire files,
 * reading or writing them as {@link String} values.
 * 
 * This is intended to address the woeful inadequacy of
 * the Java standard libraries in this area.
 */
public class WholeIO {
	private IOException e;
	
	/**
	 * Regular expression {@link Pattern}
	 */
	private final static Pattern rpLineEndingCRLF = Pattern.compile("\r\n");
	
	/**
	 * The default encoding to use for writing, and for reading if no
	 * encoding can be detected.
	 */
	private final String defaultEncoding;
	
	/**
	 * Construct a new {@link WholeIO} instance using ODASA's default
	 * charset ({@code "UTF-8"}) for all input and output (unless a
	 * different encoding is detected for a file being read).
	 */
	public WholeIO() {
		this("UTF-8");
	}
	
	/**
	 * Construct a new {@link WholeIO} instance using the specified
	 * encoding for all input and output (unless a different encoding
	 * is detected for a file being read).
	 * 
	 * @param encoding The encoding name, e.g. {@code "UTF-8"}.
	 */
	public WholeIO(String encoding) {
		defaultEncoding = encoding;
	}
	
	/**
	 * Open the given file for reading, get the entire content
	 * and return it as a {@link String}. Returns <code>null</code>
	 * on error, in which case you can check the getLastException()
	 * method for the exception that occurred.
	 * 
	 * <b>Warning:</b> This method trims the content of the file, removing
	 * leading and trailing whitespace. Do not use it if you care about file
	 * locations being preserved; use 'read' instead.
	 * 
	 * @param file The file to read
	 * @return The <b>trimmed</b> contents of the file, or <code>null</code> on error.
	 */
	public String readAndTrim(File file) {
		e = null;
		FileInputStream f = null;
		try {
			f = new FileInputStream(file);
			String contents = readString(f);
			return contents == null ? null : contents.trim();
		} catch (IOException e) {
			this.e = e;
			return null;
		} finally {
			FileUtil.close(f);
		}
	}

	/**
	 * Open the given filename for writing and dump the given
	 * {@link String} into it. Returns <code>false</code>
	 * on error, in which case you can check the getLastException()
	 * method for the exception that occurred. Tries to create any
	 * enclosing directories that do not exist.
	 * 
	 * @param filename The name of the file to write to
	 * @param contents the string to write out
	 * @return the success state
	 */
	public boolean write(String filename, String contents) {
		return write(new File(filename), contents);
	}

	/**
	 * Open the given filename for writing and dump the given
	 * {@link String} into it. Returns <code>false</code>
	 * on error, in which case you can check the getLastException()
	 * method for the exception that occurred. Tries to create any
	 * enclosing directories that do not exist.
	 * 
	 * @param file The file to write to
	 * @param contents the string to write out
	 * @return the success state
	 */
	public boolean write(File file, String contents) {
		return write(file, contents, false);
	}

	/**
	 * Open the given path for writing and dump the given
	 * {@link String} into it. Returns <code>false</code>
	 * on error, in which case you can check the getLastException()
	 * method for the exception that occurred. Tries to create any
	 * enclosing directories that do not exist.
	 *
	 * @param path The path to write to
	 * @param contents the string to write out
	 * @return the success state
	 */
	public boolean write(Path path, String contents) {
		return write(path, contents, false);
	}

	/**
	 * Open the given filename for writing and dump the given
	 * {@link String} into it. Throws {@link ResourceError}
	 * if we fail.
	 * 
	 * @param file The file to write to
	 * @param contents the string to write out
	 */
	public void strictwrite(File file, String contents) {
		strictwrite(file, contents, false);
	}

	/**
	 * Open the given path for writing and dump the given
	 * {@link String} into it. Throws {@link ResourceError}
	 * if we fail.
	 *
	 * @param path The path to write to
	 * @param contents the string to write out
	 */
	public void strictwrite(Path path, String contents) {
		strictwrite(path, contents, false);
	}

	/**
	 * This is the same as {@link #write(File,String)},
	 * except that this method allows appending to an existing file.
	 * 
	 * @param file the file to write to
	 * @param contents the string to write out
	 * @param append whether or not to append to any existing file
	 * @return the success state
	 */
	public boolean write(File file, String contents, boolean append) {
		if (file.getParentFile() != null)
			file.getParentFile().mkdirs();
		
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(file, append);
			Writer writer = new OutputStreamWriter(fos, Charset.forName(defaultEncoding));
			writer.append(contents);
			writer.close();
			return true;
		} catch (IOException e) {
			this.e = e;
			return false;
		} finally {
			FileUtil.close(fos);
		}
	}

	/**
	 * This is the same as {@link #write(Path,String)},
	 * except that this method allows appending to an existing file.
	 *
	 * @param path the path to write to
	 * @param contents the string to write out
	 * @param append whether or not to append to any existing file
	 * @return the success state
	 */
	public boolean write(Path path, String contents, boolean append) {
		try {
			if (path.getParent() != null)
				Files.createDirectories(path.getParent());

			try (Writer writer = Files.newBufferedWriter(path, Charset.forName(defaultEncoding),
					StandardOpenOption.CREATE, StandardOpenOption.WRITE,
					append ? StandardOpenOption.APPEND : StandardOpenOption.TRUNCATE_EXISTING)) {
				writer.append(contents);
			}
		} catch (IOException e) {
			this.e = e;
			return false;
		}
		return true;
	}

	/**
	 * This is the same as {@link #strictwrite(File,String)},
	 * except that this method allows appending to an existing file.
	 */
	public void strictwrite(File file, String contents, boolean append) {
		if (!write(file, contents, append))
			throw new ResourceError("Failed to write file " + file, getLastException());
	}

	/**
	 * This is the same as {@link #strictwrite(Path,String)},
	 * except that this method allows appending to an existing file.
	 */
	public void strictwrite(Path path, String contents, boolean append) {
		if (!write(path, contents, append))
			throw new ResourceError("Failed to write path " + path, getLastException());
	}

	/**
	 * Get the exception that occurred during the last call to
	 * read(), if any. If the last read() call completed normally,
	 * this returns null.
	 * @return The last caught exception, or <code>null</code> if N/A.
	 */
	public IOException getLastException() {
		return e;
	}
	
	public String read(File file) {
		InputStream is = null;
		try {
			is = new FileInputStream(file);
			return readString(is);
		}
		catch (IOException e) {
			this.e = e;
			return null;
		}
		finally {
			FileUtil.close(is);
		}
	}

	public String read(Path path) {
		InputStream is = null;
		try {
			is = Files.newInputStream(path);
			return readString(is);
		}
		catch (IOException e) {
			this.e = e;
			return null;
		}
		finally {
			FileUtil.close(is);
		}
	}

	/**
	 * Read the contents of the given {@link File} as text (line endings are normalised to "\n" in the output).
	 *
	 * @param file	The file to read.
	 * @return		The text contents of the file, if possible, or null if the file cannot be read.
	 */
	public String readText(File file) {
		String result = read(file);
		return result != null ? result.replaceAll("\r\n", "\n") : null;
	}

	/**
	 * Read the contents of the given {@link Path} as text (line endings are normalised to "\n" in the output).
	 *
	 * @param path	The path to read.
	 * @return		The text contents of the path, if possible, or null if the file cannot be read.
	 */
	public String readText(Path path) {
		String result = read(path);
		return result != null ? result.replaceAll("\r\n", "\n") : null;
	}
	
	
	/**
	 * Read the contents of the given {@link File}, throwing a {@link ResourceError}
	 * if we fail.
	 */
	public String strictread(File f) {
		String content = read(f);
		if (content == null)
			throw new ResourceError("Failed to read file " + f, getLastException());
		return content;
	}

	/**
	 * Read the contents of the given {@link Path}, throwing a {@link ResourceError}
	 * if we fail.
	 */
	public String strictread(Path f) {
		String content = read(f);
		if (content == null)
			throw new ResourceError("Failed to read path " + f, getLastException());
		return content;
	}

	/**
	 * Read the contents of the given {@link File} as text (line endings are normalised to "\n" in the output).
	 *
	 * @param file				The file to read.
	 * @return					The text contents of the file, if possible.
	 * @throws ResourceError	If the file cannot be read.
	 */
	public String strictreadText(File file) {
		return rpLineEndingCRLF.matcher(strictread(file)).replaceAll("\n");
	}

	/**
	 * Read the contents of the given {@link Path} as text (line endings are normalised to "\n" in the output).
	 *
	 * @param path				The path to read.
	 * @return					The text contents of the path, if possible.
	 * @throws ResourceError	If the path cannot be read.
	 */
	public String strictreadText(Path path) {
		return rpLineEndingCRLF.matcher(strictread(path)).replaceAll("\n");
	}

	/**
	 * Get the entire content of an {@link InputStream}
	 * and interpret it as a {@link String} trying to detect its character set.
	 * Returns <code>null</code> on error, in which case you can check
	 * the getLastException() method for the exception that occurred.
	 * 
	 * @param stream the stream to read from
	 * @return The contents of the file, or <code>null</code> on error.
	 */
	public String readString(InputStream stream) {
		IntRef length = new IntRef(0);
		byte[] bytes = readBinary(stream, length);
		
		if (bytes == null) return null;
		
		try {
			IntRef start = new IntRef(0);
			String charset = determineCharset(bytes, length.get(), start);
			return new String(bytes, start.get(), length.get() - start.get(), charset);
		} catch (UnsupportedEncodingException e) {
			this.e = e;
			return null;
		}
	}

	/**
	 * Get the entire content of an {@link InputStream}
	 * and interpret it as a {@link String} trying to detect its character set.
	 * Throws a {@link ResourceError} on error.
	 *
	 * @param stream the stream to read from
	 * @return the contents of the input stream
	 */
	public String strictReadString(InputStream stream) {
		String content = readString(stream);
		if (content == null)
			throw new ResourceError("Could not read from stream", getLastException());
		return content;
	}

	/**
	 * Get the entire content of an {@link InputStream}, interpreting it
	 * as a sequence of bytes. This removes restrictions regarding invalid
	 * code points that would potentially prevent reading a file's contents
	 * as a String.
	 * 
	 * This method returns <code>null</code> on error, in which case you can
	 * check {@link #getLastException()} for the exception that occurred.
	 * 
	 * @param stream the stream to read from
	 * @return The binary contents of the file, or <code>null</code> on error.
	 */
	public byte[] readBinary(InputStream stream) {
		IntRef length = new IntRef(0);
		byte[] bytes = readBinary(stream, length);
		return bytes == null ? null : Arrays.copyOf(bytes, length.get());
	}

	/**
	 * Get the entire content of an {@link InputStream}, interpreting it
	 * as a sequence of bytes. This removes restrictions regarding invalid
	 * code points that would potentially prevent reading a file's contents
	 * as a String.
	 *
	 * @param stream the stream to read from
	 * @return The binary contents of the file -- always non-null.
	 * @throws ResourceError if an exception occurs during IO.
	 */
	public byte[] strictReadBinary(InputStream stream) {
		byte[] result = readBinary(stream);
		if (result == null)
			throw new ResourceError("Couldn't read from stream", e);
		return result;
	}
	
	/**
	 * Get the entire binary contents of a {@link File} as a sequence of bytes.
	 * 
	 * @param file the file to read
	 * @return the file's contents as a byte[] -- always non-null.
	 * @throws ResourceError if an exception occurs during IO.
	 */
	public byte[] strictReadBinary(File file) {
		FileInputStream stream = null;
		try {
			stream = new FileInputStream(file);
			byte[] result = readBinary(stream);
			if (result == null)
				throw new ResourceError("Couldn't read from file " + file + ".", e);
			return result;
		} catch (FileNotFoundException e) {
			throw new ResourceError("Couldn't read from file " + file + ".", e);
		} finally {
			FileUtil.close(stream);
		}
	}

	/**
	 * Get the entire binary contents of a {@link Path} as a sequence of bytes.
	 * 
	 * @param path the path to read
	 * @return the file's contents as a byte[] -- always non-null.
	 * @throws ResourceError if an exception occurs during IO.
	 */
	public byte[] strictReadBinary(Path path) {
		InputStream stream = null;
		try {
			stream = Files.newInputStream(path);
			byte[] result = readBinary(stream);
			if (result == null)
				throw new ResourceError("Couldn't read from path " + path + ".", e);
			return result;
		} catch (IOException e) {
			throw new ResourceError("Couldn't read from path " + path + ".", e);
		} finally {
			FileUtil.close(stream);
		}
	}

	/**
	 * Get the entire binary contents of a {@link Path} as a sequence of bytes.
	 * 
	 * @param path the path to read
	 * @return the file's contents as a byte[] -- always non-null.
	 */
	public byte[] readBinary(Path path) throws IOException {
		InputStream stream = null;
		try {
			stream = Files.newInputStream(path);
			byte[] result = readBinary(stream);
			if (result == null)
				throw new ResourceError("Couldn't read from path " + path + ".", e);
			return result;
		} finally {
			FileUtil.close(stream);
		}
	}
	
	private byte[] readBinary(InputStream stream, IntRef offsetHolder) {
		try {
			byte[] bytes = new byte[16384];
			int offset = 0;
			int readThisTime;
			do {
				readThisTime = stream.read(bytes, offset, bytes.length - offset);
				if (readThisTime > 0) {
					offset += readThisTime;
					if (offset == bytes.length)
						bytes = safeArrayDouble(bytes);
				}
			} while (readThisTime > 0);
			offsetHolder.set(offset);
			return bytes;
		} catch (IOException e) {
			this.e = e;
			return null;
		}
	}

	/**
	 * Safely attempt to double the length of an array.
	 * @param array The array which want to be doubled
	 * @return a new array that is longer than array 
	 */
	private byte[] safeArrayDouble(byte[] array) {
		if (array.length  >= ArrayUtil.MAX_ARRAY_LENGTH) {
			throw new ResourceError("Cannot stream into array as it exceed the maximum array size");
		}
		// Compute desired capacity
		long newCapacity = array.length * 2L;
		// Ensure it is at least as large as minCapacity
		if (newCapacity < 16)
			newCapacity = 16;
		// Ensure it is at most MAX_ARRAY_LENGTH
		if (newCapacity > ArrayUtil.MAX_ARRAY_LENGTH) {
			newCapacity = ArrayUtil.MAX_ARRAY_LENGTH;
		}
		return Arrays.copyOf(array, (int)newCapacity);
	}

	/**
	 * Try to determine the encoding of a byte[] using a byte-order mark (if present)
	 * Defaults to UTF-8 if none found.
	 */
	private String determineCharset(byte[] bom, int length, IntRef start) {
		start.set(0);
		String ret = defaultEncoding;
		if(length < 2)
			return ret;
		if (length >= 3 && byteToInt(bom[0]) == 0xEF && byteToInt(bom[1]) == 0xBB && byteToInt(bom[2]) == 0xBF) {
			ret = "UTF-8";
			start.set(3);
		} else if (byteToInt(bom[0]) == 0xFE && byteToInt(bom[1]) == 0xFF) {
			ret = "UTF-16BE";
			start.set(2);
		} else if (byteToInt(bom[0]) == 0xFF && byteToInt(bom[1]) == 0xFE) {
			ret = "UTF-16LE";
			start.set(2);
		}
		return ret;
	}
	
	private static int byteToInt(byte b) {
		return b & 0xFF;
	}

}
