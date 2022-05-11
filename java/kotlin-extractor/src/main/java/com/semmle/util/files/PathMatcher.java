package com.semmle.util.files;

import java.util.regex.Pattern;

import com.semmle.util.data.StringUtil;

/**
 * Utility class to match a string to a pattern, which can either be
 * an ant-like include/exclude pattern (with wildcards), or a rsync-like
 * pattern.
 * <p>
 * In ant-like mode:
 * <ul>
 *   <li>'**' matches zero or more characters (most notably including '/'). 
 *   <li>'*' matches zero or more characters except for '/'. 
 *   <li>'?' matches any character (other than '/').
 * </ul>
 * <p>
 * In rsync-like mode:
 * <ul>
 *   <li>A pattern is matched only at the root if it starts with '/', and otherwise
 *       it is matched against each level of the directory tree.
 *   <li>'**', '*' and '?' have the same meaning as for ant.
 *   <li>Other rsync features (like [:..:] groups and backslash-escapes) are not supported.
 * </ul>
 */
public class PathMatcher {
	
	public enum Mode {
		Ant, Rsync;
	}
	
	private final Mode mode;
	private final Pattern pattern;
	private final String originalPattern;
	
	/**
	 * Create a {@link PathMatcher}.
	 * 
	 * @param pattern An ant-like pattern
	 */
	public PathMatcher(String pattern) {
		this(Mode.Ant, pattern);
	}
	
	/** Create a {@link PathMatcher}.
	 *
	 * @param mode The {@link Mode} to use
	 * @param pattern A pattern, interpreted as ant-like or rsync-like depending on
	 *     the value of {@code mode}
	 */
	public PathMatcher(Mode mode, String pattern) {
		this.mode = mode;
		this.originalPattern = pattern;
		StringBuilder b = new StringBuilder();
		toRegex(b, pattern);
		this.pattern = Pattern.compile(b.toString());
	}

	/** Create a {@link PathMatcher}.
	 * 
	 * @param patterns Several ant-like patterns
	 */
	public PathMatcher(Iterable<String> patterns) {
		this(Mode.Ant, patterns);
	}
	
	/** Create a {@link PathMatcher}.
	 * 
	 * @param mode The {@link Mode} to use.
	 * @param patterns Several patterns, interpreted as ant-like or rsync-like depending
	 *     on the value of {@code mode}.
	 */
	public PathMatcher(Mode mode, Iterable<String> patterns) {
		this.mode = mode;
		this.originalPattern = patterns.toString();
		StringBuilder b = new StringBuilder();
		for (String pattern : patterns) {
			if (b.length() > 0)
				b.append('|');
			toRegex(b, pattern);
		}
		this.pattern = Pattern.compile(b.toString());
	}

	private void toRegex(StringBuilder b, String pattern) {
		if (pattern.length() == 0) return;
		//normalize pattern path separators
		pattern = pattern.replace('\\', '/');
		//replace double slashes
		pattern = pattern.replaceAll("//+", "/");
		// escape
		pattern = StringUtil.escapeStringLiteralForRegexp(pattern, "*?");

		// for ant, ending with '/' is shorthand for "/**"
		if (mode == Mode.Ant && pattern.endsWith("/")) pattern = pattern + "**";

		// replace "**/" with (^|.*/)"
		// replace "**" with ".*"
		// replace "*" with "[^/]*
		// replace "?" with "[^/]"
		int i = 0;
		
		// In rsync-mode, a leading slash is an 'anchor' -- the pattern is only matched
		// when rooted at the start of the path. This is the default behaviour for ant-like
		// patterns.
		if (mode == Mode.Rsync) {
			if (pattern.charAt(0) == '/') {
				// The slash is just anchoring, and may actually be missing
				// in the case of a relative path.
				b.append("/?");
				i++;
			} else {
				// Non-anchored rsync pattern: the pattern can match at any level in the tree.
				b.append("(.*/)?");
			}
		}

		while (i < pattern.length()) {
			char c = pattern.charAt(i);
			if (c == '*' && i < pattern.length() - 2 && pattern.charAt(i+1) == '*' && pattern.charAt(i+2) == '/') {
				b.append("(?:^|.*/)");
				i += 3;
			}
			else if (c == '*' && i < pattern.length() - 1 && pattern.charAt(i+1) == '*') {
				b.append(".*");
				i += 2;
			}
			else if(c == '*') {
				b.append("[^/]*");
				i++;
			}
			else if(c == '?') {
				b.append("[^/]");
				i++;
			}
			else {
				b.append(c);
				i++;
			}
		}
	}
	
	/**
	 * Match the specified path against a shell pattern. The path is normalised by replacing '\' with '/'.
	 * @param path The path to match.
	 */
	public boolean matches(String path) {
		// normalise path
		path = path.replace('\\', '/');
		if(path.endsWith("/"))
			path = path.substring(0, path.length()-1);
		return pattern.matcher(path).matches();
	}
	
	@Override
	public String toString() {
		return "Matches " + originalPattern + " [" + pattern + "]";
	}
}
