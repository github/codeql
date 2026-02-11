package com.semmle.util.process;

import java.io.Serializable;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Stack;
import java.util.TreeMap;

import com.semmle.util.exception.Exceptions;
import com.semmle.util.expansion.ExpansionEnvironment;

/**
 * Helper methods for finding out environment properties like the OS type.
 */
public class Env {
	/**
	 * Enum for commonly used environment variables.
	 *
	 * <p>
	 * The intention is that the name of the enum constant is the same as the environment
	 * variable itself. This means that the <code>toString</code> method does the right thing,
	 * as does calling {@link Enum#name() }.
	 * </p>
	 *
	 * <p>
	 * Should you wish to rename an environment variable (which you're unlikely to, due to the
	 * fact that there are many non-Java consumers), you can do a rename refactoring to make the
	 * Java consumers do the right thing.
	 * </p>
	 */
	public enum Var {
		/*
		 * Core toolchain variables
		 */
		/**
		 * The location of the user's configuration files, including project configurations,
		 * dashboard configurations, team insight configurations, licenses etc.
		 */
		SEMMLE_HOME,
		/**
		 * The location of the user's data, including snapshots, built dashboards, team
		 * insight data, etc.
		 */
		SEMMLE_DATA,
		/**
		 * The location of any caches used by the toolchain, including compilation caches, trap caches, etc.
		 */
		SEMMLE_CACHE,
		/**
		 * If running from a git tree, the root of the tree.
		 */
		SEMMLE_GIT_ROOT,
		/**
		 * The root from which relative paths in a DOOD file are resolved.
		 */
		SEMMLE_QUERY_ROOT,
		/**
		 * The directory where lock files are kept.
		 */
		SEMMLE_LOCK_DIR,
		/**
		 * The directory which will be checked for licenses.
		 */
		SEMMLE_LICENSE_DIR,
		/**
		 * The location where our queries are kept.
		 */
		ODASA_QUERIES,
		/**
		 * Whether we are running in 'prototyping mode'.
		 */
		ODASA_PROTOTYPE_MODE,
		/**
		 * The location of the default compilation cache, as a space-separated list of URIs.
		 *
		 * Multiple entries are tried in sequence.
		 */
		SEMMLE_COMPILATION_CACHE,
		/**
		 * Override the versions used in compilation caching.
		 * 
		 * This is useful for testing without modifying the version manually.
		 */
		SEMMLE_OVERRIDE_OPTIMISER_VERSION,
		/**
		 * If set, do not use compilation caching.
		 */
		SEMMLE_NO_COMPILATION_CACHING,
		/**
		 * If set, use this as the size of compilation caches, in bytes. If set to 'INFINITY', no
		 * limit will be placed on the size.
		 */
		SEMMLE_COMPILATION_CACHE_SIZE,

		/*
		 * Other toolchain variables
		 */
		SEMMLE_JAVA_HOME,
		ODASA_JAVA_HOME,
		ODASA_TRACER_CONFIGURATION,
		/**
		 * The Java tracer agent to propagate to JVM processes.
		 */
		SEMMLE_JAVA_TOOL_OPTIONS,
		/**
		 * Whether to run jar-based subprocesses in-process instead.
		 */
		ODASA_IN_PROCESS,
		/**
		 * The executable to use for importing trap files.
		 */
		SEMMLE_TRAP_IMPORTER,
		SEMMLE_PRESERVE_SYMLINKS,
		CODEQL_PATH_TRANSFORMER,
		SEMMLE_PATH_TRANSFORMER,

		/*
		 * Environment variables for password for credential stores.
		 * Either is accepted to allow a single entry point in the code
		 * while documenting as appropriate for the audience.
		 */
		SEMMLE_CREDENTIALS_PASSWORD,
		LGTM_CREDENTIALS_PASSWORD,

		/*
		 *
		 * Internal config variables
		 */
		/**
		 * Extra arguments to pass to JVMs launched by Semmle tools.
		 */
		SEMMLE_JAVA_ARGS,
		/**
		 * A list of log levels to set, of the form:
		 * "foo.bar=TRACE,bar.baz=DEBUG"
		 */
		SEMMLE_LOG_LEVELS,
		/**
		 * The default heap size for commands that accept a ram parameter.
		 */
		SEMMLE_DEFAULT_HEAP_SIZE,
		SEMMLE_MAX_RAM_MB,
		/**
		 * Whether to disable asynchronous logging in the query server (otherwise it may drop messages).
		 */
		SEMMLE_SYNCHRONOUS_LOGGING,
		/**
		 * Whether or not to use memory mapping
		 */
		SEMMLE_MEMORY_MAPPING,
		SEMMLE_METRICS_DIR,
		/**
		 * Whether we are running in our own unit tests.
		 */
		SEMMLE_UNIT_TEST_MODE,
		/**
		 * Whether to include the source QL in a QLO.
		 */
		SEMMLE_DEBUG_QL_IN_QLO,
		/**
		 * Whether to enable extra assertions
		 */
		ODASA_ASSERTIONS,
		/**
		 * A file containing extra variables for ExpansionEnvironments.
		 */
		ODASA_EXTRA_VARIABLES,
		ODASA_TUNE_GC,
		/**
		 * Whether to run PI in hosted mode.
		 */
		SEMMLE_ODASA_DEBUG,
		/**
		 * The python executable to use for Qltest.
		 */
		SEMMLE_PYTHON,
		/**
		 * The platform we are running on; one of "linux", "osx" and "win".
		 */
		SEMMLE_PLATFORM,
		/**
		 * PATH to use to look up tooling required by macOS Relocator scripts.
		 */
		CODEQL_TOOL_PATH,
		/**
		 * This can override the heuristics for BDD factory resetting. Most useful for measurements
		 * and debugging.
		 */
		CODEQL_BDD_RESET_FRACTION,

		/**
		 * How many TRAPLinker errors to report.
		 */
		SEMMLE_MAX_TRAP_ERRORS,

		/**
		 * How many tuples to accumulate in memory before pushing to disk.
		 */
		SEMMLE_MAX_TRAP_INMEMORY_TUPLES,
		/**
		 * How many files to merge at each merge step.
		 */
		SEMMLE_MAX_TRAP_MERGE,

		/*
		 * Variables used by extractors.
		 */
		/**
		 * Whether the C++ extractor should copy executables before
		 * running them (works around System Integrity Protection
		 * on OS X 10.11+).
		 */
		SEMMLE_COPY_EXECUTABLES,
		/**
		 * When SEMMLE_COPY_EXECUTABLES is in operation, where to
		 * create the directory to copy the executables to.
		 */
		SEMMLE_COPY_EXECUTABLES_SUPER_ROOT,
		/**
		 * When SEMMLE_COPY_EXECUTABLES is in operation, the
		 * directory we are copying executables to.
		 */
		SEMMLE_COPY_EXECUTABLES_ROOT,
		/**
		 * The executable which should be used as an implicit runner on Windows.
		 */
		SEMMLE_WINDOWS_RUNNER_BINARY,
		/**
		 * Verbosity level for the Java interceptor.
		 */
		SEMMLE_INTERCEPT_VERBOSITY,
		/**
		 * Verbosity level for the Java extractor.
		 */
		ODASA_JAVAC_VERBOSE,
		/**
		 * Whether to use class origin tracking for the Java extractor.
		 */
		ODASA_JAVA_CLASS_ORIGIN_TRACKING,
		ODASA_JAVAC_CORRECT_EXCEPTIONS,
		ODASA_JAVAC_EXTRA_CLASSPATH,
		ODASA_NO_ECLIPSE_BUILD,

		/*
		 * Variables set during snapshot builds
		 */
		/**
		 * The location of the project being built.
		 */
		ODASA_PROJECT,
		/**
		 * The location of the snapshot being built.
		 */
		ODASA_SRC,
		ODASA_DB,
		ODASA_OUTPUT,
		ODASA_SUBPROJECT_THREADS,

		/*
		 * Layout variables
		 */
		ODASA_CPP_LAYOUT,
		ODASA_CSHARP_LAYOUT,
		ODASA_PYTHON_LAYOUT,
		ODASA_JAVASCRIPT_LAYOUT,

		/*
		 * External variables
		 */
		JAVA_HOME,
		PATH,
		LINUX_VARIANT,

		/*
		 * If set, use this proxy for HTTP requests
		 */
		HTTP_PROXY,
		http_proxy,

		/*
		 * If set, use this proxy for HTTPS requests
		 */
		HTTPS_PROXY,
		https_proxy,

		/*
		 * If set, ignore the variables above and do not use any proxies for requests
		 */
		NO_PROXY,
		no_proxy,

		/*
		 * Variables set by the codeql-action. All variables will
		 * be unset if the CLI is not in the context of the
		 * codeql-action.
		 */

		/**
		 * Either {@code actions} or {@code runner}.
		 */
		CODEQL_ACTION_RUN_MODE,

		/**
		 * Semantic version of the codeql-action.
		 */
		CODEQL_ACTION_VERSION,
		/*
		 * tracer variables
		 */
		/**
		 * Colon-separated list of enabled tracing languages
		 */
		CODEQL_TRACER_LANGUAGES,
		/**
		 * Path to the build-tracer log file
		 */
		CODEQL_TRACER_LOG,
		/**
		 * Prefix to a language-specific root directory
		 */
		CODEQL_TRACER_ROOT_,

		;
	}

	private static final int DEFAULT_RAM_MB_32 = 1024;
	private static final int DEFAULT_RAM_MB = 4096;
	private static final Env instance = new Env();

	private final Stack<Map<String, String>> envVarContexts;

	public static synchronized Env systemEnv() {
		return instance;
	}

	/**
	 * Create an instance of Env containing no variables. Intended for use in
	 * testing to isolate the test from the local machine environment.
	 */
	public static Env emptyEnv() {
		Env env = new Env();
		env.envVarContexts.clear();
		env.envVarContexts.push(Collections.unmodifiableMap(makeContext()));
		return env;
	}

	private static Map<String, String> makeContext() {
		if (getOS().equals(OS.WINDOWS)) {
			// We want to compare in the same way Windows does, which means
			// upper-casing. For example, '_' needs to come after 'Z', but
			// would come before 'z'.
			return new TreeMap<>((a, b) -> a.toUpperCase(Locale.ENGLISH).compareTo(b.toUpperCase(Locale.ENGLISH)));
		} else {
			return new LinkedHashMap<>();
		}
	}

	public Env() {
		envVarContexts = new Stack<>();
		Map<String, String> env = makeContext();
		try {
			env.putAll(System.getenv());
		} catch (SecurityException ex) {
			Exceptions.ignore(ex, "Treat an inaccessible environment variable as not existing");
		}
		envVarContexts.push(Collections.unmodifiableMap(env));
	}

	public synchronized void unsetAll(Collection<String> names) {
		if (!names.isEmpty()) {
			Map<String, String> map = envVarContexts.pop();
			map = new LinkedHashMap<>(map);
			for (String name : names)
				map.remove(name);
			envVarContexts.push(Collections.unmodifiableMap(map));
		}
	}

	public synchronized Map<String, String> getenv() {
		return envVarContexts.peek();
	}

	/**
	 * Get the value of an environment variable, or <code>null</code> if
	 * the environment variable is not set. WARNING: not all systems may
	 * make a difference between an empty variable or <code>null</code>,
	 * so don't rely on that behavior.
	 */
	public synchronized String get(Var var) {
		return get(var.name());
	}

	/**
	 * Get the value of an environment variable, or <code>null</code> if
	 * the environment variable is not set. WARNING: not all systems may
	 * make a difference between an empty variable or <code>null</code>,
	 * so don't rely on that behavior.
	 */
	public synchronized String get(String envVarName) {
		return getenv().get(envVarName);
	}

	/**
	 * Get the non-empty value of an environment variable, or <code>null</code>
	 * if the environment variable is not set or set to an empty value.
	 */
	public synchronized String getNonEmpty(Var var) {
		return getNonEmpty(var.name());
	}

	/**
	 * Get the value of an environment variable, or the empty string if it is not
	 * set.
	 */
	public synchronized String getPossiblyEmpty(String envVarName) {
		String got = getenv().get(envVarName);
		return got != null ? got : "";
	}

	/**
	 * Get the non-empty value of an environment variable, or <code>null</code>
	 * if the environment variable is not set or set to an empty value.
	 */
	public synchronized String getNonEmpty(String envVarName) {
		String s = get(envVarName);
		return s == null || s.isEmpty() ? null : s;
	}

	/**
	 * Gets the value of the first environment variable among <code>envVarNames</code>
	 * whose value is non-empty, or <code>null</code> if all variables have empty values.
	 */
	public synchronized String getFirstNonEmpty(String... envVarNames) {
		for (String envVarName : envVarNames) {
			String s = getNonEmpty(envVarName);
			if (s != null)
				return s;
		}
		return null;
	}

	/**
	 * Gets the value of the first environment variable among <code>envVars</code>
	 * whose value is non-empty, or <code>null</code> if all variables have empty values.
	 */
	public synchronized String getFirstNonEmpty(Var... envVars) {
		String[] envVarNames = new String[envVars.length];
		for (int i = 0; i < envVars.length; ++i)
			envVarNames[i] = envVars[i].name();
		return getFirstNonEmpty(envVarNames);
	}

	/**
	 * Read a boolean from the given environment variable. If the variable
	 * is not set, then return <code>false</code>. Otherwise, interpret the
	 * environment variable using {@link Boolean#parseBoolean(String)}.
	 */
	public boolean getBoolean(Var var) {
		return getBoolean(var.name());
	}

	/**
	 * Read a boolean from the given environment variable name. If the variable
	 * is not set, then return <code>false</code>. Otherwise, interpret the
	 * environment variable using {@link Boolean#parseBoolean(String)}.
	 */
	public boolean getBoolean(String envVarName) {
		return getBoolean(envVarName, false);
	}

	/**
	 * Read a boolean from the given environment variable. If the variable
	 * is not set, then return <code>def</code>. Otherwise, interpret the
	 * environment variable using {@link Boolean#parseBoolean(String)}.
	 */
	public boolean getBoolean(Var var, boolean def) {
		return getBoolean(var.name(), def);
	}

	/**
	 * Read a boolean from the given environment variable name. If the variable
	 * is not set, then return <code>def</code>. Otherwise, interpret the
	 * environment variable using {@link Boolean#parseBoolean(String)}.
	 */
	public boolean getBoolean(String envVarName, boolean def) {
		String v = get(envVarName);
		return v == null ? def : Boolean.parseBoolean(v);
	}

	/**
	 * Read an integer setting from the given environment variable name. If the
	 * variable is not set, or fails to parse, return the supplied default value.
	 */
	public int getInt(Var var, int defaultValue) {
		return getInt(var.name(), defaultValue);
	}

	/**
	 * Read an integer setting from the given environment variable name. If the
	 * variable is not set, or fails to parse, return the supplied default value.
	 */
	public int getInt(String envVarName, int defaultValue) {
		String value = get(envVarName);
		if (value == null)
			return defaultValue;

		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			Exceptions.ignore(e, "We'll just use the default value.");
			return defaultValue;
		}
	}

	/**
	 * Enter a new context for environment variables, with the given
	 * new variable values. The values will override the current environment
	 * values if they define the same variables.
	 */
	public synchronized void pushEnvironmentContext(Map<String, String> addedValues) {
		Map<String, String> newValues = makeContext();
		newValues.putAll(envVarContexts.peek());
		newValues.putAll(addedValues);
		envVarContexts.push(Collections.unmodifiableMap(newValues));
	}

	/**
	 * Leave a context for environment variables that was created with
	 * <code>pushEnvironmentContext</code>
	 */
	public synchronized void popEnvironmentContext() {
		envVarContexts.pop();
	}

	/**
	 * Add all the custom environment variables to a process builder, so that
	 * they are passed on to the child process.
	 */
	public synchronized void addEnvironmentToNewProcess(ProcessBuilder builder) {
		if (envVarContexts.size() > 1)
			builder.environment().putAll(envVarContexts.peek());
	}

	public synchronized void addEnvironmentToNewEnv(ExpansionEnvironment env) {
		if (envVarContexts.size() > 1)
			env.defineVars(envVarContexts.peek());
	}

	/**
	 * Get a string representing the OS type. This
	 * is not guaranteed to have any particular form, and
	 * is for displaying to users. Might return <code>null</code> if
	 * the property is not defined by the JVM.
	 */
	public static String getOSName() {
		return System.getProperty("os.name");
	}

	/**
	 * Determine which OS is currently being run (somewhat best-effort).
	 * Does not determine whether a program is being run under Cygwin
	 * or not - Windows will be the OS even under Cygwin.
	 */
	public static OS getOS() {
		String name = getOSName();
		if (name == null)
			return OS.UNKNOWN;
		if (name.contains("Windows"))
			return OS.WINDOWS;
		else if (name.contains("Mac OS X"))
			return OS.MACOS;
		else if (name.contains("Linux"))
			return OS.LINUX;
		else
			// Guess that we are probably some Unix flavour
			return OS.UNKNOWN_UNIX;
	}

	/**
	 * Kinds of operating systems. A notable absence is Cygwin: this just
	 * gets reported as Windows.
	 */
	public static enum OS {
		WINDOWS(false, false), LINUX(true, true), MACOS(false, true), UNKNOWN_UNIX(true, true), UNKNOWN(true, true),;

		private final boolean fileSystemCaseSensitive;
		private final boolean envVarsCaseSensitive;

		private OS(boolean fileSystemCaseSensitive, boolean envVarsCaseSensitive) {
			this.fileSystemCaseSensitive = fileSystemCaseSensitive;
			this.envVarsCaseSensitive = envVarsCaseSensitive;
		}

		/**
		 * Get an OS value from the short display name. Acceptable
		 * inputs (case insensitive) are: Windows, Linux, MacOS or
		 * Mac OS.
		 *
		 * @throws IllegalArgumentException if the given name does not
		 *         correspond to an OS
		 */
		public static OS fromDisplayName(String name) {
			if (name != null) {
				name = name.toUpperCase();
				if ("WINDOWS".equals(name))
					return WINDOWS;
				if ("LINUX".equals(name))
					return LINUX;
				if ("MACOS".equals(name.replace(" ", "")))
					return MACOS;
			}
			throw new IllegalArgumentException("No OS type found with name " + name);
		}

		public boolean isFileSystemCaseSensitive() {
			return fileSystemCaseSensitive;
		}

		public boolean isEnvironmentCaseSensitive() {
			return envVarsCaseSensitive;
		}

		/** The short name of this operating system, in the style of {@link Var#SEMMLE_PLATFORM}. */
		public String getShortName() {
			switch (this) {
			case WINDOWS:
				return "win";
			case LINUX:
				return "linux";
			case MACOS:
				return "osx";
			default:
				return "unknown";
			}
		}
	}

	public static enum Architecture {
		X86(true, false), X64(false, true), UNDETERMINED(false, false);

		private final boolean is32Bit;
		private final boolean is64Bit;

		private Architecture(boolean is32Bit, boolean is64Bit) {
			this.is32Bit = is32Bit;
			this.is64Bit = is64Bit;
		}

		/** Is this definitely a 32-bit architecture? */
		public boolean is32Bit() {
			return is32Bit;
		}

		/** Is this definitely a 64-bit architecture? */
		public boolean is64Bit() {
			return is64Bit;
		}
	}

	/**
	 * Try to detect whether the JVM is 32-bit or 64-bit. Since there is no documented,
	 * portable way to do this it is best effort.
	 */
	public Architecture tryDetermineJvmArchitecture() {
		String value = System.getProperty("sun.arch.data.model");
		if ("32".equals(value))
			return Architecture.X86;
		else if ("64".equals(value))
			return Architecture.X64;

		// Look at the max heap value - if >= 4G we *must* be in 64-bit
		long maxHeap = Runtime.getRuntime().maxMemory();
		if (maxHeap < Long.MAX_VALUE && maxHeap >= 4096L << 20)
			return Architecture.X64;

		// Try to get the OS arch - it *appears* to give JVM bitness
		String osArch = System.getProperty("os.arch");
		if ("x86".equals(osArch) || "i386".equals(osArch))
			return Architecture.X86;
		else if ("x86_64".equals(osArch) || "amd64".equals(osArch))
			return Architecture.X64;

		return Architecture.UNDETERMINED;
	}

	/**
	 * Get the default amount of ram to use for new JVMs, depending on the
	 * current architecture. If it looks like we're running on a 32-bit
	 * machine, the result is sufficiently small to be representable.
	 */
	public int defaultRamMb() {
		return getInt(
				Var.SEMMLE_DEFAULT_HEAP_SIZE,
				tryDetermineJvmArchitecture().is32Bit() ? DEFAULT_RAM_MB_32 : DEFAULT_RAM_MB);
	}
}
