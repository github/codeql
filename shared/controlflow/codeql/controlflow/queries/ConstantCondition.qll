/**
 * Provides a query for detecting constant conditions.
 */
overlay[local?]
module;

private import codeql.controlflow.BasicBlock as BB
private import codeql.util.Location

private signature class TypSig;

signature module InputSig<TypSig BasicBlock> {
  class SsaDefinition;

  /** An abstract value that a `Guard` may evaluate to. */
  class GuardValue {
    /** Gets a textual representation of this value. */
    string toString();

    /**
     * Gets the dual value. Examples of dual values include:
     * - null vs. not null
     * - true vs. false
     * - evaluating to a specific value vs. evaluating to any other value
     * - throwing an exception vs. not throwing an exception
     */
    GuardValue getDualValue();

    /** Holds if this value represents throwing an exception. */
    predicate isThrowsException();
  }

  /**
   * A guard. This may be any expression whose value determines subsequent
   * control flow. It may also be a switch case, which as a guard is considered
   * to evaluate to either true or false depending on whether the case matches.
   */
  class Guard {
    /** Gets a textual representation of this guard. */
    string toString();

    /**
     * Holds if this guard evaluating to `v` corresponds to taking the edge
     * from `bb1` to `bb2`. For ordinary conditional branching this guard is
     * the last node in `bb1`, but for switch case matching it is the switch
     * expression, which may either be in `bb1` or an earlier basic block.
     */
    predicate hasValueBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue v);
  }

  /**
   * Holds if `def` evaluating to `v` controls the control-flow branch
   * edge from `bb1` to `bb2`. That is, following the edge from `bb1` to
   * `bb2` implies that `def` evaluated to `v`.
   */
  predicate ssaControlsBranchEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, GuardValue v);

  /**
   * Holds if `def` evaluating to `v` controls the basic block `bb`.
   * That is, execution of `bb` implies that `def` evaluated to `v`.
   */
  predicate ssaControls(SsaDefinition def, BasicBlock bb, GuardValue v);

  bindingset[gv1, gv2]
  predicate disjointValues(GuardValue gv1, GuardValue gv2);
}

module Make<LocationSig Location, BB::CfgSig<Location> Cfg, InputSig<Cfg::BasicBlock> Input> {
  private import Cfg
  private import Input

  private predicate ssaControlsGuardEdge(
    SsaDefinition def, GuardValue v, Guard g, BasicBlock bb1, BasicBlock bb2, GuardValue gv
  ) {
    g.hasValueBranchEdge(bb1, bb2, gv) and
    ssaControlsBranchEdge(def, bb1, bb2, v)
  }

  /** Holds if `g` cannot have value `gv` in `bb` due to `def` controlling `bb` with value `v2`. */
  pragma[nomagic]
  private predicate impossibleValue(
    Guard g, GuardValue gv, SsaDefinition def, BasicBlock bb, GuardValue v2
  ) {
    exists(GuardValue dual, GuardValue v1 |
      // If `g` in `bb` evaluates to `gv` then `def` has value `v1`,
      ssaControlsGuardEdge(def, v1, g, bb, _, gv) and
      dual = gv.getDualValue() and
      not gv.isThrowsException() and
      not dual.isThrowsException() and
      // but `def` controls `bb` with value `v2` via some guard,
      ssaControls(def, bb, v2) and
      // and `v1` and `v2` are disjoint so `g` cannot be `gv`.
      disjointValues(v1, v2)
    )
  }

  query predicate problems(Guard g, string msg, Guard reason, string reasonMsg) {
    exists(
      BasicBlock bb, GuardValue gv, SsaDefinition def, GuardValue v2, BasicBlock bb1, BasicBlock bb2
    |
      // `g` cannot have value `gv` in `bb` due to `def` controlling `bb` with value `v2`,
      impossibleValue(g, gv, def, bb, v2) and
      // and this is because of `reason` taking the branch `bb1` to `bb2`,
      ssaControlsGuardEdge(def, v2, reason, bb1, bb2, _) and
      dominatingEdge(bb1, bb2) and
      bb2.dominates(bb) and
      msg = "Condition is always " + gv.getDualValue() + " because of $@." and
      reasonMsg = reason.toString()
    )
  }
}
