import python
import semmle.python.regexp.RegexTreeView::RegexTreeView
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

module RegexLocationTest implements TestSig {
  string getARelevantTag() { result = "location" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(Call compile, RegExpTerm t, int line, int column |
      // All the tested regexes are inside a call to `compile`
      compile.getAnArg() = t.getRegex() and
      t.toString() = "[this]" and
      t.hasLocationInfo(_, line, column, _, _)
    |
      // put the annotation on the start line of the call to `compile`
      location = compile.getFunc().getLocation() and
      element = t.toString() and
      // show the (relative) line and column for the fragment
      value = (line - location.getStartLine()).toString() + ":" + column.toString() and
      tag = "location"
    )
  }
}

import MakeTest<RegexLocationTest>
