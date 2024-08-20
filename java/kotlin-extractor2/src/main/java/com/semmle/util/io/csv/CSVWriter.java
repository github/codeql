package com.semmle.util.io.csv;

/**
 Copyright 2005 Bytecode Pty Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import java.io.Closeable;
import java.io.IOException;
import java.io.Writer;
import java.util.List;

/**
 * A very simple CSV writer released under a commercial-friendly license.
 *
 * @author Glen Smith
 *
 */
public class CSVWriter implements Closeable {

	private static final int INITIAL_STRING_SIZE = 128;

	private Writer rawWriter;

	private char separator;

	private char quotechar;

	private char escapechar;

	private String lineEnd;

	/** The quote constant to use when you wish to suppress all quoting. */
	public static final char NO_QUOTE_CHARACTER = '\u0000';

	/** The escape constant to use when you wish to suppress all escaping. */
	private static final char NO_ESCAPE_CHARACTER = '\u0000';

	/** Default line terminator uses platform encoding. */
	private static final String DEFAULT_LINE_END = "\n";

	private boolean[] eagerQuotingFlags = {};

	/**
	 * Constructs CSVWriter using a comma for the separator.
	 *
	 * @param writer
	 *            the writer to an underlying CSV source.
	 */
	public CSVWriter(Writer writer) {
		this(writer,
				CSVParser.DEFAULT_SEPARATOR,
				CSVParser.DEFAULT_QUOTE_CHARACTER,
				CSVParser.DEFAULT_ESCAPE_CHARACTER
				);
	}

	/**
	 * Constructs CSVWriter with supplied separator and quote char.
	 *
	 * @param writer
	 *            the writer to an underlying CSV source.
	 * @param separator
	 *            the delimiter to use for separating entries
	 * @param quotechar
	 *            the character to use for quoted elements
	 * @param escapechar
	 *            the character to use for escaping quotechars or escapechars
	 */
	public CSVWriter(Writer writer, char separator, char quotechar, char escapechar) {
		this(writer, separator, quotechar, escapechar, DEFAULT_LINE_END);
	}

	/**
	 * Constructs CSVWriter with supplied separator, quote char, escape char and line ending.
	 *
	 * @param writer
	 *            the writer to an underlying CSV source.
	 * @param separator
	 *            the delimiter to use for separating entries
	 * @param quotechar
	 *            the character to use for quoted elements
	 * @param escapechar
	 *            the character to use for escaping quotechars or escapechars
	 * @param lineEnd
	 * 			  the line feed terminator to use
	 */
	private CSVWriter(Writer writer, char separator, char quotechar, char escapechar, String lineEnd) {
		this.rawWriter = writer;
		this.separator = separator;
		this.quotechar = quotechar;
		this.escapechar = escapechar;
		this.lineEnd = lineEnd;
	}

	/**
	 * Call with an array of booleans, corresponding to columns, where columns that have
	 * <code>false</code> will not be quoted unless they contain special characters.
	 * <p>
	 * If there are more columns to print than have been configured here, any additional
	 * columns will be treated as if <code>true</code> was passed.
	 */
	public void setEagerQuotingColumns(boolean... flags) {
		eagerQuotingFlags = flags;
	}

	/**
	 * Writes the entire list to a CSV file. The list is assumed to be a
	 * String[]
	 *
	 * @param allLines
	 *            a List of String[], with each String[] representing a line of
	 *            the file.
	 */
	public void writeAll(List<String[]> allLines) throws IOException  {
		for (String[] line : allLines) {
			writeNext(line);
		}
	}

	/**
	 * Writes the next line to the file.
	 *
	 * @param nextLine
	 *            a string array with each comma-separated element as a separate
	 *            entry.
	 */
	public void writeNext(String... nextLine) throws IOException {

		if (nextLine == null)
			return;

		StringBuilder sb = new StringBuilder(INITIAL_STRING_SIZE);
		for (int i = 0; i < nextLine.length; i++) {

			if (i != 0) {
				sb.append(separator);
			}

			String nextElement = nextLine[i];
			if (nextElement == null)
				continue;
			boolean hasSpecials = stringContainsSpecialCharacters(nextElement);

			if (hasSpecials || i >= eagerQuotingFlags.length || eagerQuotingFlags[i]
					|| stringContainsSomewhatSpecialCharacter(nextElement)) {
				if (quotechar != NO_QUOTE_CHARACTER)
					sb.append(quotechar);
				sb.append(hasSpecials ? processLine(nextElement) : nextElement);
				if (quotechar != NO_QUOTE_CHARACTER)
					sb.append(quotechar);
			} else {
				sb.append(nextElement);
			}
		}

		sb.append(lineEnd);
		rawWriter.write(sb.toString());

	}

	/**
	 * Return true if there are characters that need to be escaped in addition to
	 * being quoted.
	 */
	private boolean stringContainsSpecialCharacters(String line) {
		return line.indexOf(quotechar) != -1 || line.indexOf(escapechar) != -1;
	}

	/**
	 * Return true if there are characters that should not appear in a completely
	 * unquoted field.
	 */
	private boolean stringContainsSomewhatSpecialCharacter(String s) {
		return s.indexOf('"') != -1 || s.indexOf('\'') != -1 || s.indexOf('\t') != -1 || s.indexOf(separator) != -1;
	}

	protected StringBuilder processLine(String nextElement)
	{
		StringBuilder sb = new StringBuilder(INITIAL_STRING_SIZE);
		for (int j = 0; j < nextElement.length(); j++) {
			char nextChar = nextElement.charAt(j);
			if (escapechar != NO_ESCAPE_CHARACTER && nextChar == quotechar) {
				sb.append(escapechar).append(nextChar);
			} else if (escapechar != NO_ESCAPE_CHARACTER && nextChar == escapechar) {
				sb.append(escapechar).append(nextChar);
			} else {
				sb.append(nextChar);
			}
		}

		return sb;
	}

	/**
	 * Flush underlying stream to writer.
	 *
	 * @throws IOException if bad things happen
	 */
	public void flush() throws IOException {
		rawWriter.flush();
	}

	/**
	 * Close the underlying stream writer flushing any buffered content.
	 *
	 * @throws IOException if bad things happen
	 *
	 */
	@Override
	public void close() throws IOException {
	  rawWriter.close();
	}

}
