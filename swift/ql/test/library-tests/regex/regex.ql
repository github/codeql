import swift
import codeql.swift.regex.Regex
private import codeql.swift.regex.internal.ParseRegex
private import codeql.swift.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView>
import utils.test.InlineExpectationsTest

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module RegexTest implements TestSig {
  string getARelevantTag() {
    result = ["regex", "unevaluated-regex", "input", "redos-vulnerable", "hasParseFailure", "modes"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TreeView::RegExpTerm t |
      hasReDoSResult(t, _, _, _) and
      location = t.getLocation() and
      element = t.toString() and
      tag = "redos-vulnerable" and
      value = ""
    )
    or
    exists(RegexEval eval, RegExp regex |
      eval.getARegex() = regex and
      regex.failedToParse(_) and
      location = eval.getLocation() and
      element = eval.toString() and
      tag = "hasParseFailure" and
      value = ""
    )
    or
    exists(RegexEval eval, RegExp regex |
      eval.getARegex() = regex and
      location = eval.getLocation() and
      element = eval.toString() and
      tag = "modes" and
      value = quote(regex.getFlags()) and
      value != ""
    )
    or
    exists(RegexEval eval, RegExp regex |
      eval.getARegex() = regex and
      location = eval.getLocation() and
      element = eval.toString() and
      tag = "regex" and
      value = quote(regex.toString().replaceAll("\n", "NEWLINE"))
    )
    or
    exists(RegExp regex |
      // unevaluated regex
      not exists(RegexEval eval | eval.getARegex() = regex) and
      location = regex.getLocation() and
      element = regex.toString() and
      tag = "unevaluated-regex" and
      value = quote(regex.toString().replaceAll("\n", "NEWLINE"))
    )
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(RegexEval eval, Expr input |
      eval.getStringInputNode().asExpr() = input and
      location = input.getLocation() and
      element = input.toString() and
      tag = "input" and
      value = quote(input.toString())
    )
  }
}

import MakeTest<RegexTest>
