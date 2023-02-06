package com.semmle.util.logging;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.Stack;

import com.semmle.util.exception.CatastrophicError;

/**
 * A class to wrap around accesses to {@link System#out} and
 * {@link System#err}, so that tools can behave consistently when
 * run in-process or out-of-process.
 */
public class Streams {
	private static final InheritableThreadLocal<PrintStream> out =
			new InheritableThreadLocal<PrintStream>() {
		@Override
		protected PrintStream initialValue() {
			return System.out;
		}
	};
	
	private static final InheritableThreadLocal<PrintStream> err = 
			new InheritableThreadLocal<PrintStream>() {
		@Override
		protected PrintStream initialValue() {
			return System.err;
		}
	};

	private static final InheritableThreadLocal<InputStream> in = 
			new InheritableThreadLocal<InputStream>() {
		@Override
		protected InputStream initialValue() {
			return System.in;
		}
	};
	
	private static class SavedContext {
		public PrintStream out, err;
		public InputStream in;
	}
	
	private static final ThreadLocal<Stack<SavedContext>> contexts = 
			new ThreadLocal<Stack<SavedContext>>() {
		@Override
		protected Stack<SavedContext> initialValue() {
			return new Stack<SavedContext>();
		}
	};
	
	public static PrintStream out() {
		return out.get();
	}
	
	public static PrintStream err() {
		return err.get();
	}

	public static InputStream in() {
		return in.get();
	}

	public static void pushContext(OutputStream stdout, OutputStream stderr, InputStream stdin) {
		SavedContext context = new SavedContext();
		context.out = out.get();
		context.err = err.get();
		context.in = in.get();
		// When we run in-process, we don't benefit from
		// a clean slate like we do when starting a new
		// process. We need to reset anything that we care
		// about manually.
		// In particular, the parent VM may well have set
		// showAllLogs=True, and we don't want the extra
		// noise when executing the child, so we set a
		// fresh log state for the duration of the child.
		
		contexts.get().push(context);
		out.set(asPrintStream(stdout));
		err.set(asPrintStream(stderr));
		in.set(stdin);
	}

	private static PrintStream asPrintStream(OutputStream stdout) {
		return stdout instanceof PrintStream ?
				(PrintStream)stdout : new PrintStream(stdout);
	}
	
	public static void popContext() {
		Stack<SavedContext> context = contexts.get();
		out.get().flush();
		err.get().flush();
		if (context.isEmpty())
			throw new CatastrophicError("Popping logging context without preceding push.");
		SavedContext old = context.pop();
		out.set(old.out);
		err.set(old.err);
		in.set(old.in);
	}
}
