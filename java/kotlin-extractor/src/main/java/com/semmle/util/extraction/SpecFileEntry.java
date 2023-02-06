package com.semmle.util.extraction;

import java.io.File;
import java.util.List;

import com.semmle.util.data.StringUtil;

public class SpecFileEntry {
	private final File trapFolder;
	private final File sourceArchivePath;
	private final List<String> patterns;
	
	public SpecFileEntry(File trapFolder, File sourceArchivePath, List<String> patterns) {
		this.trapFolder = trapFolder;
		this.sourceArchivePath = sourceArchivePath;
		this.patterns = patterns;
	}
	
	public boolean matches(String path) {
		boolean matches = false;
		for (String pattern : patterns) {
			if (pattern.startsWith("-")) {
				if (path.startsWith(pattern.substring(1)))
					matches = false;
			} else {
				if (path.startsWith(pattern))
					matches = true;
			}
		}
		return matches;
	}
	
	public File getTrapFolder() {
		return trapFolder;
	}
	
	public File getSourceArchivePath() {
		return sourceArchivePath;
	}
	
	@Override
	public String toString() {
		return
			"TRAP_FOLDER=" + trapFolder + "\n" + 
			"SOURCE_ARCHIVE=" + sourceArchivePath + "\n" + 
			StringUtil.glue("\n", patterns);
	}
}