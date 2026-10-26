/*
 * #%L SciJava Common shared library for SciJava software. %% Copyright (C) 2009 - 2021 SciJava
 * developers. %% Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions
 * and the following disclaimer. 2. Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. #L%
 */

package org.scijava.log;

public interface Logger {
	default void debug(final Object msg) {}

	default void debug(final Throwable t) {}

	default void debug(final Object msg, final Throwable t) {}

	default void error(final Object msg) {}

	default void error(final Throwable t) {}

	default void error(final Object msg, final Throwable t) {}

	default void info(final Object msg) {}

	default void info(final Throwable t) {}

	default void info(final Object msg, final Throwable t) {}

	default void trace(final Object msg) {}

	default void trace(final Throwable t) {}

	default void trace(final Object msg, final Throwable t) {}

	default void warn(final Object msg) {}

	default void warn(final Throwable t) {}

	default void warn(final Object msg, final Throwable t) {}

	default boolean isDebug() {
		return false;
	}

	default boolean isError() {
		return false;
	}

	default boolean isInfo() {
		return false;
	}

	default boolean isTrace() {
		return false;
	}

	default boolean isWarn() {
		return false;
	}

	default boolean isLevel(final int level) {
		return false;
	}

	default void log(final int level, final Object msg) {}

	default void log(final int level, final Throwable t) {}

	default void log(final int level, final Object msg, final Throwable t) {}

	void alwaysLog(int level, Object msg, Throwable t);

	default String getName() {
		return null;
	}

	int getLevel();

	default Logger subLogger(String name) {
		return null;
	}

}
