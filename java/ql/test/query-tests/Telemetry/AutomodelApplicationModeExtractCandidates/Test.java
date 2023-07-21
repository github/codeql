package com.github.codeql.test;

import java.io.InputStream;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;

class AutomodelApplicationModeExtractCandidates {
	public static void main(String[] args) throws Exception {
		AtomicReference<String> reference = new AtomicReference<>(); // uninteresting (parameterless constructor)
		reference.set(args[0]); // arg[0] is not a candidate (modeled as value flow step)
		// ^^^^^^ Argument[this] is a candidate (should no longer be, once a recent PR
		// is merged)
	}

	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // Argument[this] is a candidate
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy(
			source, // no candidate (modeled)
			target, // no candidate (modeled)
			option // no candidate (not modeled, but source and target are modeled)
		);
	}

	public static InputStream getInputStream(Path openPath) throws Exception {
		return Files.newInputStream(
			openPath // no candidate (known sink)
		);
	}
}
