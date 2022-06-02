package io.undertow.server.handlers.resource;

import java.io.File;

public class FileResourceManager {
	public FileResourceManager(final File base) {
	}

	public FileResourceManager(final File base, long transferMinSize) {
	}

	public FileResourceManager(final File base, long transferMinSize, boolean caseSensitive) {
	}

	public FileResourceManager(final File base, long transferMinSize, boolean followLinks, final String... safePaths) {
	}

	protected FileResourceManager(long transferMinSize, boolean caseSensitive, boolean followLinks, final String... safePaths) {
	}

	public FileResourceManager(final File base, long transferMinSize, boolean caseSensitive, boolean followLinks, final String... safePaths) {
	}

	public File getBase() {
		return null;
	}

	public Resource getResource(final String p) {
		return null;
	}
}
