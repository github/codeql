package com.semmle.util.trap;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import com.semmle.util.zip.MultiMemberGZIPInputStream;

public class CompressedFileInputStream {
	/**
	 * Create an input stream for reading the uncompressed data from a (possibly) compressed file, with
	 * the decompression method chosen based on the file extension.
	 *
	 * @param f The compressed file to read
	 * @return An input stream from which you can read the file's uncompressed data.
	 * @throws IOException From the underlying decompression input stream.
	 */
	public static InputStream fromFile(Path f) throws IOException {
		InputStream fileInputStream = Files.newInputStream(f);
		if (f.getFileName().toString().endsWith(".gz")) {
			return new MultiMemberGZIPInputStream(fileInputStream, 8192);
		//} else if (f.getFileName().toString().endsWith(".br")) {
		//	return new BrotliInputStream(fileInputStream);
		} else {
			return fileInputStream;
		}
	}
}
