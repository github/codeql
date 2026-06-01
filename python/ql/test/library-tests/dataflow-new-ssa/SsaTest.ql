/**
 * Inline-expectations test for the new-CFG SSA adapter
 * (`semmle.python.dataflow.new.internal.SsaImpl`).
 *
 * Tags:
 *   - `def=<var>`: there is an SSA write definition of `<var>` at this
 *     line (parameter init, plain assignment, augmented assignment,
 *     exception-handler binding, deletion, etc.).
 *   - `use=<var>`: `<var>` is used at this line, and some SSA definition
 *     of `<var>` reaches the read.
 *   - `phi=<var>`: there is an SSA phi definition of `<var>` whose BB
 *     starts on this line.
 */

import python
import semmle.python.dataflow.new.internal.SsaImpl as SsaImpl
import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
import semmle.python.controlflow.internal.Cfg as Cfg
import utils.test.InlineExpectationsTest

module SsaTest implements TestSig {
  string getARelevantTag() { result = ["def", "use", "phi"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    // A `def=<id>` fires when an SSA WriteDefinition is at a CFG node
    // on the given line.
    exists(SsaImpl::Ssa::WriteDefinition def, CfgImpl::BasicBlock bb, int i, Cfg::NameNode n |
      def.definesAt(_, bb, i) and
      bb.getNode(i) = n and
      tag = "def" and
      location = n.getLocation() and
      element = n.toString() and
      value = n.getId()
    )
    or
    // A `use=<id>` fires when an SSA Definition reaches a read at this
    // CFG node.
    exists(SsaImpl::Ssa::Definition def, CfgImpl::BasicBlock bb, int i, Cfg::NameNode n |
      SsaImpl::Ssa::ssaDefReachesRead(_, def, bb, i) and
      bb.getNode(i) = n and
      tag = "use" and
      location = n.getLocation() and
      element = n.toString() and
      value = n.getId()
    )
    or
    // A `phi=<id>` fires when there is a phi node whose BB's first
    // CFG node is on the given line.
    exists(SsaImpl::Ssa::PhiNode phi, CfgImpl::BasicBlock bb |
      phi.definesAt(_, bb, _) and
      tag = "phi" and
      location = bb.getNode(0).getLocation() and
      element = bb.toString() and
      value = phi.getSourceVariable().(SsaImpl::SsaSourceVariable).getVariable().getId()
    )
  }
}

import MakeTest<SsaTest>
