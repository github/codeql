import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.new.DataFlow::DataFlow

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

string formatNumberOfNodesForExpr(Expr e) {
  exists(int n | n = strictcount(Node node | node.asExpr() = e) | n > 1 and result = ": " + n)
}

module AsExprTest implements TestSig {
  string getARelevantTag() { result = ["asExpr", "numberOfNodes"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node n, Expr e, string exprString |
      e = n.asExpr() and
      location = e.getLocation() and
      element = n.toString() and
      exprString = e.toString()
    |
      tag = "asExpr" and
      (
        // If the `toString` on the node is identical to the `toString` of the
        // expression then we don't show it in the expected output.
        if exprString = element
        then value = quote(exprString)
        else value = quote(exprString + "(" + element + ")")
      )
      or
      tag = "numberOfNodes" and
      value = quote(exprString + formatNumberOfNodesForExpr(e))
    )
  }
}

import MakeTest<AsExprTest>
