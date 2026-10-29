package com.semmle.util.io;

import com.semmle.util.exception.Exceptions;
import com.semmle.util.files.FileUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * A thread that copies data from an input stream to an output stream. When
 * the input stream runs out, it closes both the input and output streams.
 */
public class RawStreamMuncher extends Thread {
	private final InputStream in;
	private final OutputStream out;

	public RawStreamMuncher(InputStream in, OutputStream out) {
		this.in = in;
		this.out = out;
	}

	@Override
	public void run() {
		try {
			StreamUtil.copy(in, out);
		} catch (IOException e) {
			Exceptions.ignore(e, "When the process exits, a harmless IOException will occur here");
		} finally {
			FileUtil.close(in);
			FileUtil.close(out);
		}
	}
}
