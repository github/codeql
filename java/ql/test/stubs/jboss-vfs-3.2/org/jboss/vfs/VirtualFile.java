package org.jboss.vfs;

import java.io.File;
import java.io.IOException;

public class VirtualFile {
	VirtualFile(String name, VirtualFile parent) {
	}

	public String getName() {
		return null;
	}

	public String getPathName() {
		return null;
	}

	String getPathName(boolean url) {
		return null;
	}

	public File getPhysicalFile() throws IOException {
		return null;
	}

	public VirtualFile getChild(String path) {
		return null;
	}
}
