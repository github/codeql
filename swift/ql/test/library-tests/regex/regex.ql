import swift
import codeql.swift.regex.Regex
private import codeql.swift.regex.internal.ParseRegex
private import codeql.swift.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView>
import TestUtilities.InlineExpectationsTest

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module RegexTest implements TestSig {
  string getARelevantTag() {
    result = ["regex", "input", "redos-vulnerable", "hasParseFailure", "modes"]
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
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(RegexEval eval, Expr input |
      eval.getStringInput() = input and
      location = input.getLocation() and
      element = input.toString() and
      tag = "input" and
      value = quote(input.toString())
    )
    or
    exists(RegexEval eval, RegExp regex |
      eval.getARegex() = regex and
      location = eval.getLocation() and
      element = eval.toString() and
      tag = "regex" and
      value = quote(regex.toString().replaceAll("\n", "NEWLINE"))
    )
  }
}

import MakeTest<RegexTest>
