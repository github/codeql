package com.semmle.util.trap.pathtransformers;

import java.io.File;

import com.semmle.util.files.FileUtil;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.Var;

public abstract class PathTransformer {
	public abstract String transform(String input);

	/**
	 * Convert a file to its path in the (code) database. Turns file paths into
	 * canonical, absolute, strings and normalises away Unix/Windows differences.
	 */
	public String fileAsDatabaseString(File file) {
		String path = file.getPath();
		// For /!unknown-binary-location/... and /modules/...
		// paths, on Windows the standard code wants to
		// normalise them to e.g. C:/!unknown-binary-location/...
		// which is particularly annoying for cross-platform test
		// output. We therefore handle them specially here.
		if (path.matches("^[/\\\\](!unknown-binary-location|modules)[/\\\\].*")) {
			return path.replace('\\', '/');
		}
		if (Boolean.valueOf(Env.systemEnv().get(Var.SEMMLE_PRESERVE_SYMLINKS)))
			path = FileUtil.simplifyPath(file);
		else
			path = FileUtil.tryMakeCanonical(file).getPath();
		return transform(FileUtil.normalisePath(path));
	}

	/**
	 * Utility method for extractors: Canonicalise the given path as required
	 * for the current extraction. Unlike {@link FileUtil#tryMakeCanonical(File)},
	 * this method is consistent with {@link #fileAsDatabaseString(File)}.
	 */
	public File canonicalFile(String path) {
		return new File(fileAsDatabaseString(new File(path)));
	}

	private static final PathTransformer DEFAULT_TRANSFORMER;
	static {
		String layout = Env.systemEnv().get(Var.CODEQL_PATH_TRANSFORMER);
		if (layout == null) {
			layout = Env.systemEnv().get(Var.SEMMLE_PATH_TRANSFORMER);
		}
		if (layout == null)
			DEFAULT_TRANSFORMER = new NoopTransformer();
		else
			DEFAULT_TRANSFORMER = new ProjectLayoutTransformer(new File(layout));
	}

	public static PathTransformer std() {
		return DEFAULT_TRANSFORMER;
	}
}
