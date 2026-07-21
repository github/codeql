/**
 * Reports per-term location info for each regex term, showing the literal's
 * start column, the term's value offsets, and the computed start/end columns.
 * Used to verify that `hasLocationInfo` produces correct columns for plain,
 * raw, and encoding-prefixed C++ string literals.
 *
 * Commit 8 captures pre-fix (wrong) columns for raw/prefixed literals.
 * Commit 9 fixes them; plain "..." rows must remain unchanged.
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView as RE

query predicate locations(
  RE::RegExpTerm t,
  int litStartCol,
  int valueStart,
  int valueEnd,
  int termStartCol,
  int termEndCol
) {
  // Only report terms from the location test function (test_locations)
  // to keep the output focused.
  t.getRegExp().getLocation().getStartLine() >= 142 and // test_locations starts here
  t.getRegExp().getLocation().hasLocationInfo(_, _, litStartCol, _, _) and
  valueStart = t.getStart() and
  valueEnd = t.getEnd() and
  t.hasLocationInfo(_, _, termStartCol, _, termEndCol)
}
