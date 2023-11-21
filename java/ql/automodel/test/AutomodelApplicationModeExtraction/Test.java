package com.github.codeql.test;

import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;
import java.io.File;
import java.nio.file.FileVisitOption;
import java.net.URLConnection;
import java.util.concurrent.FutureTask;

class Test {
	public static void main(String[] args) throws Exception {
		AtomicReference<String> reference = new AtomicReference<>(); // uninteresting (parameterless constructor)
		reference.set(args[0]); // arg[0] is not a candidate (modeled as value flow step)
		// ^^^^^^ Argument[this] is a candidate
	}

	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // Argument[this] is a sink candidate; the call is a source candidate
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy( // the call is a source candidate
			source, // positive example (known sink)
			target, // positive example (known sink)
			option // no candidate (not modeled, but source and target are modeled)
		);
	}

	public static InputStream getInputStream(Path openPath) throws Exception {
		return Files.newInputStream( // the call is a source candidate
			openPath // positive example (known sink), candidate ("only" ai-modeled, and useful as a candidate in regression testing)
		);
	}

	public static InputStream getInputStream(String openPath) throws Exception {
		return Test.getInputStream( // the call is not a source candidate (argument to local call)
			Paths.get(openPath) // no sink candidate (argument to local call); the call is a source candidate
		);
	}

	public static int compareFiles(File f1, File f2) {
		return f1.compareTo( // compareTo call is a known sanitizer
			f2 // negative sink example (modeled as not a sink)
		); // the call is a negative source candidate (sanitizer)
	}

	public static void FilesWalkExample(Path p, FileVisitOption o) throws Exception {
		Files.walk( // the call is a source candidate
			p, // negative example (modeled as a taint step)
			o, // the implicit varargs array is a candidate
			o // not a candidate (only the first arg corresponding to a varargs array
			  // is extracted)
		);
	}

	public static void WebSocketExample(URLConnection c) throws Exception {
		c.getInputStream(); // the call is a source example, c is a sink candidate
	}
}

class OverrideTest extends Exception {
	public void printStackTrace(PrintWriter writer) { // writer is a source candidate because it overrides an existing method
		return;
	}

}

class TaskUtils {
	public FutureTask getTask() {
		FutureTask ft = new FutureTask(() -> {
			//           ^-- no sink candidate for the `this` qualifier of a constructor
			return 42;
		});
		return ft;
	}
}
