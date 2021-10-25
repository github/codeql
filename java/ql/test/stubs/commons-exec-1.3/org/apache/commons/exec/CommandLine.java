/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

/*
 * Adapted from Apache Commons Exec version 1.3 as available at
 *   https://search.maven.org/remotecontent?filepath=org/apache/commons/commons-exec/1.3/commons-exec-1.3-sources.jar
 * Only relevant stubs of this file have been retained for test purposes.
 */

package org.apache.commons.exec;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

public class CommandLine {

	public static CommandLine parse(final String line) {
		return null;
	}

	public static CommandLine parse(final String line, final Map<String, ?> substitutionMap) {
		return null;
	}

	public CommandLine(final String executable) {
	}

	public CommandLine(final File executable) {
	}

	public CommandLine(final CommandLine other)
	{
	}

	public CommandLine addArguments(final String[] addArguments) {
		return this.addArguments(addArguments, true);
	}

	public CommandLine addArguments(final String[] addArguments, final boolean handleQuoting) {
		return this;
	}

	public CommandLine addArguments(final String addArguments) {
		return this.addArguments(addArguments, true);
	}

	public CommandLine addArguments(final String addArguments, final boolean handleQuoting) {
		return this;
	}

	public CommandLine addArgument(final String argument) {
		return this.addArgument(argument, true);
	}

	public CommandLine addArgument(final String argument, final boolean handleQuoting) {
		return this;
	}

}