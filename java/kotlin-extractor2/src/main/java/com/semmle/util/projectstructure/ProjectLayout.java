package com.semmle.util.projectstructure;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.UserError;
import com.semmle.util.io.WholeIO;

/**
 * A project-layout file optionally begins with an '@'
 * followed by the name the project should be renamed to.
 * Optionally, it can then be followed by a list of
 * include/exclude patterns (see below) which are kept
 * as untransformed paths. This is followed by one or
 * more clauses. Each clause has the following form:
 *
 * #virtual-path
 * path/to/include
 * another/path/to/include
 * -/path/to/include/except/this
 *
 * i.e. one or more paths (to include) and zero or more paths
 * prefixed by minus-signs (to exclude).
 */
public class ProjectLayout
{
	public static final char PROJECT_NAME_PREFIX = '@';

	private String project;

	/**
	 * Map from virtual path prefixes (following the '#' in the project-layout)
	 * to the sequence of patterns that fall into that section. Declared as a
	 * {@link LinkedHashMap} since iteration order matters -- we process blocks in
	 * the same order as they occur in the project-layout.
	 */
	private final LinkedHashMap<String, Section> sections = new LinkedHashMap<String, Section>();

	/**
	 * A file name, or similar string, to use in error messages so that the
	 * user knows what to fix.
	 */
	private String source;

	/**
	 * Load a project-layout file.
	 *
	 * @param file the project-layout to load
	 */
	public ProjectLayout(File file) {
		this(StringUtil.lines(new WholeIO().strictread(file)), file.toString());
	}

	/**
	 * Construct a project-layout object from an array of strings, each
	 * corresponding to one line of the project-layout. This constructor
	 * is for testing. For other uses see {@link ProjectLayout#ProjectLayout(File)}.
	 *
	 * @param lines the lines of the project-layout
	 */
	public ProjectLayout(String... lines) {
		this(lines, null);
	}

	private ProjectLayout(String[] lines, String source) {
		this.source = source;
		String virtual = "";
		Section section = new Section("");
		sections.put("", section);
		int num = 0;
		for (String line : lines) {
			num++;
			line = line.trim();
			if (line.isEmpty())
				continue;
			switch (line.charAt(0)) {
			case PROJECT_NAME_PREFIX:
				if (project != null)
					throw error("Only one project name is allowed", source, num);
				project = tail(line);
				break;
			case '#':
				virtual = tail(line);
				if (sections.containsKey(virtual))
					throw error("Duplicate virtual path prefix " + virtual, source, num);
				section = new Section(virtual);
				sections.put(virtual, section);
				break;
			case '-':
				section.add(new Rewrite(tail(line), source, num));
				break;
			default:
				section.add(new Rewrite(line, virtual, source, num));
			}
		}
	}

	private static String tail(String line) {
		return line.substring(1).trim();
	}

	/**
	 * Get the project name, if specified by the project-layout. This
	 * method should only be called if it is guaranteed that the
	 * project-layout will contain a project name, and it throws
	 * a {@link UserError} if it doesn't.
	 * @return the project name -- guaranteed not <code>null</code>.
	 * @throws UserError if the project-layout file did not specify a
	 *     project name.
	 */
	public String projectName() {
		if (project == null)
			throw error("No project name is defined", source);
		return project;
	}

	/**
	 * Get the project name, if specified by the project-layout file.
	 * If the file contains no renaming specification, return the
	 * given default value.
	 * @param defaultName The name to use if the project-layout doesn't
	 *    specify a target project name.
	 * @return the specified name or default value.
	 */
	public String projectName(String defaultName) {
		return project == null ? defaultName : project;
	}

	/**
	 * @return the section headings (aka virtual paths)
	 */
	public List<String> sections() {
		List<String> result = new ArrayList<String>();
		result.addAll(sections.keySet());
		return result;
	}

	/**
	 * Determine whether or not a particular section in this
	 * project-layout is empty (has no include/exclude patterns).
	 *
	 * @param section the name of the section
	 * @return <code>true</code> if the section is empty
	 */
	public boolean sectionIsEmpty(String section) {
		if (!sections.containsKey(section))
			throw new CatastrophicError("Section does not exist: " + section);
		return sections.get(section).isEmpty();
	}

	/**
	 * Reaname a section in this project-layout.
	 *
	 * @param oldName the old name of the section
	 * @param newName the new name
	 */
	public void renameSection(String oldName, String newName) {
		if (!sections.containsKey(oldName))
			throw new CatastrophicError("Section does not exist: " + oldName);
		Section section = sections.remove(oldName);
		section.rename(newName);
		sections.put(newName, section);
	}

	/**
	 * Return a project-layout file for just one of the sections in this
	 * project-layout. This is done by copying all the rules from the
	 * section, and changing the section heading (beginning with '#')
	 * to a project name (beginning with '@').
	 *
	 * @param sectionName the section to create a project-layout from
	 * @return the text of the newly created project-layout
	 */
	public String subLayout(String sectionName) {
		Section section = sections.get(sectionName);
		if (section == null)
			throw new CatastrophicError("Section does not exist: " + section);
		return section.toLayout();
	}

	/**
	 * Maps a path to its corresponding artificial path according to the
	 * rules in this project-layout. If the path is excluded (either
	 * explicitly, or because it is not mentioned in the project-layout)
	 * then <code>null</code> is returned.
	 * <p>
	 * Paths should start with a leading forward-slash
	 *
	 * @param path the path to map
	 * @return the artificial path, or <code>null</code> if the path is excluded
	 */
	public String artificialPath(String path) {
		// If there is no leading slash, the path does not conform to the expected
		// format and there is no match. (An exception is made for a completely
		// empty string, which will get the sole prefix '/' and be mapped as usual).
		if (path.length() > 0 && path.charAt(0) != '/')
			return null;
		List<String> prefixes = Section.prefixes(path);
		for (Section section : sections.values()) {
			Rewrite rewrite = section.match(prefixes);
			String rewritten = null;
			if (rewrite != null)
				rewritten = rewrite.rewrite(path);
			if (rewritten != null)
				return rewritten;
		}
		return null;
	}

	/**
	 * Checks whether a path should be included in the project specified by
	 * this file. A file is included if it is mapped to some location.
	 * <p>
	 * Paths should start with a leading forward-slash
	 *
	 * @param path the path to check
	 * @return <code>true</code> if the path should be included
	 */
	public boolean includeFile(String path) {
		return artificialPath(path) != null;
	}

	public void writeTo(Writer writer) throws IOException {
		if (project != null) {
			writer.write(PROJECT_NAME_PREFIX);
			writer.write(project);
			writer.write("\n");
		}
		for (Section section : sections.values()) {
			if (!section.virtual.isEmpty()) {
				writer.write("#");
				writer.write(section.virtual);
				writer.write("\n");
			}
			section.outputRules(writer);
		}
	}

	public void addPattern(String section, String pattern) {
		if (pattern == null || pattern.isEmpty()) {
			throw new IllegalArgumentException("ProjectLayout.addPattern: pattern must be a non-empty string");
		}
		boolean exclude = pattern.charAt(0) == '-';
		Rewrite rewrite = exclude ?
			new Rewrite(pattern.substring(1), null, 0) :
			new Rewrite(pattern, section, null, 0);
		Section s = sections.get(section);
		if (s == null) {
			s = new Section(section);
			sections.put(section, s);
		}
		s.add(rewrite);
	}

	private static UserError error(String message, String source) {
		return error(message, source, 0);
	}

	private static UserError error(String message, String source, int line) {
		if (source == null)
			return new UserError(message);
		StringBuilder sb = new StringBuilder(message);
		sb.append(" (");
		if (line > 0)
			sb.append("line ").append(line).append(" of ");
		sb.append(source).append(")");
		return new UserError(sb.toString());
	}

	/**
	 * Each section corresponds to a block beginning with  '#some/path'. There
	 * is also an initial section for any include/exclude patterns before the
	 * first '#'.
	 */
	private static class Section {
		private String virtual;
		private final Map<String, Rewrite> simpleRewrites;
		private final List<Rewrite> complexRewrites;

		public Section(String virtual) {
			this.virtual = virtual;
			simpleRewrites = new LinkedHashMap<String, Rewrite>();
			complexRewrites = new ArrayList<Rewrite>();
		}

		public String toLayout() {
			StringWriter result = new StringWriter();
			result.append('@').append(virtual).append('\n');
			try {
				outputRules(result);
			} catch (IOException e) {
				throw new CatastrophicError("StringWriter.append threw an IOException", e);
			}
			return result.toString();
		}

		private void outputRules(Writer writer) throws IOException {
			List<Rewrite> all = new ArrayList<Rewrite>();
			all.addAll(simpleRewrites.values());
			all.addAll(complexRewrites);
			Collections.sort(all, Rewrite.COMPARATOR);
			for (Rewrite rewrite : all)
				writer.append(rewrite.toString()).append('\n');
		}

		public void rename(String newName) {
			virtual = newName;
			for (Rewrite rewrite : simpleRewrites.values())
				rewrite.virtual = newName;
			for (Rewrite rewrite : complexRewrites)
				rewrite.virtual = newName;
		}

		public void add(Rewrite rewrite) {
			int index = simpleRewrites.size() + complexRewrites.size();
			rewrite.setIndex(index);
			if (rewrite.isSimple())
				simpleRewrites.put(rewrite.simplePrefix(), rewrite);
			else
				complexRewrites.add(rewrite);
		}

		public boolean isEmpty() {
			return simpleRewrites.isEmpty() && complexRewrites.isEmpty();
		}

		private static List<String> prefixes(String path) {
			List<String> result = new ArrayList<String>();
			result.add(path);
			int i = path.length();
			while (i > 1) {
				i = path.lastIndexOf('/', i - 1);
				result.add(path.substring(0, i));
			}
			result.add("/");
			return result;
		}

		public Rewrite match(List<String> prefixes) {
			Rewrite best = null;
			for (String prefix : prefixes) {
				Rewrite match = simpleRewrites.get(prefix);
				if (match != null)
					if (best == null || best.index < match.index)
						best = match;
			}
			// Last matching rewrite 'wins'
			for (int i = complexRewrites.size() - 1; i >= 0; i--) {
				Rewrite rewrite = complexRewrites.get(i);
				if (rewrite.matches(prefixes.get(0))) {
					if (best == null || best.index < rewrite.index)
						best = rewrite;
					// no point continuing
					break;
				}
			}
			return best;
		}
	}

	/**
	 * Each Rewrite corresponds to a single include or exclude line in the project-layout.
	 * For example, for following clause there would be three Rewrite objects:
	 *
	 * #Source
	 * /src
	 * /lib
	 * -/src/tests
	 *
	 * For includes use the two-argument constructor; for excludes the one-argument constructor.
	 */
	private static class Rewrite {

		private static final Comparator<Rewrite> COMPARATOR = new Comparator<Rewrite>() {

			@Override
			public int compare(Rewrite t, Rewrite o) {
				if (t.index < o.index)
					return -1;
				if (t.index == o.index)
					return 0;
				return 1;
			}
		};

		private int index;
		private final String original;
		private final Pattern pattern;
		private String virtual;
		private final String simple;

		/**
		 * The intention is to allow the ** wildcard when followed by a slash only. The
		 * following should be invalid:
		 * - a / *** / b (too many stars)
		 * - a / ** (** at the end should be omitted)
		 * - a / **b (illegal)
		 * - a / b** (illegal)
		 * - ** (the same as a singleton '/')
		 * This regex matches ** when followed by a non-/ character, or the end of string.
		 */
		private static final Pattern verifyStars = Pattern.compile(".*(?:\\*\\*[^/].*|\\*\\*$|[^/]\\*\\*.*)");

		public Rewrite(String exclude, String source, int line) {
			original = '-' + exclude;
			if (!exclude.startsWith("/"))
				exclude = '/' + exclude;
			if (exclude.indexOf("//") != -1)
				throw error("Illegal '//' in exclude path", source, line);
			if (verifyStars.matcher(exclude).matches())
				throw error("Illegal use of '**' in exclude path", source, line);
			if (exclude.endsWith("/"))
				exclude = exclude.substring(0, exclude.length() - 1);
			pattern = compilePrefix(exclude);
			exclude = exclude.replace("//", "/");
			if (exclude.length() > 1 && exclude.endsWith("/"))
				exclude = exclude.substring(0, exclude.length() - 1);
			simple = exclude.contains("*") ? null : exclude;
		}

		public void setIndex(int index) {
			this.index = index;
		}

		public Rewrite(String include, String virtual, String source, int line) {
			original = include;
			if (!include.startsWith("/"))
				include = '/' + include;
			int doubleslash = include.indexOf("//");
			if (doubleslash != include.lastIndexOf("//"))
				throw error("More than one '//' in include path", source, line);
			if (verifyStars.matcher(include).matches())
				throw error("Illegal use of '**' in include path", source, line);
			if (!virtual.startsWith("/"))
				virtual = "/" + virtual;
			if (virtual.endsWith("/"))
				virtual = virtual.substring(0, virtual.length() - 1);
			this.virtual = virtual;
			this.pattern = compilePrefix(include);
			include = include.replace("//", "/");
			if (include.length() > 1 && include.endsWith("/"))
				include = include.substring(0, include.length() - 1);
			simple = include.contains("*") ? null : include;
		}

		/**
		 * Patterns are matched by translation to regex. The following invariants
		 * are assumed to hold:
		 *
		 *  - The pattern starts with a '/'.
		 *  - There are no occurrences of '**' that is not surrounded by slashes
		 *    (unless it is at the start of a pattern).
		 *  - There is at most one double slash.
		 *
		 *  The result of the translation has precisely one capture group, which
		 *  (after successful matching) will contain the part of the path that
		 *  should be glued to the virtual prefix.
		 *
		 *  It proceeds by starting the capture group either after the double
		 *  slash or at the start of the pattern, and then replacing '*' with
		 *  '[^/]*' (meaning any number of non-slash characters) and '/**' with
		 *  '(?:|/.*)' (meaning empty string or a slash followed by any number of
		 *  characters including '/').
		 *
		 *   The pattern is terminated by the term '(?:/.*|$)', saying 'either the
		 *   next character is a '/' or the string ends' -- this avoids accidental
		 *   matching of partial directory/file names.
		 *
		 *   <b>IMPORTANT:</b> Run the ProjectLayoutTests when changing this!
		 */
		private static Pattern compilePrefix(String pattern) {
			pattern = StringUtil.escapeStringLiteralForRegexp(pattern, "*");
			if (pattern.contains("//"))
				pattern = pattern.replace("//", "(/");
			else
				pattern = "(" + pattern;
			if (pattern.endsWith("/"))
				pattern = pattern.substring(0, pattern.length() - 1);
			pattern = pattern.replace("/**", "-///-")
							.replace("*", "[^/]*")
							.replace("-///-", "(?:|/.*)");
			return Pattern.compile(pattern + "(?:/.*|$))");
		}

		/** Is this rewrite simple? (i.e. contains no wildcards) */
		public boolean isSimple() {
			return simple != null;
		}

		/** Returns the path included/excluded by this rewrite, if it is
		 * simple, or <code>null</code> if it is not.
		 *
		 * @return included/excluded path, or <code>null</code>
		 */
		public String simplePrefix() {
			return simple;
		}

		public boolean matches(String path) {
			return pattern.matcher(path).matches();
		}

		public String rewrite(String path) {
			if (virtual == null)
				return null;
			Matcher matcher = pattern.matcher(path);
			if (!matcher.matches())
				return null;
			return virtual + matcher.group(1);
		}

		@Override
		public String toString() {
			return original;
		}
	}
}
