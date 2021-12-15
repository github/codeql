/**
 * Provides classes for working with lines of text in source files.
 *
 * This information is only available for snapshots that have been extracted with
 * the `--extract-program-text` flag.
 */

import javascript

/**
 * A line of text (code, comment, or whitespace) in a source file.
 *
 * Note that textual information is only available for snapshots that have been
 * extracted with the `--extract-program-text` flag.
 */
class Line extends @line, Locatable {
  override Location getLocation() { hasLocation(this, result) }

  /** Gets the toplevel element this line belongs to. */
  TopLevel getTopLevel() { lines(this, result, _, _) }

  /** Gets the text of this line, excluding the terminator character(s). */
  string getText() { lines(this, _, result, _) }

  /**
   * Gets the terminator character(s) of this line.
   *
   * This predicate may return:
   *
   * - the empty string if this line is the last line in a file
   *   and there is no line terminator after it;
   * - a single-character string containing the character `\n` (newline),
   *   `\r` (carriage return), `\u2028` (Unicode character LINE SEPARATOR)
   *   or `\u2029` (Unicode character PARAGRAPH SEPARATOR);
   * - the two-character string `\r\n` (carriage return followed by newline).
   */
  string getTerminator() { lines(this, _, _, result) }

  /**
   * Gets the indentation character used by this line.
   *
   * The indentation character of a line is defined to be the whitespace character
   * `c` such that the line starts with one or more instances of `c`, followed by a
   * non-whitespace character.
   *
   * If the line does not start with a whitespace character, or with a mixture of
   * different whitespace characters, its indentation character is undefined.
   */
  string getIndentChar() { result = getText().regexpCapture("(\\s)\\1*\\S.*", 1) }

  override string toString() { result = getText() }
}
