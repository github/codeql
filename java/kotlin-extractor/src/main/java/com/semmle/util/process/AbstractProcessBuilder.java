package com.semmle.util.process;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Timer;
import java.util.TimerTask;

import com.github.codeql.Logger;
import com.github.codeql.Severity;

import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.InterruptedError;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.RawStreamMuncher;

/**
 * A builder for an external process. This class wraps {@link ProcessBuilder},
 * adding support for spawning threads to manage the input and output streams of
 * the created process.
 */
public abstract class AbstractProcessBuilder {
	public static Logger logger = null;

	// timeout for the muncher threads in seconds
	protected static final long MUNCH_TIMEOUT = 20;
	private final ProcessBuilder builder;
	private boolean logFailure = true;
	private InputStream in;
	private LeakPrevention leakPrevention;

	private volatile boolean interrupted = false;
	private volatile Thread threadToInterrupt = null;

	private volatile boolean hitTimeout = false;

	private final Map<String, String> canonicalEnvVarNames = new LinkedHashMap<>();

	private RawStreamMuncher inMuncher;


	public AbstractProcessBuilder (List<String> args, File cwd, Map<String, String> env)
	{
		// Sanity checks
		CatastrophicError.throwIfNull(args);
		for (int i = 0; i < args.size(); ++i)
			CatastrophicError.throwIfNull(args.get(i));

		leakPrevention = LeakPrevention.NONE;
		builder = new ProcessBuilder(new ArrayList<>(args));
		if (cwd != null) {
			builder.directory(cwd);
		}
		// Make sure that values that have been explicitly removed from Env.systemEnv()
		// -- such as the variables representing command-line arguments --
		// are not taken over by the new ProcessBuilder.
		Map<String, String> keepThese = Env.systemEnv().getenv();
		for (Iterator<String> it = builder.environment().keySet().iterator(); it.hasNext();) {
			String name = it.next();
			if (!keepThese.containsKey(name))
				it.remove();
		}
		if (env != null) {
			addEnvironment(env);
		}

	}

	public void setLeakPrevention(LeakPrevention leakPrevention) {
		CatastrophicError.throwIfNull(leakPrevention);
		this.leakPrevention = leakPrevention;
	}

	/**
	 * See {@link ProcessBuilder#redirectErrorStream(boolean)}.
	 */
	public void setRedirectErrorStream(boolean redirectErrorStream) {
		this.builder.redirectErrorStream(redirectErrorStream);
	}

	public final boolean hasEnvVar(String name) {
		return builder.environment().containsKey(getCanonicalVarName(name));
	}

	/**
	 * Add the specified key/value pair to the environment of the builder,
	 * overriding any previous environment entry of that name. This method
	 * provides additional logic to handle systems where environment
	 * variable names are case-insensitive, ensuring the last-added value
	 * for a name ends up in the final environment regardless of case.
	 * @param name The name of the environment variable. Whether case matters
	 * 		is OS-dependent.
	 * @param value The value for the environment variable.
	 */
	public final void addEnvVar(String name, String value) {
		builder.environment().put(getCanonicalVarName(name), value);
	}

	/**
	 * Prepend a specified set of arguments to this process builder's command line.
	 * This only makes sense before the builder is started.
	 */
	public void prependArgs(List<String> args) {
		builder.command().addAll(0, args);
	}

	/**
	 * Compute a canonical environment variable name relative to this process
	 * builder.
	 *
	 * The need for this method arises on platforms where the environment is
	 * case-insensitive -- any inspection of it in such a situation needs to
	 * canonicalise the variable name to have well-defined behaviour. This is
	 * builder-specific, because it depends on its existing environment. For
	 * example, if it already defines a variable called <code>Path</code>, and the
	 * environment is case-insensitive, then setting a variable called
	 * <code>PATH</code> should overwrite this, and checking whether a variable
	 * called <code>PATH</code> is already defined should return <code>true</code>.
	 */
	public String getCanonicalVarName(String name) {
		if (!Env.getOS().isEnvironmentCaseSensitive()) {
			// We need to canonicalise the variable name to work around Java API limitations.
			if (canonicalEnvVarNames.isEmpty())
				for (String var : builder.environment().keySet())
					canonicalEnvVarNames.put(StringUtil.lc(var), var);
			String canonical = canonicalEnvVarNames.get(StringUtil.lc(name));
			if (canonical == null)
				canonicalEnvVarNames.put(StringUtil.lc(name), name);
			else
				name = canonical;
		}
		return name;
	}

	/**
	 * Get a snapshot of this builder's environment, using canonical variable names
	 * (as per {@link #getCanonicalVarName(String)}) as keys. Modifications to this
	 * map do not propagate back to the builder; use
	 * {@link #addEnvVar(String, String)} or {@link #addEnvironment(Map)} to extend
	 * its environment.
	 */
	public Map<String, String> getCanonicalCurrentEnv() {
		Map<String, String> result = new LinkedHashMap<>();
		for (Entry<String, String> e : builder.environment().entrySet())
			result.put(getCanonicalVarName(e.getKey()), e.getValue());
		return result;
	}

	/**
	 * Specify an input stream of data that will be piped to the process's
	 * standard input.
	 *
	 * CAUTION: if this stream is the current process' standard in and no
	 * input is ever received, then we will leak an uninterruptible thread
	 * waiting for some input. This will terminate only when the standard in
	 * is closed, i.e. when the current process terminates.
	 */
	public final void setIn(InputStream in) {
		this.in = in;
	}

	/**
	 * Set the environment of this builder to the given map. Any
	 * existing environment entries (either from the current process
	 * environment or from previous calls to {@link #addEnvVar(String, String)},
	 * {@link #addEnvironment(Map)} or {@link #setEnvironment(Map)})
	 * are discarded.
	 * @param env The environment to use.
	 */
	public final void setEnvironment(Map<String, String> env) {
		builder.environment().clear();
		canonicalEnvVarNames.clear();
		addEnvironment(env);
	}

	/**
	 * Add the specified set of environment variables to the environment for
	 * the builder. This leaves existing variable definitions in place, but
	 * can override them.
	 * @param env The environment to merge into the current environment.
	 */
	public final void addEnvironment(Map<String, String> env) {
		for (Entry<String, String> entry : env.entrySet())
			addEnvVar(entry.getKey(), entry.getValue());
	}

	public final int execute() {
		return execute(0);
	}

	/**
	 * Set the flag indicating that a non-zero exit code may be expected. This
	 * will suppress the log of failed commands.
	 */
	public final void expectFailure() {
		logFailure = false;
	}

	public final int execute(long timeout) {
		Process process = null;
		boolean processStopped = true;
		Timer timer = null;
		try {
			synchronized (this) {
				// Handle the case where we called kill() too early to use
				// Thread.interrupt()
				if (interrupted)
					throw new InterruptedException();
				threadToInterrupt = Thread.currentThread();
			}

			processStopped = false;
			String directory;
			if (builder.directory() == null) {
				directory = "current directory ('" + System.getProperty("user.dir") + "')";
			} else {
				directory = "'" + builder.directory().toString() + "'";
			}
			logger.debug("Running command: '" + toString() + "' in " + directory);
			process = builder.start();
			setupInputHandling(process.getOutputStream());
			setupOutputHandling(process.getInputStream(),
					process.getErrorStream());
			if (timeout != 0) {
				// create the timer's thread as a "daemon" thread, so it does not
				// prevent the jvm from terminating
				timer = new Timer(true);
				final Thread current = Thread.currentThread();
				timer.schedule(new TimerTask() {
					@Override
					public void run() {
						hitTimeout = true;
						current.interrupt();
					}
				}, timeout);
			}

			int result = process.waitFor();
			processStopped = true;
			if (result != 0 && logFailure)
				logger.error("Spawned process exited abnormally (code " + result
						+ "; tried to run: " + getBuilderCommand() + ")");
			return result;
		} catch (IOException e) {
			throw new ResourceError(
					"IOException while executing process with args: "
							+ getBuilderCommand(), e);
		} catch (InterruptedException e) {
			throw new InterruptedError(
					"InterruptedException while executing process with args: "
							+ getBuilderCommand(), e);
		} finally {
			// cancel the timer
			if (timer != null) {
				timer.cancel();
			}
			// clear the interrupted flag of the current thread
			// in case it was set earlier (ie by the Timer or a call to kill())
			synchronized (this) {
				threadToInterrupt = null;
				Thread.interrupted();
			}
			// get rid of the process, in case it is still running.
			if (process != null && !processStopped) {
				killProcess(process);
			}
			try {
				cleanupInputHandling();
				cleanupOutputHandling();
			} finally {

				if (process != null) {
					FileUtil.close(process.getErrorStream());
					FileUtil.close(process.getInputStream());
					FileUtil.close(process.getOutputStream());
				}
			}
		}
	}

	/**
	 * Provides the implementation of actually stopping the child
	 * process. Provided as an extension point so that this can
	 * be customised for later Java versions or for other reasons.
	 */
	protected void killProcess(Process process) {
		process.destroy();
	}

	/**
	 * Setup handling of the process input stream (stdin).
	 *
	 * @param outputStream OutputStream connected to the process's standard input.
	 */
	protected void setupInputHandling(OutputStream outputStream) {
		if (in == null) {
			FileUtil.close(outputStream);
			return;
		}
		inMuncher = new RawStreamMuncher(in, outputStream);
		inMuncher.start();
	}

	/**
	 * Setup handling of the process' output streams (stdout and stderr).
	 *
	 * @param stdout
	 *            InputStream connected to the process' standard output stream.
	 * @param stderr
	 *            InputStream connected to the process' standard error stream.
	 */
	protected abstract void setupOutputHandling(InputStream stdout, InputStream stderr);

	/**
	 * Cleanup resources related to output handling. The method is always called, either after the process
	 * has exited normally, or after an abnormal termination due to an exception. As a result cleanupOutputHandling()
	 * might be called, without a previous call to setupOutputHandling. The implementation of this method should
	 * handle this case.
	 */
	protected abstract void cleanupOutputHandling();

	private void cleanupInputHandling() {
		if (inMuncher != null && inMuncher.isAlive()) {
			// There's no real need to wait for the muncher to terminate -- on the contrary,
			// if it's still alive it will typically be waiting for a closing action that
			// will only happen after execute() returns anyway.
			// The best we can do is try to interrupt it.
			inMuncher.interrupt();
		}
	}

	protected void waitForMuncher(String which, Thread muncher, long timeout) {
		// wait for termination of the muncher until a deadline is reached
		try {
			muncher.join(timeout);

		} catch (InterruptedException e) {
			Exceptions.ignore(e,"Further interruption attempts are ineffective --"
							   + " we're already waiting for termination.");
		}
		// if muncher is still alive, report an error
		if(muncher.isAlive()){
			muncher.interrupt();
			logger.error(String.format("Standard %s stream hasn't closed %s seconds after termination of subprocess '%s'.", which, MUNCH_TIMEOUT, this));
		}
	}

	public final void kill() {
		synchronized (this) {
			interrupted = true;
			if (threadToInterrupt != null)
				threadToInterrupt.interrupt();
		}
	}

	public boolean processTimedOut() {
		return hitTimeout;
	}

	@Override
	public String toString() {
		return commandLineToString(getBuilderCommand());
	}

	private List<String> getBuilderCommand() {
		return leakPrevention.cleanUpArguments(builder.command());
	}

	private static String commandLineToString(List<String> commandLine) {
		StringBuilder sb = new StringBuilder();
		boolean first = true;
		for (String s : commandLine) {
			boolean tricky = s.isEmpty() || s.contains(" ") ;

			if (!first)
				sb.append(" ");
			first = false;
			if (tricky)
				sb.append("\"");

			sb.append(s.replace("\"", "\\\""));

			if (tricky)
				sb.append("\"");
		}
		return sb.toString();
	}
}
