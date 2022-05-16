package com.semmle.util.extraction;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.process.Env;
import com.semmle.util.trap.pathtransformers.PathTransformer;

/**
 * A file listing patterns of source files and which ODASA project
 * each should be populated to (if any).
 */
public class PopulationSpecFile {

	private final List<SpecFileEntry> specs = new ArrayList<SpecFileEntry>();

	public PopulationSpecFile(File specFile) {
		FileReader fileReader = null;
		BufferedReader reader = null;
		
		try {
			fileReader = new FileReader(specFile);
			reader = new BufferedReader(fileReader);
	
			File dbPath = null;
			File trapFolder = null;
			File sourceArchivePath = null;
			List<String> patterns = new ArrayList<String>();
			
			String line;
			while ((line = reader.readLine()) != null) {
				line = line.trim();
				if (line.length() == 0 || line.startsWith("@"))
					continue;
				if (line.startsWith("#")) {
					if (dbPath != null)
						specs.add(new SpecFileEntry(trapFolder, sourceArchivePath, patterns));
					dbPath = null;
					sourceArchivePath = null;
					patterns = new ArrayList<String>();
				} else if (line.startsWith("TRAP_FOLDER=")) {
					trapFolder = new File(line.substring("TRAP_FOLDER=".length()));
				} else if (line.startsWith("ODASA_DB=")) {
					dbPath = new File(line.substring("ODASA_DB=".length()));
				} else if (line.startsWith("SOURCE_ARCHIVE=")) {
					sourceArchivePath = new File(line.substring("SOURCE_ARCHIVE=".length()));
				} else if (line.startsWith("BUILD_ERROR_DIR=")) {
					// Accept and ignore for backwards compatibility
				} else if (line.startsWith("-")) {
					File path = new File(line.substring(1).trim());
					patterns.add("-" + normalisePathAndCase(path) + "/");
				} else {
					File path = new File(line);
					patterns.add(normalisePathAndCase(path) + "/");
				}
			}
			
			if (dbPath != null)
				specs.add(new SpecFileEntry(trapFolder, sourceArchivePath, patterns));
		} catch (IOException e) {
			throw new ResourceError("I/O error while reading specification file at " + specFile, e);
		} finally {
			FileUtil.close(reader);
			FileUtil.close(fileReader);
		}
	}
	
	/**
	 * Get the entry for a file, or <code>null</code> if there is no matching entry
	 */
	public SpecFileEntry getEntryFor(File f) {
		String path = normalisePathAndCase(f);

		for (SpecFileEntry entry : specs)
			if (entry.matches(path))
				return entry;
		
		return null;
	}

	/**
	 * Normalises the path like {@link PathTransformer#fileAsDatabaseString(File)}, and, in
	 * addition, converts it to all-lowercase if we're on a case-insensitive
	 * filesystem.
	 * @param file the file to normalise
	 * @return a normalised path that is lowercased if the file system is case-insensitive.
	 */
	private static String normalisePathAndCase(File file) {
		String path = PathTransformer.std().fileAsDatabaseString(file);
		if (!Env.getOS().isFileSystemCaseSensitive())
			path = path.toLowerCase();
		return path;
	}
}
