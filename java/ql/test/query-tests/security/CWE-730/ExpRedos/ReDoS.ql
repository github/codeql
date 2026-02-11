import java
import utils.test.InlineExpectationsTest
private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView> as ExponentialBackTracking
import semmle.code.java.regex.regex

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module HasExpRedos implements TestSig {
  string getARelevantTag() {
    result = ["hasExpRedos", "hasParseFailure", "hasPump", "hasPrefixMsg"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasExpRedos" and
    exists(TreeView::RegExpTerm t |
      ExponentialBackTracking::hasReDoSResult(t, _, _, _) and
      not t.getRegex().getAMode() = "VERBOSE" and
      value = "" and
      location = t.getLocation() and
      element = t.toString()
    )
    or
    tag = "hasParseFailure" and
    exists(Regex r |
      r.failedToParse(_) and
      value = "" and
      location = r.getLocation() and
      element = r.toString()
    )
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(TreeView::RegExpTerm t, Regex r, string pump, string prefixMsg |
      ExponentialBackTracking::hasReDoSResult(t, pump, _, prefixMsg) and
      t.occursInRegex(r, _, _) and
      (
        tag = "hasPrefixMsg" and
        value = quote(prefixMsg)
        or
        tag = "hasPump" and
        value = pump
      ) and
      location = r.getLocation() and
      element = r.toString()
    )
  }
}

import MakeTest<HasExpRedos>
