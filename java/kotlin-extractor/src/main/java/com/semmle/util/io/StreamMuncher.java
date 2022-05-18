package com.semmle.util.io;

import com.semmle.util.exception.Exceptions;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.BufferedLineReader;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;

/**
 * A thread that forwards data from one stream to another. It waits for
 * entire lines of input from one stream before writing data to the next
 * stream, and it flushes as it goes.
 */
public class StreamMuncher extends Thread {
	private final InputStream is;
	private PrintStream output;
	private BufferedLineReader reader;

	public StreamMuncher(InputStream is, OutputStream output) {
		this.is = is;
		if (output != null)
			this.output = new PrintStream(output);
	}

	@Override
	public void run() {
		InputStreamReader isr = null;
		try {
			isr = new InputStreamReader(is);
			reader = new BufferedLineReader(isr);
			String line;
			while ((line = reader.readLineAndTerminator()) != null) {
				if (output != null) {
					output.print(line);
					output.flush();
				}
			}
		} catch (IOException e) {
			Exceptions.ignore(e, "When the process exits, a harmless IOException will occur here");
		} finally {
			FileUtil.close(reader);
			FileUtil.close(isr);
		}
	}
}
