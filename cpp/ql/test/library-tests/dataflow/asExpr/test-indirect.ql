import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.new.DataFlow::DataFlow

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

string formatNumberOfNodesForIndirectExpr(Expr e) {
  exists(int n | n = strictcount(Node node | node.asIndirectExpr() = e) |
    n > 1 and result = ": " + n
  )
}

module AsIndirectExprTest implements TestSig {
  string getARelevantTag() { result = ["asIndirectExpr", "numberOfIndirectNodes"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node n, Expr e, string exprString |
      e = n.asIndirectExpr() and
      location = e.getLocation() and
      element = n.toString() and
      exprString = e.toString()
    |
      tag = "asIndirectExpr" and
      (
        // The toString on an indirect is often formatted like `***myExpr`.
        // If the node's `toString` is of that form then we don't show it in
        // the expected output.
        if element.matches("%" + exprString)
        then value = quote(exprString)
        else value = quote(exprString + "(" + element + ")")
      )
      or
      tag = "numberOfIndirectNodes" and
      value = quote(exprString + formatNumberOfNodesForIndirectExpr(e))
    )
  }
}

import MakeTest<AsIndirectExprTest>
