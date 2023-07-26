package com.github.codeql.test;

import java.io.InputStream;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;
import java.io.File;


class Test {
	public static void main(String[] args) throws Exception {
		AtomicReference<String> reference = new AtomicReference<>(); // uninteresting (parameterless constructor)
		reference.set(args[0]); // arg[0] is not a candidate (modeled as value flow step)
		// ^^^^^^ Argument[this] is a candidate
	}

	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // Argument[this] is a candidate
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy(
			source, // positive example (known sink)
			target, // positive example (known sink)
			option // no candidate (not modeled, but source and target are modeled)
		);
	}

	public static InputStream getInputStream(Path openPath) throws Exception {
		return Files.newInputStream(
			openPath // positive example (known sink)
		);
	}

	public static InputStream getInputStream(String openPath) throws Exception {
		return Test.getInputStream(
			Paths.get(openPath) // no candidate (argument to local call)
		);
	}

	public static int compareFiles(File f1, File f2) {
		return f1.compareTo(
			f2 // negative example (modeled as not a sink)
		);
	}
}

