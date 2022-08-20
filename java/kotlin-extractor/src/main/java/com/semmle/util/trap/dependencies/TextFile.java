package com.semmle.util.trap.dependencies;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.semmle.util.exception.ResourceError;
import com.semmle.util.io.StreamUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.trap.CompressedFileInputStream;

public abstract class TextFile {
	static final String TRAPS = "TRAPS";
	private static final Pattern HEADER = Pattern.compile("([^\r\n]+?) (\\d\\.\\d)");

	protected String version;
	protected final Set<String> traps = new LinkedHashSet<String>();
	
	protected abstract Set<String> getSet(Path path, String label);
	protected abstract void parseError(Path path);
	
	public TextFile(String version) {
		this.version = version;
	}
	
	/**
	 * Load the current text file, checking that it matches the expected header.
	 *
	 * <p>
	 * This method is somewhat performance-sensitive, as at least our C++ extractors
	 * can generate very large input files. The format is therefore parsed by hand.
	 * </p>
	 *
	 * <p>
	 * The accepted format consists of:
	 * <ul>
	 * <li>Zero or more EOL comments, marked with {@code //}.
	 * <li>Precisely one header line, of the form {@code $HEADER $VERSION}; this is
	 * checked against {@code expected_header}.
	 * <li>Zero or more "file lists", each beginning with the name of a set (see
	 * {@link #getSet(File, String)}) on a line by itself, followed by file paths,
	 * one per line.
	 * </ul>
	 * 
	 * <p>
	 * Empty lines are permitted throughout.
	 * </p>
	 */
	protected void load(String expected_header, Path path) {
		try (InputStream is = CompressedFileInputStream.fromFile(path);
				BufferedReader lines = StreamUtil.newUTF8BufferedReader(is)) {
			boolean commentsPermitted = true;
			Set<String> currentSet = null;
			for (String line = lines.readLine(); line != null; line = lines.readLine()) {
				// Skip empty lines.
				if (line.isEmpty())
					continue;
				// If comments are still permitted, skip comment lines.
				if (commentsPermitted && line.startsWith("//"))
					continue;
				// If comments are still permitted, the first non-comment line is the header.
				// In addition, we allow no further comments.
				if (commentsPermitted) {
					Matcher matcher = HEADER.matcher(line);
					if (!matcher.matches() || !matcher.group(1).equals(expected_header))
						parseError(path);
					commentsPermitted = false;
					version = matcher.group(2);
					continue;
				}
				// We have a non-blank line; this either names the new set, or is a line that
				// should be put into the current set.
				Set<String> newSet = getSet(path, line);
				if (newSet != null) {
					currentSet = newSet;
				} else {
					if (currentSet == null)
						parseError(path);
					else
						currentSet.add(line);
				}
			}
		} catch (IOException e) {
			throw new ResourceError("Couldn't read " + path, e);
		}
	}
	
	/**
	 * @return the format version of the loaded file
	 */
	public String version() {
		return version;
	}
	
	/**
	 * Save this object to a file (or throw a ResourceError on failure)
	 * 
	 * @param file the file in which to save this object
	 */
	public void save(Path file) {
		new WholeIO().strictwrite(file, toString());
	}
	
	protected void appendHeaderString(StringBuilder sb, String header, String version) {
		sb.append(header).append(' ').append(version).append('\n');
	}

	protected void appendSet(StringBuilder sb, String title, Set<String> set) {
		sb.append('\n').append(title).append('\n');
		for (String s : set)
			sb.append(s).append('\n');
	}
	
	protected void appendSingleton(StringBuilder sb, String title, String s) {
		sb.append('\n').append(title).append('\n');
		sb.append(s).append('\n');
	}
}
