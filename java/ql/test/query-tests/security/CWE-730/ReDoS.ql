import java
import TestUtilities.InlineExpectationsTest
private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView> as ExponentialBackTracking
import semmle.code.java.regex.regex

module HasExpRedos implements TestSig {
  string getARelevantTag() { result = ["hasExpRedos", "hasParseFailure"] }

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
}

import MakeTest<HasExpRedos>
