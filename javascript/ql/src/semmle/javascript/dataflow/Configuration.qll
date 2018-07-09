/**
 * Provides a class for performing customized inter-procedural data flow.
 *
 * The class in this module provides an interface for performing inter-procedural
 * data flow from a custom set of source nodes to a custom set of sink nodes.
 * Additional data flow edges can be specified, and conversely certain nodes or
 * edges can be designated as _barriers_ that block flow.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 *
 *
 * # Technical overview
 *
 * This module implements a summarization-based inter-procedural data flow
 * analysis. Data flow is tracked through local variables, imports and (some)
 * object properties, as well as into and out of function calls. The latter
 * is done by computing function summaries that record which function parameters
 * and captured variables may flow into the function's return value.
 *
 * For example, for the function
 *
 * ```
 * function choice(b, x, y) {
 *   return b ? x : y;
 * }
 * ```
 *
 * we determine that its second and third (but not the first) parameter may
 * flow into its return value.
 *
 * Hence when we see a call `a = choice(b, c, d)`, we propagate flow from `c`
 * to `a` and from `d` to `a` (but not from `b` to `a`).
 *
 * The inter-procedural data flow graph is represented by class `PathNode`
 * and its member predicate `getASuccessor`. Each `PathNode` is a pair
 * of an underlying `DataFlow::Node` and a `DataFlow::Configuration`, which
 * can be accessed through member predicates `getNode` and `getConfiguration`,
 * respectively.
 *
 * # Implementation details
 *
 * Overall, flow is tracked forwards, starting at the sources and looking
 * for an inter-procedural path to a sink.
 *
 * Function summaries are computed by predicate `flowThroughCall`.
 * Predicate `flowStep` computes a "one-step" flow relation, where, however,
 * a single step may be based on a function summary, and hence already involve
 * inter-procedural flow.
 *
 * Flow steps are classified as being "call", "return" or "level": a call step
 * goes from an argument to a parameter, an return step from a return to a caller,
 * and a level step is either a step that does not involve function calls
 * or a step through a summary.
 *
 * Predicate `reachableFromSource` computes inter-procedural paths from
 * sources along the `flowStep` relation, keeping track of whether any of
 * these steps is a call step. Return steps are only allowed if no previous
 * step was a call step to avoid confusion between different call sites.
 *
 * Predicate `onPath` builds on `reachableFromSource` to compute full
 * paths from sources to sinks, this time starting with the sinks. Similar
 * to above, it keeps track of whether any of the steps from a node to a
 * sink is a return step, and only considers call steps for paths that do
 * not contain a return step.
 *
 * Finally, we build `PathNode`s for all nodes that appear on a path
 * computed by `onPath`.
 */

import javascript
private import internal.FlowSteps

/**
 * A data flow tracking configuration for finding inter-procedural paths from
 * sources to sinks.
 *
 * Each use of the data flow tracking library must define its own unique extension
 * of this abstract class. A configuration defines a set of relevant sources
 * (`isSource`) and sinks (`isSink`), and may additionally
 * define additional edges beyond the standard data flow edges (`isAdditionalFlowStep`)
 * and prohibit intermediate flow nodes and edges (`isBarrier`).
 */
abstract class Configuration extends string {
  bindingset[this]
  Configuration() { any() }

  /**
   * Holds if `source` is a relevant data flow source for this configuration.
   */
  abstract predicate isSource(DataFlow::Node source);

  /**
   * Holds if `sink` is a relevant data flow sink for this configuration.
   */
  abstract predicate isSink(DataFlow::Node sink);

  /**
   * Holds if `source -> sink` should be considered as a flow edge
   * in addition to standard data flow edges.
   */
  predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) { none() }

  /**
   * INTERNAL: This predicate should not normally be used outside the data flow
   * library.
   *
   * Holds if `source -> sink` should be considered as a flow edge
   * in addition to standard data flow edges, with `valuePreserving`
   * indicating whether the step preserves values or just taintedness.
   */
  predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg, boolean valuePreserving) {
    isAdditionalFlowStep(src, trg) and valuePreserving = true
  }

  /**
   * Holds if the intermediate flow node `node` is prohibited.
   */
  predicate isBarrier(DataFlow::Node node) {
    exists (BarrierGuardNode guard |
      isBarrierGuard(guard) and
      guard.blocks(node)
    )
  }

  /**
   * Holds if flow from `src` to `trg` is prohibited.
   */
  predicate isBarrier(DataFlow::Node src, DataFlow::Node trg) { none() }

  /**
   * Holds if data flow node `guard` can act as a barrier when appearing
   * in a condition.
   *
   * For example, if `guard` is the comparison expression in
   * `if(x == 'some-constant'){ ... x ... }`, it could block flow of
   * `x` into the "then" branch.
   */
  predicate isBarrierGuard(BarrierGuardNode guard) { none() }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    isSource(_, this) and isSink(_, this) and
    exists (SourcePathNode flowsource, SinkPathNode flowsink |
      hasPathFlow(flowsource, flowsink) and
      source = flowsource.getNode() and
      sink = flowsink.getNode()
    )
  }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasPathFlow(SourcePathNode source, SinkPathNode sink) {
    flowsTo(source, _, sink, _, this)
  }

  /**
   * DEPRECATED: Use `hasFlow` instead.
   *
   * Holds if `source` flows to `sink`.
   */
  deprecated predicate flowsTo(DataFlow::Node source, DataFlow::Node sink) {
    hasFlow(source, sink)
  }

  /**
   * DEPRECATED: Use `hasFlow` instead.
   *
   * Holds if `source` flows to `sink`.
   */
  deprecated predicate flowsFrom(DataFlow::Node sink, DataFlow::Node source) {
    hasFlow(source, sink)
  }
}

/**
 * A node that can act as a barrier when appearing in a condition.
 *
 * To use this barrier in `Configuration` `cfg`, add this barrier to the
 * extent of `cfg.isBarrierGuard`.
 */
abstract class BarrierGuardNode extends DataFlow::Node {

  /**
   * Holds if data flow node `nd` acts as a barrier for data flow.
   *
   * INTERNAL: this predicate should only be used from within `blocks(boolean, Expr)`.
   */
  predicate blocks(DataFlow::Node nd) {
    // 1) `nd` is a use of a refinement node that blocks its input variable
    exists (SsaRefinementNode ref |
      nd = DataFlow::ssaDefinitionNode(ref) and
      forex (SsaVariable input | input = ref.getAnInput() |
        asExpr() = ref.getGuard().getTest() and
        blocks(ref.getGuard().(ConditionGuardNode).getOutcome(), input.getAUse())
      )
    )
    or
    // 2) `nd` is a use of an SSA variable `ssa`, and dominated by a barrier for `ssa`
    exists (SsaVariable ssa, BasicBlock bb |
      nd = DataFlow::valueNode(ssa.getAUseIn(bb)) and
      exists (ConditionGuardNode cond |
        asExpr() = cond.getTest() and
        blocks(cond.getOutcome(), ssa.getAUse()) and
        cond.dominates(bb)
      )
    )
    or
    // 3) `nd` is a property access `ssa.p.q` on an SSA variable `ssa`, and dominated by
    // a barrier for `ssa.p.q`
    exists (SsaVariable ssa, string props, BasicBlock bb |
      nd = DataFlow::valueNode(nestedPropAccessOnSsaVar(ssa, props)) and
      bb = nd.getBasicBlock() |
      exists (ConditionGuardNode cond |
        asExpr() = cond.getTest() and
        blocks(cond.getOutcome(), nestedPropAccessOnSsaVar(ssa, props)) and
        cond.dominates(bb)
      )
    )
  }

  /**
   * Holds if this node blocks expression `e` provided it evaluates to `outcome`.
   */
  abstract predicate blocks(boolean outcome, Expr e);

}

/**
 * Holds if `props` is a string of the form `p.q.r`, and the result is a property access
 * of the form `v.p.q.r`.
 */
private DotExpr nestedPropAccessOnSsaVar(SsaVariable v, string props) {
  exists (Expr base, string prop | result.accesses(base, prop) |
    base = v.getAUse() and props = prop
    or
    exists (string prevProps |
      base = nestedPropAccessOnSsaVar(v, prevProps) and
      props = prevProps + "." + prop
    )
  )
}

/**
 * A data flow edge that should be added to all data flow configurations in
 * addition to standard data flow edges.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalFlowStep`
 * for analysis-specific flow steps.
 */
abstract cached class AdditionalFlowStep extends DataFlow::Node {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  abstract cached predicate step(DataFlow::Node pred, DataFlow::Node succ);
}

/**
 * A data flow node that should be considered a source for some specific configuration,
 * in addition to any other sources that configuration may recognize.
 */
abstract class AdditionalSource extends DataFlow::Node {
  /**
   * Holds if this data flow node should be considered a source node for
   * configuration `cfg`.
   */
  abstract predicate isSourceFor(Configuration cfg);
}

/**
 * A data flow node that should be considered a sink for some specific configuration,
 * in addition to any other sinks that configuration may recognize.
 */
abstract class AdditionalSink extends DataFlow::Node {
  /**
   * Holds if this data flow node should be considered a sink node for
   * configuration `cfg`.
   */
  abstract predicate isSinkFor(Configuration cfg);
}

/**
 * Additional flow step to model flow from import specifiers into the SSA variable
 * corresponding to the imported variable.
 */
private class FlowStepThroughImport extends AdditionalFlowStep, DataFlow::ValueNode {
  override ImportSpecifier astNode;

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists (SsaExplicitDefinition ssa |
      pred = this and
      ssa.getDef() = astNode and
      succ = DataFlow::ssaDefinitionNode(ssa)
    )
  }
}

/**
 * Holds if there is a flow step from `pred` to `succ` described by `summary`
 * under configuration `cfg`.
 *
 * Summary steps through function calls are not taken into account.
 */
private predicate basicFlowStep(DataFlow::Node pred, DataFlow::Node succ, PathSummary summary,
                                DataFlow::Configuration cfg) {
  isRelevantForward(pred, cfg) and
  (
   // Local flow
   exists (boolean valuePreserving |
     localFlowStep(pred, succ, cfg, valuePreserving) and
     summary = PathSummary::level(valuePreserving)
   )
   or
   // Flow through properties of objects
   propertyFlowStep(pred, succ) and
   summary = PathSummary::level(true)
   or
   // Flow through global variables
   globalFlowStep(pred, succ) and
   summary = PathSummary::level(true)
   or
   // Flow into function
   callStep(pred, succ) and
   summary = PathSummary::call(true)
   or
   // Flow out of function
   returnStep(pred, succ) and
   summary = PathSummary::return(true)
  )
}

/**
 * Holds if there is a flow step from `pred` to `succ` under configuration `cfg`,
 * including both basic flow steps and steps into/out of properties.
 *
 * This predicate is field insensitive (it does not distinguish between `x` and `x.p`)
 * and hence should only be used for purposes of approximation.
 */
private predicate exploratoryFlowStep(DataFlow::Node pred, DataFlow::Node succ,
                                      DataFlow::Configuration cfg) {
  basicFlowStep(pred, succ, _, cfg) or
  basicStoreStep(pred, succ, _) or
  loadStep(pred, succ, _)
}

/**
 * Holds if `nd` is a source node for configuration `cfg`.
 */
private predicate isSource(DataFlow::Node nd, DataFlow::Configuration cfg) {
  cfg.isSource(nd) or nd.(AdditionalSource).isSourceFor(cfg)
}

/**
 * Holds if `nd` is a sink node for configuration `cfg`.
 */
private predicate isSink(DataFlow::Node nd, DataFlow::Configuration cfg) {
  cfg.isSink(nd) or nd.(AdditionalSink).isSinkFor(cfg)
}

/**
 * Holds if `nd` may be reachable from a source under `cfg`.
 *
 * No call/return matching is done, so this is a relatively coarse over-approximation.
 */
private predicate isRelevantForward(DataFlow::Node nd, DataFlow::Configuration cfg) {
  isSource(nd, cfg)
  or
  exists (DataFlow::Node mid |
    isRelevantForward(mid, cfg) and exploratoryFlowStep(mid, nd, cfg)
  )
}

/**
 * Holds if `nd` may be on a path from a source to a sink under `cfg`.
 *
 * No call/return matching is done, so this is a relatively coarse over-approximation.
 */
private predicate isRelevant(DataFlow::Node nd, DataFlow::Configuration cfg) {
  isRelevantForward(nd, cfg) and
  isSink(nd, cfg)
  or
  exists (DataFlow::Node mid |
    isRelevant(mid, cfg) and
    exploratoryFlowStep(nd, mid, cfg) and
    isRelevantForward(nd, cfg)
  )
}

/**
 * Holds if `pred` is an input to `f` which is passed to `succ` at `invk`; that is,
 * either `pred` is an argument of `f` and `succ` the corresponding parameter, or
 * `pred` is a variable definition whose value is captured by `f` at `succ`.
 */
private predicate callInputStep(Function f, DataFlow::Node invk,
                                DataFlow::Node pred, DataFlow::Node succ,
                                DataFlow::Configuration cfg) {
  isRelevant(pred, cfg) and
  (
   exists (Parameter parm |
     argumentPassing(invk, pred, f, parm) and
     succ = DataFlow::parameterNode(parm)
   )
   or
   exists (SsaDefinition prevDef, SsaDefinition def |
     pred = DataFlow::ssaDefinitionNode(prevDef) and
     calls(invk, f) and captures(f, prevDef, def) and
     succ = DataFlow::ssaDefinitionNode(def)
   )
  ) and
  not cfg.isBarrier(succ) and
  not cfg.isBarrier(pred, succ)
}

/**
 * Holds if `input`, which is either an argument to `f` at `invk` or a definition
 * that is captured by `f`, may flow to `nd` under configuration `cfg` (possibly through
 * callees) along a path summarized by `summary`.
 *
 * Note that the summary does not take the initial step from argument to parameter
 * into account.
 */
private predicate reachableFromInput(Function f, DataFlow::Node invk,
                                     DataFlow::Node input, DataFlow::Node nd,
                                     DataFlow::Configuration cfg, PathSummary summary) {
  callInputStep(f, invk, input, nd, cfg) and
  summary = PathSummary::empty()
  or
  exists (DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
    reachableFromInput(f, invk, input, mid, cfg, oldSummary) and
    flowStep(mid, cfg, nd, newSummary) and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if a function invoked at `invk` may return an expression into which `input`,
 * which is either an argument or a definition captured by the function, flows under
 * configuration `cfg`, possibly through callees.
 */
private predicate flowThroughCall(DataFlow::Node input, DataFlow::Node invk,
                                  DataFlow::Configuration cfg, boolean valuePreserving) {
  exists (Function f, DataFlow::ValueNode ret |
    ret.asExpr() = f.getAReturnedExpr() and
    reachableFromInput(f, invk, input, ret, cfg, PathSummary::level(valuePreserving))
  )
}

/**
 * Holds if `pred` may flow into property `prop` of `succ` under configuration `cfg`
 * along a path summarized by `summary`.
 */
private predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop,
                            DataFlow::Configuration cfg, PathSummary summary) {
  basicStoreStep(pred, succ, prop) and
  summary = PathSummary::level(true)
  or
  exists (Function f, DataFlow::Node mid, DataFlow::SourceNode base |
    // `f` stores its parameter `pred` in property `prop` of a value that it returns,
    // and `succ` is an invocation of `f`
    reachableFromInput(f, succ, pred, mid, cfg, summary) and
    base.hasPropertyWrite(prop, mid) and
    base.flowsToExpr(f.getAReturnedExpr())
  )
}

/**
 * Holds if `rhs` is the right-hand side of a write to property `prop`, and `nd` is reachable
 * from the base of that write under configuration `cfg` (possibly through callees) along a
 * path summarized by `summary`.
 */
private predicate reachableFromStoreBase(string prop, DataFlow::Node rhs, DataFlow::Node nd,
                                         DataFlow::Configuration cfg, PathSummary summary) {
  isRelevant(rhs, cfg) and
  storeStep(rhs, nd, prop, cfg, summary)
  or
  exists (DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
    reachableFromStoreBase(prop, rhs, mid, cfg, oldSummary) and
    flowStep(mid, cfg, nd, newSummary) and
    newSummary.valuePreserving() = true and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if the value of `pred` is written to a property of some base object, and that base
 * object may flow into the base of property read `succ` under configuration `cfg` along
 * a path summarized by `summary`.
 *
 * In other words, `pred` may flow to `succ` through a property.
 */
private predicate flowThroughProperty(DataFlow::Node pred, DataFlow::Node succ,
                                      DataFlow::Configuration cfg, PathSummary summary) {
  exists (string prop, DataFlow::Node base |
    reachableFromStoreBase(prop, pred, base, cfg, summary) |
    loadStep(base, succ, prop)
  )
}

/**
 * Holds if there is a flow step from `pred` to `succ` described by `summary`
 * under configuration `cfg`.
*/
private predicate flowStep(DataFlow::Node pred, DataFlow::Configuration cfg,
                           DataFlow::Node succ, PathSummary summary) {
  (
   basicFlowStep(pred, succ, summary, cfg)
   or
   // Flow through a function that returns a value that depends on one of its arguments
   // or a captured variable
   exists (boolean valuePreserving |
     flowThroughCall(pred, succ, cfg, valuePreserving) and
     summary = PathSummary::level(valuePreserving)
   )
   or
   // Flow through a property write/read pair
   flowThroughProperty(pred, succ, cfg, summary)
  ) and
  not cfg.isBarrier(succ) and
  not cfg.isBarrier(pred, succ)
}

/**
 * Holds if `source` can flow to `sink` under configuration `cfg`
 * in zero or more steps.
 */
pragma [nomagic]
private predicate flowsTo(PathNode flowsource, DataFlow::Node source,
                          SinkPathNode flowsink, DataFlow::Node sink,
                          DataFlow::Configuration cfg) {
  flowsource = MkPathNode(source, cfg, _) and
  flowsink = flowsource.getASuccessor*() and
  flowsink = MkPathNode(sink, id(cfg), _)
}

/**
 * Holds if `nd` is reachable from a source under `cfg` along a path summarized by
 * `summary`.
 */
private predicate reachableFromSource(DataFlow::Node nd, DataFlow::Configuration cfg,
                                      PathSummary summary) {
  isSource(nd, cfg) and
  not cfg.isBarrier(nd) and
  summary = PathSummary::empty()
  or
  exists (DataFlow::Node pred, PathSummary oldSummary, PathSummary newSummary |
    reachableFromSource(pred, cfg, oldSummary) and
    flowStep(pred, cfg, nd, newSummary) and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if `nd` can be reached from a source under `cfg`, and in turn a sink is
 * reachable from `nd`. The path from the source to `nd` is summarized by `summary1`,
 * the path from `nd` to the sink is summarized by `summary2`.
 */
private predicate onPath(DataFlow::Node nd, DataFlow::Configuration cfg,
                         PathSummary summary1, PathSummary summary2) {
  reachableFromSource(nd, cfg, summary1) and
  isSink(nd, cfg) and
  not cfg.isBarrier(nd) and
  summary2 = PathSummary::empty()
  or
  exists (DataFlow::Node mid, PathSummary newSummary, PathSummary oldSummary |
    onPath(mid, cfg, _, oldSummary) and
    flowStep(nd, cfg, mid, newSummary) and
    reachableFromSource(nd, cfg, summary1) and
    summary2 = oldSummary.prepend(newSummary)
  )
}

/**
 * A data flow node on an inter-procedural path from a source.
 */
private newtype TPathNode =
  MkPathNode(DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary) {
    onPath(nd, cfg, summary, _)
  }

/**
 * Maps `cfg` to itself.
 *
 * This is an auxiliary predicate that is needed in some places to prevent us
 * from computing a cross-product of all path nodes belonging to the same configuration.
 */
bindingset[cfg, result]
private DataFlow::Configuration id(DataFlow::Configuration cfg) {
  result >= cfg and cfg >= result
}

/**
 * A data flow node on an inter-procedural path from a source to a sink.
 *
 * A path node is a triple `(nd, cfg, summary)` where `nd` is a data flow node and `cfg`
 * is a data flow tracking configuration such that `nd` is on a path from a source to a
 * sink under `cfg` summarized by `summary`.
 */
class PathNode extends TPathNode {
  DataFlow::Node nd;
  DataFlow::Configuration cfg;
  PathSummary summary;

  PathNode() { this = MkPathNode(nd, cfg, summary) }

  /** Gets the underlying data flow node of this path node. */
  DataFlow::Node getNode() {
    result = nd
  }

  /** Gets the underlying data flow tracking configuration of this path node. */
  DataFlow::Configuration getConfiguration() {
    result = cfg
  }

  /** Gets a successor node of this path node. */
  PathNode getASuccessor() {
    exists (DataFlow::Node succ, PathSummary newSummary |
      flowStep(nd, id(cfg), succ, newSummary) and
      result = MkPathNode(succ, id(cfg), summary.append(newSummary))
    )
  }

  /** Gets a textual representation of this path node. */
  string toString() {
    result = nd.toString()
  }

  /**
   * Holds if this path node is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [LGTM locations](https://lgtm.com/help/ql/locations).
   */
  predicate hasLocationInfo(string filepath, int startline, int startcolumn,
                            int endline, int endcolumn) {
    nd.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * A path node corresponding to a flow source.
 */
class SourcePathNode extends PathNode {
  SourcePathNode() {
    isSource(nd, cfg)
  }
}

/**
 * A path node corresponding to a flow sink.
 */
class SinkPathNode extends PathNode {
  SinkPathNode() {
    isSink(nd, cfg)
  }
}

/**
 * Provides the query predicate needed to include a graph in a path-problem query.
 */
module PathGraph {
  /** Holds if `pred` &rarr; `succ` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode pred, PathNode succ) {
    pred.getASuccessor() = succ
  }
}
