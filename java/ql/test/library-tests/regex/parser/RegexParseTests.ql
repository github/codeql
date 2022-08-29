import java
import semmle.code.java.regex.RegexTreeView
import semmle.code.java.regex.regex

string getQLClases(RegExpTerm t) { result = "[" + strictconcat(t.getPrimaryQLClass(), ",") + "]" }

query predicate parseFailures(Regex r, int i) { r.failedToParse(i) }

from RegExpTerm t
select t, getQLClases(t)
