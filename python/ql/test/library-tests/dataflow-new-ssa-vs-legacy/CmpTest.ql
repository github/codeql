/**
 * Compares the new-CFG SSA against the legacy ESSA on the same Python
 * sources. Reports definitions present in one implementation but not
 * the other, identified by variable name + source position.
 *
 * The `.expected` file records the current diff as a snapshot: as the
 * new SSA matures (closing captured-variable gap, exception bindings,
 * etc.) and tracks more variables, the snapshot should monotonically
 * shrink.
 *
 * Known categories of `def-only-old` mismatches:
 *   - Function / class / global definitions with no in-scope read
 *     (intentional: SSA is liveness-pruned, write-only variables are
 *     not tracked).
 *   - Captured / closure variables (gap: new SSA does not yet model
 *     closure captures).
 *   - Module variables `__name__`, `__package__`, `$` (legacy ESSA
 *     adds implicit bindings the new SSA does not).
 *   - Exception-handler `as` bindings (depend on raise modelling).
 *
 * `def-only-new` mismatches would indicate the new SSA produces spurious
 * definitions; currently none are expected.
 */

import python
import semmle.python.dataflow.new.internal.SsaImpl as NewSsa
import semmle.python.controlflow.internal.Cfg as Cfg
import semmle.python.essa.Essa

string newDefSig(NewSsa::EssaNodeDefinition def) {
  exists(Cfg::ControlFlowNode n | n = def.getDefiningNode() |
    result =
      def.getVariable().getVariable().getId() + ":" + n.getLocation().getStartLine() + ":" +
        n.getLocation().getStartColumn()
  )
}

string legacyDefSig(EssaNodeDefinition def) {
  exists(ControlFlowNode n | n = def.getDefiningNode() |
    result =
      def.getSourceVariable().getName() + ":" + n.getLocation().getStartLine() + ":" +
        n.getLocation().getStartColumn()
  )
}

from string kind, string sig
where
  kind = "def-only-new" and
  exists(NewSsa::EssaNodeDefinition def |
    sig = newDefSig(def) and
    not exists(EssaNodeDefinition legacyDef | sig = legacyDefSig(legacyDef))
  )
  or
  kind = "def-only-old" and
  exists(EssaNodeDefinition legacyDef |
    sig = legacyDefSig(legacyDef) and
    not exists(NewSsa::EssaNodeDefinition def | sig = newDefSig(def))
  )
select kind, sig
