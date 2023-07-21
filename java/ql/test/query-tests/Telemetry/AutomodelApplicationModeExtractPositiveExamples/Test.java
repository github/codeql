package com.github.codeql.test;

import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;

class AutomodelApplicationModeExtractPositiveExamples {
	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // not an example
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy(
			source, // positive example
			target, // positive example
			option // no example
		);
	}
}
