import java
import semmle.code.java.dataflow.DataFlow
import TestUtilities.InlineExpectationsTest

module TheQuery {
  import semmle.code.java.Type
  import semmle.code.java.Expr
  import semmle.code.java.Statement
  import semmle.code.java.JDK

  /**
   * An assignment of the form
   *
   * ```
   *   v = ... + ... v ...
   * ```
   * or
   *
   * ```
   *   v += ...
   * ```
   * where `v` is a simple variable (and not, for example,
   * an array element).
   */
  predicate useAndDef(Assignment a, Variable v) {
    a.getDest() = v.getAnAccess() and
    v.getType() instanceof TypeString and
    (
      a instanceof AssignAddExpr
      or
      exists(VarAccess use | use.getVariable() = v | use.getParent*() = a.getSource()) and
      a.getSource() instanceof AddExpr
    )
  }

  /**
   * Holds if `e` is executed often in loop `loop`.
   */
  predicate executedOften(Assignment a) {
    a.getDest().getType() instanceof TypeString and
    exists(ControlFlowNode n | a.getControlFlowNode() = n | getADeepSuccessor(n) = n)
  }

  /** Gets a sucessor of `n`, also following function calls. */
  ControlFlowNode getADeepSuccessor(ControlFlowNode n) {
    result = n.getASuccessor+()
    or
    exists(Call c, ControlFlowNode callee | c.(Expr).getControlFlowNode() = n.getASuccessor+() |
      callee = c.getCallee().getBody().getControlFlowNode() and
      result = getADeepSuccessor(callee)
    )
  }

  predicate queryResult(Assignment a) {
    exists(Variable v |
      useAndDef(a, v) and
      executedOften(a)
    )
  }
}

// module Config implements DataFlow::ConfigSig {
//   predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }
//   predicate isSink(DataFlow::Node n) {
//     exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
//   }
// }
// module Flow = DataFlow::Global<Config>;
module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "loopConcat" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "loopConcat" and
    exists(Assignment a | TheQuery::queryResult(a) |
      location = a.getLocation() and
      element = a.toString() and
      value = a.getDest().toString()
    )
  }
}

import MakeTest<HasFlowTest>
