/**
 * Phase -1 of the dataflow CFG migration: verifies that every variable
 * binding visible to the AST (`Name.defines(v)`) corresponds to a CFG node
 * in the new CFG (`semmle.python.controlflow.internal.AstNodeImpl`).
 *
 * The expected tag is `cfgdefines=<name>`. Each binding annotation in the
 * test sources looks like `# $ cfgdefines=x` for a binding currently
 * covered by the new CFG, or `# $ MISSING: cfgdefines=x` for a binding
 * that is known to be uncovered (a "red" test case that should be
 * green-flipped once the corresponding `cfg-ext-*` extension lands).
 *
 * Parameters (`def f(x):` etc.) are deliberately excluded — Java's
 * pattern handles parameter writes at the SSA layer (`hasEntryDef`),
 * not as CFG nodes.
 */

import python
import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
import utils.test.InlineExpectationsTest

module CfgBindingsTest implements TestSig {
  string getARelevantTag() { result = "cfgdefines" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Name n, Variable v, CfgImpl::ControlFlowNode cfg |
      n.defines(v) and
      not py_expr_contexts(_, 4, n) and // exclude parameters
      cfg.getAstNode().asExpr() = n and
      location = n.getLocation() and
      element = n.toString() and
      tag = "cfgdefines" and
      value = v.getId()
    )
  }
}

import MakeTest<CfgBindingsTest>
