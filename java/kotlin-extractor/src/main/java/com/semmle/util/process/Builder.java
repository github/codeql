package com.semmle.util.process;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.semmle.util.io.StreamMuncher;
import com.semmle.util.logging.Streams;

public class Builder extends AbstractProcessBuilder {

	private final OutputStream err;
	private final OutputStream out;
	protected StreamMuncher errMuncher;
	protected StreamMuncher outMuncher;

	public Builder(OutputStream out, OutputStream err, File cwd, String... args) {
		this(out, err, cwd, null, args);
	}

	public Builder(OutputStream out, OutputStream err, File cwd,
			Map<String, String> env, String... args) {
		this(Arrays.asList(args), out, err, env, cwd);
	}

	public Builder(List<String> args, OutputStream out, OutputStream err) {
		this(args, out, err, null, null);
	}

	public Builder(List<String> args, OutputStream out, OutputStream err,
			File cwd) {
		this(args, out, err, null, cwd);
	}

	public Builder(List<String> args, OutputStream out, OutputStream err,
			Map<String, String> env) {
		this(args, out, err, env, null);
	}

	public Builder(List<String> args, OutputStream out, OutputStream err,
			Map<String, String> env, File cwd) {
		super(args, cwd, env);
		this.out = out;
		this.err = err;
	}

	/**
	 * Convenience method that executes the given command line in the current
	 * working directory with the current environment, blocking until
	 * completion. The process's output stream is redirected to System.out, and
	 * its error stream to System.err. It returns the exit code of the command.
	 */
	public static int run(List<String> commandLine) {
		return new Builder(commandLine, Streams.out(), Streams.err()).execute();
	}

	@Override
	protected void cleanupOutputHandling() {
		// wait for munchers to finish munching.
		long deadline = 1000*MUNCH_TIMEOUT;
		// note: check that munchers are not null, in case setupOutputHandling was
		// not called to initialize them
		if(outMuncher != null) {
			waitForMuncher("output", outMuncher,deadline);
		}
		if(errMuncher != null) {
			waitForMuncher("error", errMuncher,deadline);
		}
	}

	@Override
	protected void setupOutputHandling(InputStream stdout, InputStream stderr) {
		errMuncher = new StreamMuncher(stderr, err);
		errMuncher.start();
		outMuncher = new StreamMuncher(stdout, out);
		outMuncher.start();
	}
}
