/**
 * @kind problem
 */

import codeql.ruby.AST
import codeql.ruby.regexp.RegExpTreeView as RETV
import codeql.ruby.DataFlow
import codeql.ruby.security.IncompleteMultiCharacterSanitizationQuery as Query
import TestUtilities.InlineExpectationsTest

class Test extends InlineExpectationsTest {
  Test() { this = "IncompleteMultiCharacterSanitizationTest" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasResult" and
    hasResult(location, element, value)
  }
}

predicate hasResult(Location location, string element, string value) {
  exists(DataFlow::Node replace, string kind |
    replace.getLocation() = location and
    element = replace.toString() and
    value = shortKind(kind)
  |
    Query::isResult(replace, _, _, kind)
  )
}

bindingset[kind]
string shortKind(string kind) {
  kind = "an HTML element injection vulnerability" and result = "html"
  or
  kind = "a path injection vulnerability" and result = "path"
  or
  kind = "an HTML attribute injection vulnerability" and result = "attr"
}
