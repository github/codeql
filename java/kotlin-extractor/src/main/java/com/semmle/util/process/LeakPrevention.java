package com.semmle.util.process;

import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.List;

public abstract class LeakPrevention {

	public abstract List<String> cleanUpArguments(List<String> args);

	/**
	 * What to put in place of any suppressed arguments.
	 */
	static final String REPLACEMENT_STRING = "*****";

	/**
	 * Hides all arguments. Will only show the command name.
	 * e.g. "foo bar baz" is changed to "foo"
	 */
	public static final LeakPrevention ALL = new LeakPrevention() {
		@Override
		public List<String> cleanUpArguments(List<String> args) {
			return args.isEmpty() ? args : Collections.singletonList(args.get(0));
		}
	};

	/**
	 * Does not hide any arguments.
	 */
	public static final LeakPrevention NONE = new LeakPrevention() {
		@Override
		public List<String> cleanUpArguments(List<String> args) {
			return args;
		}
	};

	/**
	 * Hides the arguments at the given indexes.
	 */
	public static LeakPrevention suppressedArguments(int... args) {
		if (args.length == 0)
			return NONE;

		final BitSet suppressed = new BitSet();
		for (int index : args) {
			suppressed.set(index);
		}

		return new LeakPrevention() {
			@Override
			public List<String> cleanUpArguments(List<String> args) {
				List<String> result = new ArrayList<>(args.size());
				int index = 0;
				for (String arg : args) {
					if (suppressed.get(index))
						result.add(REPLACEMENT_STRING);
					else
						result.add(arg);
					index++;
				}
				return result;
			}
		};
	}

	/**
	 * Hides the given string from any arguments that it appears in.
	 * The substring will be replaced while leaving the rest of the
	 * argument unmodified.
	 * <p>
	 * There are some potential pitfalls to be aware of when using this
	 * method.
	 * <ul>
	 * <li>This only suppresses exact textual matches. If the argument that
	 * appears is only derived from the secret instead of being an exact
	 * copy then it will not be suppressed.
	 * <li>If the secret value appears elsewhere in a known string, then it
	 * could leak the contents of the secret because the viewer knows what
	 * should have been there in the known case.
	 * </ul>
	 */
	public static LeakPrevention suppressSubstring(final String substringToSuppress) {
		return new LeakPrevention() {
			@Override
			public List<String> cleanUpArguments(List<String> args) {
				List<String> result = new ArrayList<>(args.size());
				for (String arg : args) {
					result.add(arg.replace(substringToSuppress, REPLACEMENT_STRING));
				}
				return result;
			}
		};
	}
}
