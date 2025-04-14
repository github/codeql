import utils.test.InlineExpectationsTest
import cpp

module AstTest {
  private import semmle.code.cpp.dataflow.DataFlow::DataFlow
  private import semmle.code.cpp.dataflow.internal.DataFlowPrivate

  module AstParameterDefTest implements TestSig {
    string getARelevantTag() { result = "ast-def" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Function f, Parameter p, RefParameterFinalValueNode n |
        p.isNamed() and
        n.getParameter() = p and
        n.getFunction() = f and
        location = f.getLocation() and
        element = p.toString() and
        tag = "ast-def" and
        value = p.getName()
      )
    }
  }
}

module IRTest {
  private import semmle.code.cpp.ir.dataflow.DataFlow
  private import semmle.code.cpp.ir.dataflow.internal.DataFlowUtil

  private string stars(int k) {
    k = [0 .. max(FinalParameterNode n | | n.getIndirectionIndex())] and
    (if k = 0 then result = "" else result = "*" + stars(k - 1))
  }

  module IRParameterDefTest implements TestSig {
    string getARelevantTag() { result = "ir-def" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Function f, Parameter p, FinalParameterNode n |
        p.isNamed() and
        n.getParameter() = p and
        n.getFunction() = f and
        location = f.getLocation() and
        element = p.toString() and
        tag = "ir-def" and
        value = stars(n.getIndirectionIndex()) + p.getName()
      )
    }
  }
}

import MakeTest<MergeTests<AstTest::AstParameterDefTest, IRTest::IRParameterDefTest>>
