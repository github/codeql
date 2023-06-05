import swift
import codeql.swift.regex.Regex
import TestUtilities.InlineExpectationsTest

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module RegexTest implements TestSig {
  string getARelevantTag() { result = ["regex", "input"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RegexEval eval, Expr regex |
      eval.getRegex() = regex and
      location = regex.getLocation() and
      element = regex.toString() and
      tag = "regex" and
      value = quote(regex.toString())
    )
    or
    exists(RegexEval eval, Expr input |
      eval.getInput() = input and
      location = input.getLocation() and
      element = input.toString() and
      tag = "input" and
      value = quote(input.toString())
    )
  }
}

import MakeTest<RegexTest>
