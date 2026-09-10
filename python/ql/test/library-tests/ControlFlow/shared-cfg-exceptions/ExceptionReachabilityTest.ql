/**
 * Inline-expectations test for exception-handler reachability in the shared CFG.
 */

import python
import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
import semmle.python.controlflow.internal.Cfg as Cfg
import utils.test.InlineExpectationsTest

module ExceptionReachabilityTest implements TestSig {
  string getARelevantTag() { result = "exception-handler" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      Expr source, ExceptStmt handler, Cfg::ControlFlowNode sourceCfg,
      Cfg::ControlFlowNode handlerEntry
    |
      sourceCfg.getNode() = source and
      handlerEntry = sourceCfg.getAnExceptionalSuccessor() and
      CfgImpl::astNodeToPyNode(handlerEntry.getAstNode()) = handler and
      location = source.getLocation() and
      element = source.toString() and
      tag = "exception-handler" and
      value = handler.getType().toString()
    )
  }
}

import MakeTest<ExceptionReachabilityTest>
