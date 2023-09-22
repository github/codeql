import semmle.python.regexp.RegexTreeView::RegexTreeView

from RegExpTerm t, string file, int line, int column
where
  t.toString() = "[this]" and
  t.hasLocationInfo(file, line, column, _, _)
select file, line, column
