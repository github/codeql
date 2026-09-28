/**
 * Location test for the C++ regex parse-tree view: for each `RegExpTerm`
 * reports its rendered text, primary QL class, source location components
 * (as reported by `hasLocationInfo`), the enclosing string literal's start
 * column and the term's value-offsets within the literal. Rows are ordered
 * deterministically to keep the snapshot stable.
 *
 * Modeled on `python/ql/test/library-tests/regexparser/Locations.ql`, adapted
 * to C++.
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView

from
  RegExpTerm t, string filepath, int startline, int startcolumn, int endline, int endcolumn,
  int literalStartColumn, int termStart, int termEnd, string label, string cls
where
  t.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
  literalStartColumn = t.getRegex().getLocation().getStartColumn() and
  termStart = t.getStart() and
  termEnd = t.getEnd() and
  label = t.toString() and
  cls = t.getAPrimaryQlClass()
select label, cls, filepath, startline, startcolumn, endline, endcolumn, literalStartColumn,
  termStart, termEnd order by filepath, startline, startcolumn, endcolumn, label
