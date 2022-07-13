package com.semmle.util.expansion;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.exception.UserError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.process.Builder;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.Var;
import com.semmle.util.process.LeakPrevention;

/**
 * An environment for performing variable expansions.
 *
 * <p>
 * The environment is defined by a set of variable definitions, which are
 * name/value pairs of strings. Once this has been populated (via the
 * {@link #defineVar(String, String)} and {@link #defineVars(Map)} methods),
 * arbitrary strings can be expanded.
 * </p>
 *
 * <p>
 * Two modes of expansion are supported:
 * </p>
 * <ul>
 * <li>String mode ({@link #strExpand(String)}): The result is intended to be a
 * single string.</li>
 * <li>List mode ({@link #listExpand(String)}): The result will be interpreted
 * as a command line, and hence is a list of strings.
 * </ul>
 *
 * <p>
 * Variables are referenced by <code>${name}</code> to trigger a string-mode
 * expansion, and by <code>${=name}</code> to trigger a list-mode expansion.
 * This makes {@code $} a meta-character, and so it has to be escaped; the
 * escape sequence for it is <code>${}</code>.
 * </p>
 *
 * <p>
 * In list mode, strings are split in a platform-independent way similar (but
 * not identical) to normal shell argument splitting. Runs of white-space
 * separate arguments, and double-quotes can be used to protect whitespace from
 * splitting. The escape character is backslash. All of these metacharacters
 * have no special meaning in string mode.
 * </p>
 *
 * <p>
 * The {@code define*} and {@link #doNotExpand(String...)} methods of this
 * class are not thread-safe; they mutate instance state in an unsynchronized
 * way. By contrast, the expansion methods ({@link #strExpand(String)},
 * {@link #strExpandVar(String)}, {@link #listExpand(String)},
 * {@link #listExpandVar(String)} and {@link #varLookup(String)})
 * are thread safe relative to each
 * other. This means that it's fine to construct an expansion environment once,
 * and then use it from multiple threads concurrently, as long as no new variables
 * are defined. In addition, {@link #validate(String)} is safe to call once an
 * {@link ExpansionEnvironment} is fully initialised, even concurrently.
 * </p>
 *
 * <p>
 * Upon encountering any error (malformed variable expansion, malformed quoted
 * string (in list mode), reference to unknown variable, cyclic variable
 * definitions), the {@link #strExpand(String)} and {@link #listExpand(String)}
 * methods will throw {@link UserError} with a suitable message.
 * </p>
 *
 * <p>
 * As an advanced feature, command substitutions can be supported. They take the
 * form of <code>$(cmd arg1 arg2)</code> for string-mode expansion, and
 * <code>$(=cmd arg1
 * arg2)</code> for list-mode. The contents of the <code>$(..)</code> operator
 * undergo normal splitting, and are then run as a new process with the given
 * list of arguments. The working directory is unspecified, and it is an error
 * to depend upon it. A non-zero exit code, or a non-empty {@code stderr} stream
 * of the command, will result in a {@link UserError} indicating that something
 * went wrong; otherwise, the {@code stdout} output is collected and substituted
 * (possibly undergoing splitting, in the second form).
 * </p>
 */
public class ExpansionEnvironment {

	/**
	 * A source for variable definitions to be used in an expansion environment.
	 */
	public static interface VariableSource {
		/**
		 * A callback which is expected to add all variables in the source to
		 * the given environment.
		 *
		 * @param env
		 *            The environment that should be filled in.
		 */
		public void fillIn(ExpansionEnvironment env);
	}

	private final Map<String, String> vars = new LinkedHashMap<String, String>();

	private final Set<String> unexpandedVars = new LinkedHashSet<String>();

	private final boolean commandSubstitutions;

	/**
	 * Construct an empty {@link ExpansionEnvironment}.
	 */
	public ExpansionEnvironment(boolean commandSubstitutions) {
		this.commandSubstitutions = commandSubstitutions;
	}

	/**
	 * This the old default constructor, which always enables command substutitions.
	 * <b>Doing so is a security risk</b> whenever the string you expand may come
	 * from an untrusted source, so you should only do that when you explicitly want
	 * to do it and have decided that it is safe. (And then use the constructor that
	 * has an explicit argument to say so!)
	 */
	@Deprecated
	public ExpansionEnvironment() {
		this(true);
	}

	/**
	 * Construct an environment based on an existing map.
	 */
	public ExpansionEnvironment(boolean commandSubstitutions, Map<String, String> vars) {
		this(commandSubstitutions);
		this.vars.putAll(vars);
	}

	/**
	 * Construct a copy of an existing {@link ExpansionEnvironment}.
	 */
	public ExpansionEnvironment(ExpansionEnvironment other) {
		this(other.commandSubstitutions);
		this.vars.putAll(other.vars);
		this.unexpandedVars.addAll(other.unexpandedVars);
	}

	/**
	 * Add a set of variable definitions to this environment.
	 *
	 * @param vars
	 *            A mapping from variable names to variable values. Recursive
	 *            variable references are allowed, but cycles are an error.
	 */
	public void defineVars(Map<String, String> vars) {
		this.vars.putAll(vars);
	}

	/**
	 * Add the specified variable definition to this environment.
	 *
	 * @param name
	 *            A variable name.
	 * @param value
	 *            The value that the variable should expand to. References to
	 *            other variables or expansions are allowed, but cycles are an
	 *            error.
	 */
	public void defineVar(String name, String value) {
		this.vars.put(name, value);
	}

	/**
	 * Try to load a file as a Java properties file and add all of its key/value
	 * pairs as variable definitions.
	 *
	 * @param vars
	 *            A {@link File} that will be loaded as a Java properties file,
	 *            if it exists. May be <code>null</code> or a file whose
	 *            existence has not been checked.
	 * @throws ResourceError
	 *             if the file exists but can't be read, or exists as a
	 *             directory, or reading it fails.
	 */
	public void defineVarsFromFile(File vars) {
		if (vars == null || !vars.exists())
			return;

		if (vars.isDirectory())
			throw new ResourceError(vars
					+ " is a directory, cannot load variables from it.");

		Properties properties = FileUtil.loadProperties(vars);
		for (String key : properties.stringPropertyNames())
			defineVar(key, properties.getProperty(key));
	}

	/**
	 * Add a variable definition of {@code env.foo=bar} for each system
	 * environment variable {@code foo=bar}. Typically it is desirable to allow
	 * the environment to override previously specified variables, so this
	 * should be called once all other variables have been defined.
	 *
	 * <p>
	 * The values of variables taken from the environment are escaped to prevent
	 * recursive expansion; in particular, this prevents accidental command
	 * execution if a command substitution is encountered in the environment.
	 * </p>
	 */
	public void defineVarsFromEnvironment(Env environment) {
		String extraVars = environment.get(Var.ODASA_EXTRA_VARIABLES);
		if (extraVars != null)
			defineVarsFromFile(new File(extraVars));

		for (Entry<String, String> var : environment.getenv().entrySet())
			defineVar("env." + var.getKey(), var.getValue().replace("$", "${}"));

		environment.addEnvironmentToNewEnv(this);
	}

	/**
	 * Indicate that references to the given set of variable names should not be
	 * expanded. This means that they need not be defined, and the output will
	 * contain the literal variable expansion sequences.
	 *
	 * @param vars
	 *            A list of variable names.
	 */
	public void doNotExpand(String... vars) {
		for (String var : vars)
			unexpandedVars.add(var);
	}

	/**
	 * Supply a "default value" for a variable, meaning that the variable will
	 * be set to the given default value if it hasn't already been defined. No
	 * change is made to this environment if a definition exists.
	 * @param var A variable name.
	 * @param defaultValue The default value for the named variable.
	 */
	public void setDefault(String var, String defaultValue) {
		if (!vars.containsKey(var))
			vars.put(var, defaultValue);
	}

	/**
	 * Expand the given string in "string mode", resolving variable references
	 * and command substitutions.
	 */
	public String strExpand(String s) {
		try {
			return new Expander().new ExpansionParser(s).parseAsString().expandAsString();
		} catch (UserError e) {
			throw new UserError("Failed to expand '" + s + "'.", e);
		}
	}

	/**
	 * Expand the given string in "list mode", resolving variable references and
	 * command substitutions.
	 */
	public List<String> listExpand(String s) {
		try {
			return new Expander().new ExpansionParser(s).parseAsList().expandAsList();
		} catch (UserError e) {
			throw new UserError("Failed to expand '" + s
					+ "' as an argument list.", e);
		}
	}

	/**
	 * Expand the given variable fully in "string mode", resolving variable
	 * references and command substitutions. The entire string is interpreted as
	 * the name of the initial variable.
	 */
	public String strExpandVar(String varName) {
		return new Expander().new Variable(varName).expandAsString();
	}

	/**
	 * Expand the given variable fully in "list mode", resolving variable
	 * references and command substitutions. The entire string is interpreted as
	 * the name of the initial variable.
	 */
	public List<String> listExpandVar(String varName) {
		return new Expander().new SplitVariable(varName).expandAsList();
	}

	/**
	 * Validate the given string for expansion. This verifies the absence of
	 * parse errors, and the fact that all directly referenced variables are
	 * defined by this environment.
	 *
	 * <p>
	 * Expansion using {@link #strExpand(String)} or {@link #listExpand(String)}
	 * may still not succeed, if there are semantic errors (like circular
	 * variable definitions) or a command substitution introduces a reference to
	 * an undefined variable.
	 * </p>
	 *
	 * @param str
	 *            A string that should be validated.
	 * @throws UserError
	 *             if validation fails, with a suitable error message.
	 */
	public void validate(String str) {
		new Expander().new ExpansionParser(str).parseAsList().validate();
	}

	/**
	 * Look up the (raw) value of a given variable, without performing expansion
	 * on it.
	 *
	 * @param name
	 *            The variable name.
	 * @return The value that this variable is mapped to.
	 * @throws UserError
	 *             if the variable is not defined.
	 */
	public synchronized String varLookup(String name) {
		String value = vars.get(name);
		if (value == null) {
			ArrayList<String> available = new ArrayList<String>(vars.keySet());
			Collections.sort(available);
			throw new UserError("Attempting to expand unknown variable: "
					+ name + ", available variables are: " + available);
		}
		return value;
	}

	/**
	 * Check whether this environment defines a variable of the given name, without
	 * performing expansion on it -- such full expansion may still fail.
	 *
	 * @param name The variable name.
	 * @return <code>true</code> if this environment contains a direct definition
	 */
	public boolean definesVar(String name) {
		return vars.containsKey(name);
	}

	private static class ExpansionTokeniser {
		/**
		 * The delimiters which should be returned as their own tokens. Order of
		 * alternatives matters! The recognised tokens are, in order:
		 *
		 * <ul>
		 * <li>{@code \\}</li>
		 * <li>{@code \"}</li>
		 * <li>{@code "}</li>
		 * <li><code>${}</code></li>
		 * <li><code>${=</code></li>
		 * <li><code>${</code></li>
		 * <li><code>$(=</code></li>
		 * <li><code>$(</code></li>
		 * <li><code>$</code></li>
		 * <li><code>}</code></li>
		 * <li><code>)</code></li>
		 * <li>Runs of whitespace.</li>
		 * </ul>
		 *
		 * <p>
		 * By defining the alternatives in this order, longer matches will be
		 * preferred, so that checking for escape sequences is easy. Note that
		 * in the regular expression source, a literal {@code \} must undergo
		 * two levels of escaping: Java strings and regular expression
		 * metacharacters; it thus becomes {@code \\\\}.
		 */
		private static final Pattern delims = Pattern
				.compile("\\\\\\\\|\\\\\"|\"|\\$\\{\\}|\\$\\{=|\\$\\{|"
						+ "\\$\\(=|\\$\\(|\\$|\\}|\\)|\\s+");

		private final List<String> tokens = new ArrayList<String>();
		private final int[] positions;
		private int nextToken = 0;

		public ExpansionTokeniser(String str) {
			Matcher matcher = delims.matcher(str);
			StringBuffer tmp = new StringBuffer();
			while (matcher.find()) {
				matcher.appendReplacement(tmp, "");
				if (tmp.length() > 0) {
					tokens.add(tmp.toString());
					tmp = new StringBuffer();
				}
				tokens.add(matcher.group());
			}
			matcher.appendTail(tmp);
			if (tmp.length() > 0)
				tokens.add(tmp.toString());

			positions = new int[tokens.size()];
			int pos = 0;
			for (int i = 0; i < tokens.size(); i++) {
				positions[i] = pos;
				pos += tokens.get(i).length();
			}
		}

		public boolean hasMoreTokens() {
			return nextToken < tokens.size();
		}

		public String nextToken() {
			return tokens.get(nextToken++);
		}

		public boolean isDelimiter(String token) {
			return delims.matcher(token).matches();
		}

		public int pos() {
			return positions[nextToken - 1] + 1;
		}
	}

	/**
	 * A wrapper around the various expansion classes, holding some expansion
	 * state to detect things like circular variable definitions.
	 */
	private class Expander {

		private final Set<String> expansionsInProgress = new LinkedHashSet<String>();

		/**
		 * A string expansion. This can be a literal string, a variable reference or
		 * a command substitution; the latter two can optionally be "split". Each
		 * expansion can be interpreted to yield a single string or a list of
		 * strings (typically as program arguments).
		 */
		abstract class Expansion {
			public abstract String expandAsString();

			public abstract List<String> expandAsList();

			public abstract void validate();
		}

		class Sentence extends Expansion {
			private final List<List<Expansion>> words = new ArrayList<List<Expansion>>();

			public Sentence(List<List<Expansion>> words) {
				this.words.addAll(words);
			}

			@Override
			public void validate() {
				for (List<Expansion> expansions : words)
					for (Expansion expansion : expansions)
						expansion.validate();
			}

			private String expandWord(List<Expansion> word) {
				StringBuilder result = new StringBuilder();
				for (Expansion e : word)
					result.append(e.expandAsString());
				return result.toString();
			}

			@Override
			public String expandAsString() {
				StringBuilder result = new StringBuilder();

				for (List<Expansion> word : words) {
					if (result.length() > 0)
						result.append(' ');
					result.append(expandWord(word));
				}

				return result.toString();
			}

			@Override
			public List<String> expandAsList() {
				List<String> result = new ArrayList<String>();

				for (List<Expansion> word : words) {
					List<List<String>> segments = new ArrayList<List<String>>();
					for (Expansion e : word) {
						segments.add(e.expandAsList());
					}
					result.addAll(glue(segments));
				}

				return result;
			}

			/**
			 * This is a non-quadratic implementation of the following Haskell code:
			 *
			 * <pre>
			 * <code>
			 * glue :: [[String]] -&gt; [String]
			 * glue = foldr join []
			 *     where join [] xs = xs
			 *           join xs [] = xs
			 *           join xs ys = init xs ++ [last xs ++ head ys] ++ tail ys
			 * </code>
			 * </pre>
			 */
			private List<String> glue(List<List<String>> segments) {
				String trailingWord = null;
				List<String> result = new ArrayList<String>();
				for (List<String> segment : segments)
					trailingWord = glue_join_accum(result, segment, trailingWord);

				if (trailingWord != null)
					result.add(trailingWord);

				return result;
			}

			private String glue_join_accum(List<String> result,
					List<String> segment, String trailingWord) {
				int n = segment.size();
				switch (n) {
				case 0:
					return trailingWord;
				case 1:
					return combine(trailingWord, segment.get(0));
				default:
					result.add(combine(trailingWord, segment.get(0)));
					result.addAll(segment.subList(1, n - 1));
					return segment.get(n - 1);
				}
			}

			private String combine(String a, String b) {
				if (a == null)
					return b;
				return a + b;
			}
		}

		class Literal extends Expansion {
			private final String value;

			public Literal(String value) {
				this.value = value;
			}

			@Override
			public void validate() {
				// Always valid.
			}

			@Override
			public String expandAsString() {
				return value;
			}

			@Override
			public List<String> expandAsList() {
				return Collections.singletonList(value);
			}
		}

		class QuotedString extends Sentence {
			public QuotedString(List<Expansion> content) {
				super(Collections.singletonList(content));
			}

			@Override
			public List<String> expandAsList() {
				return Collections.singletonList(this.expandAsString());
			}
		}

		class Variable extends Expansion {
			protected final String name;

			public Variable(String name) {
				this.name = name;
			}

			@Override
			public void validate() {
				varLookup(name); // Will throw if variable is undefined.
			}

			protected void startExpanding(String name) {
				if (!expansionsInProgress.add(name))
					throw new UserError("Circular expansion of variable " + name);
			}

			protected void doneWith(String name) {
				if (!expansionsInProgress.remove(name))
					throw new CatastrophicError("Not currently expanding " + name);
			}

			protected String ref() {
				return "${" + name + "}";
			}

			@Override
			public final String expandAsString() {
				if (unexpandedVars.contains(name))
					return ref();
				startExpanding(name);
				String result = expandAsStringImpl();
				doneWith(name);
				return result;
			}

			public String expandAsStringImpl() {
				// Not calling ExpansionEnvironment.strExpand(), since
				// we must run in the same enclosing instance of Expander.
				return new ExpansionParser(varLookup(name)).parseAsString().expandAsString();
			}

			@Override
			public final List<String> expandAsList() {
				if (unexpandedVars.contains(name))
					return Collections.singletonList(ref());
				startExpanding(name);
				List<String> result = expandAsListImpl();
				doneWith(name);
				return result;
			}

			public List<String> expandAsListImpl() {
				return Collections.singletonList(expandAsStringImpl());
			}
		}

		class SplitVariable extends Variable {
			public SplitVariable(String name) {
				super(name);
			}

			@Override
			protected String ref() {
				return "${=" + name + "}";
			}

			@Override
			public String expandAsStringImpl() {
				return StringUtil.glue(" ", expandAsListImpl());
			}

			@Override
			public List<String> expandAsListImpl() {
				return listExpand(varLookup(name));
			}
		}

		class Command extends Expansion {
			private final Sentence argv;

			public Command(List<List<Expansion>> args) {
				this.argv = new Sentence(args);
			}

			@Override
			public void validate() {
				argv.validate();
			}

			protected String run() {
				List<String> args = argv.expandAsList();
				ByteArrayOutputStream result = new ByteArrayOutputStream();
				ByteArrayOutputStream err = new ByteArrayOutputStream();
				Builder builder = new Builder(args, result, err);
				builder.setLeakPrevention(LeakPrevention.ALL);
				try {
					int exitCode = builder.execute();
					if (exitCode != 0)
						throw new UserError("Exit code " + exitCode
								+ " from command "
								+ builder.toString());
					if (err.size() > 0)
						throw new UserError("Command \""
								+ builder.toString()
								+ "\" produced output on stderr: " + err.toString());
				} catch (RuntimeException e) {
					throw new UserError("Could not execute command "
							+ builder.toString(), e);
				}
				return result.toString();
			}

			@Override
			public String expandAsString() {
				return run();
			}

			@Override
			public List<String> expandAsList() {
				return Collections.singletonList(expandAsString());
			}
		}

		class SplitCommand extends Command {
			public SplitCommand(List<List<Expansion>> argv) {
				super(argv);
			}

			@Override
			public String expandAsString() {
				return StringUtil.glue(" ", expandAsList());
			}

			@Override
			public List<String> expandAsList() {
				return new ExpansionParser(run()).splitAsString().expandAsList();
			}
		}

		private class ExpansionParser {
			private final ExpansionTokeniser tokens;

			public ExpansionParser(String str) {
				tokens = new ExpansionTokeniser(str);
			}

			public Sentence parseAsString() {
				List<List<Expansion>> words = new ArrayList<List<Expansion>>();
				words.add(parseTerminatedString(null));
				return new Sentence(words);
			}

			public Sentence parseAsList() {
				return new Sentence(parseTerminatedList(null, false));
			}

			public Sentence splitAsString() {
				return new Sentence(parseTerminatedList(null, true));
			}

			private List<Expansion> parseTerminatedString(String terminator) {
				List<Expansion> result = new ArrayList<Expansion>();

				while (tokens.hasMoreTokens()) {
					String next = tokens.nextToken();
					if (next.equals(terminator)) {
						return result;
					} else if (next.equals("\\\"")) {
						result.add(new Literal("\""));
					} else if (next.equals("\\\\")) {
						result.add(new Literal("\\"));
					} else if (!tryParseExpansion(result, next)) {
						result.add(new Literal(next));
					}
				}

				if (terminator != null)
					throw new UserError(
							"Premature end of input while looking for matching '"
									+ terminator + "'.");

				return result;
			}

			private List<List<Expansion>> parseTerminatedList(String terminator,
					boolean noExpansions) {
				List<List<Expansion>> result = new ArrayList<List<Expansion>>();

				List<Expansion> accum = new ArrayList<Expansion>();
				boolean mustSeeSpace = false;
				while (tokens.hasMoreTokens()) {
					String next = tokens.nextToken();
					if (next.equals(terminator)) {
						if (accum.size() > 0)
							result.add(accum);
						return result;
					} else if (mustSeeSpace
							&& !Character.isWhitespace(next.charAt(0))) {
						throw new UserError("The quoted string ending at "
								+ tokens.pos()
								+ " must be surrounded by whitespace.");
					} else if (next.length() > 0
							&& Character.isWhitespace(next.charAt(0))) {
						mustSeeSpace = false;
						if (accum.size() > 0) {
							result.add(accum);
							accum = new ArrayList<Expansion>();
						}
					} else if (next.equals("\"")) {
						if (!accum.isEmpty())
							throw new UserError(
									"At position "
											+ tokens.pos()
											+ ", the quote should "
											+ "either be preceded by a space (if it is intended to start an argument) "
											+ "or escaped as \\\".");
						accum.add(new QuotedString(parseTerminatedString("\"")));
						result.add(accum);
						accum = new ArrayList<Expansion>();
						mustSeeSpace = true;
					} else if (next.equals("\\\"")) {
						// An escaped quote means a literal quote.
						accum.add(new Literal("\""));
					} else if (next.equals("\\\\")) {
						// An escaped backslash means a literal backslash.
						accum.add(new Literal("\\"));
					} else if (noExpansions || !tryParseExpansion(accum, next)) {
						accum.add(new Literal(next));
					}
				}

				if (terminator != null)
					throw new UserError(
							"Premature end of expansion while looking for '"
									+ terminator + "'.");

				if (accum.size() > 0)
					result.add(accum);

				return result;
			}

			private boolean tryParseExpansion(List<Expansion> result,
					String curToken) {
				if (curToken.equals("${}")) {
					result.add(new Literal("$"));
				} else if (curToken.equals("$(=") && commandSubstitutions) {
					result.add(new SplitCommand(parseTerminatedList(")", false)));
				} else if (curToken.equals("$(") && commandSubstitutions) {
					result.add(new Command(parseTerminatedList(")", false)));
				} else if (curToken.equals("${=")) {
					result.add(new SplitVariable(parseVarName()));
				} else if (curToken.equals("${")) {
					result.add(new Variable(parseVarName()));
				} else if (curToken.equals("$")) {
					throw new UserError(
							"Malformed expansion: A standalone '$' character should be escaped as '${}'.");
				} else {
					return false;
				}
				return true;
			}

			protected String parseVarName() {
				if (!tokens.hasMoreTokens())
					throw new UserError(
							"Malformed variable substitution: stray '${' at " + tokens.pos());
				String name = tokens.nextToken();
				if (tokens.isDelimiter(name))
					throw new UserError(
							"Malformed variable substitution: Unexpected '" + name
							+ "' at " + tokens.pos());
				if (!tokens.hasMoreTokens())
					throw new UserError(
							"Malformed variable substitution for '" + name +
							"': Missing '}' at " + tokens.pos());
				String next = tokens.nextToken();
				if (!next.equals("}"))
					throw new UserError(
							"Malformed variable substitution: Expecting '}' at "
									+ tokens.pos() + ", found '" + next + "'.");
				return name;
			}
		}
	}

	/**
	 * Resolve a path. Any variables in the path will be expanded. If
	 * the path is an absolute path after expansion, it is returned as is.
	 * Otherwise, it is combined with the given base path.
	 */
	public File expandPath(File base, String path) {
		String expanded = strExpand(path);
		if (FileUtil.isAbsolute(expanded)) {
			return new File(expanded);
		} else {
			return FileUtil.fileRelativeTo(base, expanded);
		}
	}

	/**
	 * Escape a string so that any '$'s inside it will be interpreted literally, rather than
	 * as parts of variable references.
	 */
	public static String escape(String base) {
		return base.replace("$", "${}");
	}

	/**
	 * Escape {@code argument} as an argument, so that any {@code $}, {@code \} or {@code "} is interpreted literally.
	 *
	 * @param argument - the String to escape.
	 * @return the escaped String.
	 */
	public static String escapeArgument(String argument) {
		return escape(argument).replaceAll(Matcher.quoteReplacement("\\"), Matcher.quoteReplacement("\\\\")).replaceAll(Matcher.quoteReplacement("\""), Matcher.quoteReplacement("\\\""));
	}
}
