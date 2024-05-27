import javascript

class InlineTest extends LineComment {
  string tests;

  InlineTest() { tests = this.getText().regexpCapture("\\s*test:(.*)", 1) }

  string getPositiveTest() {
    result = tests.trim().splitAt(",").trim() and not result.matches("!%")
  }

  predicate hasPositiveTest(string test) { test = this.getPositiveTest() }

  predicate inNode(DataFlow::Node n) {
    this.getLocation().getFile() = n.getFile() and
    this.getLocation().getStartLine() = n.getStartLine()
  }
}

import experimental.semmle.javascript.Execa

query predicate passingPositiveTests(string res, string expectation, InlineTest t) {
  res = "PASSED" and
  t.hasPositiveTest(expectation) and
  expectation = "CommandInjection" and
  exists(SystemCommandExecution n |
    t.inNode(n.getArgumentList()) or t.inNode(n.getACommandArgument())
  )
}

query predicate failingPositiveTests(string res, string expectation, InlineTest t) {
  res = "FAILED" and
  t.hasPositiveTest(expectation) and
  expectation = "CommandInjection" and
  not exists(SystemCommandExecution n |
    t.inNode(n.getArgumentList()) or t.inNode(n.getACommandArgument())
  )
}
