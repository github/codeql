import swift
import codeql.swift.regex.Regex
private import codeql.swift.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.ExponentialBackTracking::Make<TreeView>
import TestUtilities.InlineExpectationsTest

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module RegexTest implements TestSig {
  string getARelevantTag() { result = ["regex", "input", "redos-vulnerable"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TreeView::RegExpTerm t, string pump, State s, string prefixMsg |
      hasReDoSResult(t, pump, s, prefixMsg) and
      location = t.getLocation() and
      element = t.toString() and
      tag = "redos-vulnerable" and
      value = ""
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
    exists(RegexEval eval, Expr regex |
      eval.getARegex() = regex and
      location = eval.getLocation() and
      element = eval.toString() and
      tag = "regex" and
      value = quote(regex.toString())
    )
    }
}

import MakeTest<RegexTest>
