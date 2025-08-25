import java
import semmle.code.java.regex.RegexTreeView as RegexTreeView
import semmle.code.java.regex.regex as Regex

string getQLClases(RegexTreeView::RegExpTerm t) {
  result = "[" + strictconcat(t.getPrimaryQLClass(), ",") + "]"
}

query predicate parseFailures(Regex::Regex r, int i) { r.failedToParse(i) }

query predicate modes(Regex::Regex r, string modes) { modes = strictconcat(r.getAMode(), ",") }

from RegexTreeView::RegExpTerm t
select t, getQLClases(t)
