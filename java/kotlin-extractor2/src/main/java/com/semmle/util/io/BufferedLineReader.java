package com.semmle.util.io;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.IOException;
import java.io.Reader;

import com.semmle.util.files.FileUtil;

/**
 * A custom buffered reader akin to {@link BufferedReader}, except that it preserves
 * line terminators (and so its {@code readLine()} method is called
 * {@link #readLineAndTerminator()}). The other {@link Reader} methods should not
 * be called, and will throw.
 */
public class BufferedLineReader implements Closeable {
	private final char[] buffer = new char[8192];
	private  int nextChar = 0, nChars = 0;
	private final Reader in;
	
	public BufferedLineReader(Reader in) {
		this.in = in;
	}

	/**
	 * Read the string up to and including the next CRLF or LF terminator. This method
	 * may return a non-terminated string at EOF, or if a line is too long to fit in the
	 * internal buffer. Calls will block until enough data has been read to fill the
	 * buffer or find a line terminator.
	 * @return The next line (or buffer-full) of text.
	 * @throws IOException if the underlying stream throws.
	 */
	public String readLineAndTerminator() throws IOException {
		int terminator = findNextLineTerminator();
		if (terminator == -1)
			return null;
		String result = new String(buffer, nextChar, terminator - nextChar + 1);
		nextChar = terminator + 1;
		return result;
	}
	
	/**
	 * Get the index of the last character that should be included in the next line.
	 * Usually, this is the LF in a LF or CRLF line terminator, but it might be the
	 * end of the buffer (if it is full, and no newlines are present), or it may be
	 * -1 (but only if EOF has been reached, and the buffer is currently empty).
	 * The first character of the line is pointed to by {@link #nextChar}, which
	 * may be modified by this method if the buffer is refilled.
	 */
	private int findNextLineTerminator() throws IOException {
		int alreadyChecked = 0;
		do {
			for (int i = nextChar + alreadyChecked; i < nChars; i++) {
				if (buffer[i] == '\r' && i+1 < nChars && buffer[i+1] == '\n')
					return i+1; // CRLF
				else if (buffer[i] == '\n')
					return i; // LF
			}
			
			// We didn't find a full newline in the existing buffer: Try to fill.
			alreadyChecked = nChars - nextChar;
			int newlyRead = fill();
			if (newlyRead <= 0)
				return nChars - 1;
		} while (true);
	}
	
	/**
	 * Block until at least one character from the underlying stream is read,
	 * or EOF is reached.
	 */
	private int fill() throws IOException {
		if (nextChar >= nChars) {
			// No unread characters.
			nextChar = 0;
			nChars = 0;
		} else if (nextChar > 0) {
			// Some unread characters.
			System.arraycopy(buffer, nextChar, buffer, 0, nChars - nextChar);
			nChars = nChars - nextChar;
			nextChar = 0;
		}
		
		// Is the buffer full?
		if (nChars == buffer.length)
			return 0;
		
		int read;
		do {
			read = in.read(buffer, nChars, buffer.length - nChars);
		} while (read == 0);
		
		if (read > 0) {
			nChars += read;
		}
		return read;
	}

	@Override
	public void close() {
		FileUtil.close(in);
	}
}
