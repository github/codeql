/**
 * @kind problem
 */

import ruby
import codeql.ruby.security.IncompleteMultiCharacterSanitizationQuery as Query
import codeql.ruby.frameworks.core.String
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
  exists(
    StringSubstitutionCall replace, Query::EmptyReplaceRegExpTerm dangerous, string prefix,
    string kind
  |
    replace.getLocation() = location and
    element = replace.toString() and
    value = shortKind(kind)
  |
    Query::hasResult(replace, dangerous, prefix, kind)
  )
}

bindingset[kind]
string shortKind(string kind) {
  kind = "HTML element injection" and result = "html"
  or
  kind = "path injection" and result = "path"
  or
  kind = "HTML attribute injection" and result = "attr"
}
