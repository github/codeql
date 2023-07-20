/**
 * @name Duplication in regular expression character class
 * @description Duplicate characters in a class have no effect and may indicate an error in the regular expression.
 * @kind problem
 * @tags reliability
 *       readability
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/regex/duplicate-in-character-class
 */

import python
import semmle.python.regex

predicate duplicate_char_in_class(RegExp r, string char) {
  exists(int i, int j, int x, int y, int start, int end |
    i != x and
    j != y and
    start < i and
    j < end and
    start < x and
    y < end and
    r.character(i, j) and
    char = r.getText().substring(i, j) and
    r.character(x, y) and
    char = r.getText().substring(x, y) and
    r.charSet(start, end)
  ) and
  /* Exclude � as we use it for any unencodable character */
  char != "�" and
  //Ignore whitespace in verbose mode
  not (
    r.getAMode() = "VERBOSE" and
    char in [" ", "\t", "\r", "\n"]
  )
}

from RegExp r, string char
where duplicate_char_in_class(r, char)
select r,
  "This regular expression includes duplicate character '" + char + "' in a set of characters."
