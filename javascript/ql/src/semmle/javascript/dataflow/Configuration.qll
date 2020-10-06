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

private import javascript
private import internal.FlowSteps
private import internal.AccessPaths
private import internal.CallGraphs

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
   * Gets the unique identifier of this configuration among all data flow tracking
   * configurations.
   */
  string getId() { result = this }

  /**
   * Holds if `source` is a relevant data flow source for this configuration.
   */
  predicate isSource(DataFlow::Node source) { none() }

  /**
   * Gets the flow label to associate with sources added by the 1-argument `isSource` predicate.
   *
   * For taint-tracking configurations, this defaults to `taint` and for other data-flow configurations
   * it defaults to `data`.
   *
   * Overriding this predicate is rarely needed, and overriding the 2-argument `isSource` predicate
   * should be preferred when possible.
   */
  FlowLabel getDefaultSourceLabel() { result = FlowLabel::data() }

  /**
   * Holds if `source` is a source of flow labeled with `lbl` that is relevant
   * for this configuration.
   */
  predicate isSource(DataFlow::Node source, FlowLabel lbl) { none() }

  /**
   * Holds if `sink` is a relevant data flow sink for this configuration.
   */
  predicate isSink(DataFlow::Node sink) { none() }

  /**
   * Holds if `sink` is a sink of flow labeled with `lbl` that is relevant
   * for this configuration.
   */
  predicate isSink(DataFlow::Node sink, FlowLabel lbl) { none() }

  /**
   * Holds if `src -> trg` should be considered as a flow edge
   * in addition to standard data flow edges.
   */
  predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) { none() }

  /**
   * INTERNAL: This predicate should not normally be used outside the data flow
   * library.
   *
   * Holds if `src -> trg` should be considered as a flow edge
   * in addition to standard data flow edges, with `valuePreserving`
   * indicating whether the step preserves values or just taintedness.
   */
  predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg, boolean valuePreserving) {
    isAdditionalFlowStep(src, trg) and valuePreserving = true
  }

  /**
   * Holds if `src -> trg` is a flow edge converting flow with label `inlbl` to
   * flow with label `outlbl`.
   */
  predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, FlowLabel inlbl, FlowLabel outlbl
  ) {
    none()
  }

  /**
   * Holds if the intermediate flow node `node` is prohibited.
   */
  predicate isBarrier(DataFlow::Node node) {
    exists(BarrierGuardNode guard |
      isBarrierGuardInternal(guard) and
      barrierGuardBlocksNode(guard, node, "")
    )
  }

  /**
   * DEPRECATED: Use `isBarrierEdge` instead.
   *
   * Holds if flow from `src` to `trg` is prohibited.
   */
  deprecated predicate isBarrier(DataFlow::Node src, DataFlow::Node trg) { none() }

  /**
   * DEPRECATED: Use `isBarrierEdge` instead.
   *
   * Holds if flow with label `lbl` cannot flow from `src` to `trg`.
   */
  deprecated predicate isBarrier(DataFlow::Node src, DataFlow::Node trg, FlowLabel lbl) { none() }

  /**
   * Holds if flow from `pred` to `succ` is prohibited.
   */
  predicate isBarrierEdge(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if flow with label `lbl` cannot flow from `pred` to `succ`.
   */
  predicate isBarrierEdge(DataFlow::Node pred, DataFlow::Node succ, FlowLabel lbl) { none() }

  /**
   * Holds if flow with label `lbl` cannot flow into `node`.
   */
  predicate isLabeledBarrier(DataFlow::Node node, FlowLabel lbl) {
    exists(BarrierGuardNode guard |
      isBarrierGuardInternal(guard) and
      barrierGuardBlocksNode(guard, node, lbl)
    )
    or
    none() // relax type inference to account for overriding
  }

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
   * Holds if `guard` is a barrier guard for this configuration, added through
   * `isBarrierGuard` or `AdditionalBarrierGuardNode`.
   */
  private predicate isBarrierGuardInternal(BarrierGuardNode guard) {
    isBarrierGuard(guard)
    or
    guard.(AdditionalBarrierGuardNode).appliesTo(this)
  }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    isSource(_, this, _) and
    isSink(_, this, _) and
    exists(SourcePathNode flowsource, SinkPathNode flowsink |
      hasFlowPath(flowsource, flowsink) and
      source = flowsource.getNode() and
      sink = flowsink.getNode()
    )
  }

  /**
   * Holds if data may flow from `source` to `sink` for this configuration.
   */
  predicate hasFlowPath(SourcePathNode source, SinkPathNode sink) {
    flowsTo(source, _, sink, _, this)
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  predicate isAdditionalStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    none()
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  predicate isAdditionalLoadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  predicate isAdditionalLoadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    none()
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  predicate isAdditionalLoadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    none()
  }
}

/**
 * A label describing the kind of information tracked by a flow configuration.
 *
 * There are two standard labels "data" and "taint".
 * - "data" only propagates along value-preserving data flow, such as assignments
 *   and parameter-passing, and is the default flow source for a `DataFlow::Configuration`.
 * - "taint" additionally permits flow through transformations such as string operations,
 *   and is the default flow source for a `TaintTracking::Configuration`.
 */
abstract class FlowLabel extends string {
  bindingset[this]
  FlowLabel() { any() }

  /**
   * Holds if this is the standard `FlowLabel::data()` flow label,
   * describing values that directly originate from a flow source.
   */
  final predicate isData() { this = FlowLabel::data() }

  /**
   * Holds if this is the standard `FlowLabel::taint()` flow label,
   * describing values that are influenced ("tainted") by a flow
   * source, but not necessarily directly derived from it.
   */
  final predicate isTaint() { this = FlowLabel::taint() }

  /**
   * Holds if this is one of the standard flow labels `FlowLabel::data()`
   * or `FlowLabel::taint()`.
   */
  final predicate isDataOrTaint() { isData() or isTaint() }
}

/**
 * A kind of taint tracked by a taint-tracking configuration.
 *
 * This is an alias of `FlowLabel`, so the two types can be used interchangeably.
 */
class TaintKind = FlowLabel;

/**
 * A standard flow label, that is, either `FlowLabel::data()` or `FlowLabel::taint()`.
 */
class StandardFlowLabel extends FlowLabel {
  StandardFlowLabel() { this = "data" or this = "taint" }
}

module FlowLabel {
  /**
   * Gets the standard flow label for describing values that directly originate from a flow source.
   */
  FlowLabel data() { result = "data" }

  /**
   * Gets the standard flow label for describing values that are influenced ("tainted") by a flow
   * source, but not necessarily directly derived from it.
   */
  FlowLabel taint() { result = "taint" }
}

/**
 * A node that can act as a barrier when appearing in a condition.
 *
 * To add a barrier guard to a configuration, define a subclass of this class overriding the
 * `blocks` predicate, and then extend the configuration's `isBarrierGuard` predicate to include
 * the new class.
 *
 * Note that it is generally a good idea to make the characteristic predicate of barrier guard
 * classes as precise as possible: if two subclasses of `BarrierGuardNode` overlap, their
 * implementations of `blocks` will _both_ apply to any configuration that includes either of them.
 */
abstract class BarrierGuardNode extends DataFlow::Node {
  /**
   * Holds if this node blocks expression `e` provided it evaluates to `outcome`.
   *
   * This will block all flow labels.
   */
  abstract predicate blocks(boolean outcome, Expr e);

  /**
   * Holds if this node blocks expression `e` from flow of type `label`, provided it evaluates to `outcome`.
   */
  predicate blocks(boolean outcome, Expr e, FlowLabel label) { none() }
}

/**
 * Holds if data flow node `nd` acts as a barrier for data flow.
 *
 * `label` is bound to the blocked label, or the empty string if all labels should be blocked.
 */
private predicate barrierGuardBlocksExpr(
  BarrierGuardNode guard, boolean outcome, Expr test, string label
) {
  guard.blocks(outcome, test) and label = ""
  or
  guard.blocks(outcome, test, label)
  or
  // Handle labelled barrier guard functions specially, to avoid negative recursion
  // through the non-abstract 3-argument version of blocks().
  guard.(AdditionalBarrierGuardCall).internalBlocksLabel(outcome, test, label)
}

/**
 * Holds if `guard` may block the flow of a value reachable through exploratory flow.
 */
pragma[noinline]
private predicate barrierGuardIsRelevant(BarrierGuardNode guard) {
  exists(Expr e |
    barrierGuardBlocksExpr(guard, _, e, _) and
    isRelevantForward(e.flow(), _)
  )
}

/**
 * Holds if data flow node `nd` acts as a barrier for data flow due to aliasing through
 * an access path.
 *
 * `label` is bound to the blocked label, or the empty string if all labels should be blocked.
 */
pragma[noinline]
private predicate barrierGuardBlocksAccessPath(
  BarrierGuardNode guard, boolean outcome, AccessPath ap, string label
) {
  barrierGuardIsRelevant(guard) and
  barrierGuardBlocksExpr(guard, outcome, ap.getAnInstance(), label)
}

/**
 * Holds if there exists an input variable of `ref` that blocks the label `label`.
 *
 * This predicate is outlined to give the optimizer a hint about the join ordering.
 */
private predicate barrierGuardBlocksSsaRefinement(
  BarrierGuardNode guard, boolean outcome, SsaRefinementNode ref, string label
) {
  barrierGuardIsRelevant(guard) and
  guard.getEnclosingExpr() = ref.getGuard().getTest() and
  forex(SsaVariable input | input = ref.getAnInput() |
    barrierGuardBlocksExpr(guard, outcome, input.getAUse(), label)
  )
}

/**
 * Holds if the result of `guard` is used in the branching condition `cond`.
 *
 * `outcome` is bound to the outcome of `cond` for join-ordering purposes.
 */
pragma[noinline]
private predicate barrierGuardUsedInCondition(
  BarrierGuardNode guard, ConditionGuardNode cond, boolean outcome
) {
  barrierGuardIsRelevant(guard) and
  outcome = cond.getOutcome() and
  (
    cond.getTest() = guard.getEnclosingExpr()
    or
    cond.getTest().flow().getImmediatePredecessor+() = guard
  )
}

/**
 * Holds if data flow node `nd` acts as a barrier for data flow, possibly due to aliasing
 * through an access path.
 *
 * `label` is bound to the blocked label, or the empty string if all labels should be blocked.
 */
private predicate barrierGuardBlocksNode(BarrierGuardNode guard, DataFlow::Node nd, string label) {
  // 1) `nd` is a use of a refinement node that blocks its input variable
  exists(SsaRefinementNode ref, boolean outcome |
    nd = DataFlow::ssaDefinitionNode(ref) and
    outcome = ref.getGuard().(ConditionGuardNode).getOutcome() and
    barrierGuardBlocksSsaRefinement(guard, outcome, ref, label)
  )
  or
  // 2) `nd` is an instance of an access path `p`, and dominated by a barrier for `p`
  exists(AccessPath p, BasicBlock bb, ConditionGuardNode cond, boolean outcome |
    nd = DataFlow::valueNode(p.getAnInstanceIn(bb)) and
    barrierGuardUsedInCondition(guard, cond, outcome) and
    barrierGuardBlocksAccessPath(guard, outcome, p, label) and
    cond.dominates(bb)
  )
}

/**
 * Holds if `guard` should block flow along the edge `pred -> succ`.
 *
 * `label` is bound to the blocked label, or the empty string if all labels should be blocked.
 */
private predicate barrierGuardBlocksEdge(
  BarrierGuardNode guard, DataFlow::Node pred, DataFlow::Node succ, string label
) {
  barrierGuardIsRelevant(guard) and
  exists(
    SsaVariable input, SsaPhiNode phi, BasicBlock bb, ConditionGuardNode cond, boolean outcome
  |
    pred = DataFlow::ssaDefinitionNode(input) and
    succ = DataFlow::ssaDefinitionNode(phi) and
    input = phi.getInputFromBlock(bb) and
    guard.getEnclosingExpr() = cond.getTest() and
    outcome = cond.getOutcome() and
    barrierGuardBlocksExpr(guard, outcome, input.getAUse(), label) and
    cond.dominates(bb)
  )
}

/**
 * Holds if there is a barrier edge `pred -> succ` in `cfg` either through an explicit barrier edge
 * or one implied by a barrier guard.
 *
 * Only holds for barriers that should apply to all flow labels.
 */
private predicate isBarrierEdge(Configuration cfg, DataFlow::Node pred, DataFlow::Node succ) {
  cfg.isBarrierEdge(pred, succ)
  or
  exists(DataFlow::BarrierGuardNode guard |
    cfg.isBarrierGuard(guard) and
    barrierGuardBlocksEdge(guard, pred, succ, "")
  )
}

/**
 * Holds if there is a labeled barrier edge `pred -> succ` in `cfg` either through an explicit barrier edge
 * or one implied by a barrier guard.
 */
private predicate isLabeledBarrierEdge(
  Configuration cfg, DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel label
) {
  cfg.isBarrierEdge(pred, succ, label)
  or
  exists(DataFlow::BarrierGuardNode guard |
    cfg.isBarrierGuard(guard) and
    barrierGuardBlocksEdge(guard, pred, succ, label)
  )
}

/**
 * A guard node that only blocks specific labels.
 */
abstract class LabeledBarrierGuardNode extends BarrierGuardNode {
  override predicate blocks(boolean outcome, Expr e) { none() }

  /**
   * DEPRECATED: Use `blocks(outcome, e, label)` or `sanitizes(outcome, e, label)` instead.
   *
   * Overriding this predicate has no effect.
   */
  deprecated FlowLabel getALabel() { none() }
}

/**
 * A data flow edge that should be added to all data flow configurations in
 * addition to standard data flow edges.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalFlowStep`
 * for analysis-specific flow steps.
 */
cached
abstract class AdditionalFlowStep extends DataFlow::Node {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  cached
  predicate step(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    none()
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  cached
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  cached
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    loadProp = storeProp and
    loadStoreStep(pred, succ, loadProp)
  }
}

/**
 * A collection of pseudo-properties that are used in multiple files.
 *
 * A pseudo-property represents the location where some value is stored in an object.
 *
 * For use with load/store steps in `DataFlow::AdditionalFlowStep` and TypeTracking.
 */
module PseudoProperties {
  bindingset[s]
  private string pseudoProperty(string s) { result = "$" + s + "$" }

  bindingset[s, v]
  private string pseudoProperty(string s, string v) { result = "$" + s + "|" + v + "$" }

  /**
   * Gets a pseudo-property for the location of elements in a `Set`
   */
  string setElement() { result = pseudoProperty("setElement") }

  /**
   * Gets a pseudo-property for the location of elements in a JavaScript iterator.
   */
  string iteratorElement() { result = pseudoProperty("iteratorElement") }

  /**
   * Gets a pseudo-property for the location of elements in an `Array`.
   */
  string arrayElement() { result = pseudoProperty("arrayElement") }

  /**
   * Gets a pseudo-property for the location of the `i`th element in an `Array`.
   */
  bindingset[i]
  string arrayElement(int i) {
    i < 5 and result = i.toString()
    or
    result = arrayElement()
  }

  /**
   * Gets a pseudo-property for the location of elements in some array-like object. (Set, Array, or Iterator).
   */
  string arrayLikeElement() { result = [setElement(), iteratorElement(), arrayElement()] }

  /**
   * Gets a pseudo-property for the location of map values, where the key is unknown.
   */
  string mapValueUnknownKey() { result = pseudoProperty("mapValueUnknownKey") }

  /**
   * Gets a pseudo-property for the location of all the values in a map.
   */
  string mapValueAll() { result = pseudoProperty("allMapValues") }

  /**
   * Gets a pseudo-property for the location of a map value where the key is `key`.
   * The string value of the `key` is encoded in the result, and there is only a result if the string value of `key` is known.
   */
  pragma[inline]
  string mapValueKnownKey(DataFlow::Node key) {
    result = pseudoProperty("mapValue", any(string s | key.mayHaveStringValue(s)))
  }

  /**
   * Gets a pseudo-property for the location of a map value where the key is `key`.
   */
  pragma[inline]
  string mapValue(DataFlow::Node key) {
    result = mapValueKnownKey(key)
    or
    not exists(mapValueKnownKey(key)) and
    result = mapValueUnknownKey()
  }
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
  predicate isSourceFor(Configuration cfg) { none() }

  /**
   * Holds if this data flow node should be considered a source node for
   * values labeled with `lbl` under configuration `cfg`.
   */
  predicate isSourceFor(Configuration cfg, FlowLabel lbl) { none() }
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
  predicate isSinkFor(Configuration cfg) { none() }

  /**
   * Holds if this data flow node should be considered a sink node for
   * values labeled with `lbl` under configuration `cfg`.
   */
  predicate isSinkFor(Configuration cfg, FlowLabel lbl) { none() }
}

/**
 * Additional flow step to model flow from import specifiers into the SSA variable
 * corresponding to the imported variable.
 */
private class FlowStepThroughImport extends AdditionalFlowStep, DataFlow::ValueNode {
  override ImportSpecifier astNode;

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this and
    succ = DataFlow::ssaDefinitionNode(SSA::definition(astNode))
  }
}

/**
 * Holds if there is a flow step from `pred` to `succ` described by `summary`
 * under configuration `cfg`, disregarding barriers.
 *
 * Summary steps through function calls are not taken into account.
 */
pragma[inline]
private predicate basicFlowStepNoBarrier(
  DataFlow::Node pred, DataFlow::Node succ, PathSummary summary, DataFlow::Configuration cfg
) {
  // Local flow
  exists(FlowLabel predlbl, FlowLabel succlbl |
    localFlowStep(pred, succ, cfg, predlbl, succlbl) and
    not cfg.isBarrierEdge(pred, succ) and
    summary = MkPathSummary(false, false, predlbl, succlbl)
  )
  or
  // Flow through properties of objects
  propertyFlowStep(pred, succ) and
  summary = PathSummary::level()
  or
  // Flow through global variables
  globalFlowStep(pred, succ) and
  summary = PathSummary::level()
  or
  // Flow into function
  callStep(pred, succ) and
  summary = PathSummary::call()
  or
  // Flow out of function
  returnStep(pred, succ) and
  summary = PathSummary::return()
}

/**
 * Holds if there is a flow step from `pred` to `succ` under configuration `cfg`,
 * including both basic flow steps and steps into/out of properties.
 *
 * This predicate is field insensitive (it does not distinguish between `x` and `x.p`)
 * and hence should only be used for purposes of approximation.
 */
pragma[inline]
private predicate exploratoryFlowStep(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg
) {
  basicFlowStepNoBarrier(pred, succ, _, cfg) or
  exploratoryLoadStep(pred, succ, cfg) or
  isAdditionalLoadStoreStep(pred, succ, _, _, cfg) or
  // the following three disjuncts taken together over-approximate flow through
  // higher-order calls
  callback(pred, succ) or
  succ = pred.(DataFlow::FunctionNode).getAParameter() or
  exploratoryBoundInvokeStep(pred, succ)
}

/**
 * Holds if `nd` is a source node for configuration `cfg`.
 */
private predicate isSource(DataFlow::Node nd, DataFlow::Configuration cfg, FlowLabel lbl) {
  (cfg.isSource(nd) or nd.(AdditionalSource).isSourceFor(cfg)) and
  lbl = cfg.getDefaultSourceLabel()
  or
  nd.(AdditionalSource).isSourceFor(cfg, lbl)
  or
  cfg.isSource(nd, lbl)
}

/**
 * Holds if `nd` is a sink node for configuration `cfg`.
 */
private predicate isSink(DataFlow::Node nd, DataFlow::Configuration cfg, FlowLabel lbl) {
  (cfg.isSink(nd) or nd.(AdditionalSink).isSinkFor(cfg)) and
  lbl = any(StandardFlowLabel f)
  or
  nd.(AdditionalSink).isSinkFor(cfg, lbl)
  or
  cfg.isSink(nd, lbl)
}

/**
 * Holds if there exists a load-step from `pred` to `succ` under configuration `cfg`,
 * and the forwards exploratory flow has found a relevant store-step with the same property as the load-step.
 */
private predicate exploratoryLoadStep(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg
) {
  exists(string prop | prop = getAForwardRelevantLoadProperty(cfg) |
    isAdditionalLoadStep(pred, succ, prop, cfg)
    or
    basicLoadStep(pred, succ, prop)
  )
}

/**
 * Gets a property where the forwards exploratory flow has found a relevant store-step with that property.
 * The property is therefore relevant for load-steps in the forward exploratory flow.
 *
 * This private predicate is only used in `exploratoryLoadStep`, and exists as a separate predicate to give the compiler a hint about join-ordering.
 */
private string getAForwardRelevantLoadProperty(DataFlow::Configuration cfg) {
  exists(DataFlow::Node previous | isRelevantForward(previous, cfg) |
    basicStoreStep(previous, _, result) or
    isAdditionalStoreStep(previous, _, result, cfg)
  )
  or
  result = getAPropertyUsedInLoadStore(cfg)
}

/**
 * Gets a property that is used in an `additionalLoadStoreStep` where the loaded and stored property are not the same.
 *
 * The properties from this predicate are used as a white-list of properties for load/store steps that should always be considered in the exploratory flow.
 */
private string getAPropertyUsedInLoadStore(DataFlow::Configuration cfg) {
  exists(string loadProp, string storeProp |
    isAdditionalLoadStoreStep(_, _, loadProp, storeProp, cfg) and
    storeProp != loadProp and
    result = [storeProp, loadProp]
  )
}

/**
 * Holds if there exists a store-step from `pred` to `succ` under configuration `cfg`,
 * and somewhere in the program there exists a load-step that could possibly read the stored value.
 */
private predicate exploratoryForwardStoreStep(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg
) {
  exists(string prop |
    basicLoadStep(_, _, prop) or
    isAdditionalLoadStep(_, _, prop, cfg) or
    prop = getAPropertyUsedInLoadStore(cfg)
  |
    isAdditionalStoreStep(pred, succ, prop, cfg) or
    basicStoreStep(pred, succ, prop)
  )
}

/**
 * Holds if there exists a store-step from `pred` to `succ` under configuration `cfg`,
 * and `succ` has been found to be relevant during the backwards exploratory flow,
 * and the backwards exploratory flow has found a relevant load-step with the same property as the store-step.
 */
private predicate exploratoryBackwardStoreStep(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg
) {
  exists(string prop | prop = getABackwardsRelevantStoreProperty(cfg) |
    isAdditionalStoreStep(pred, succ, prop, cfg) or
    basicStoreStep(pred, succ, prop)
  )
}

/**
 * Gets a property where the backwards exploratory flow has found a relevant load-step with that property.
 * The property is therefore relevant for store-steps in the backwards exploratory flow.
 *
 * This private predicate is only used in `exploratoryBackwardStoreStep`, and exists as a separate predicate to give the compiler a hint about join-ordering.
 */
private string getABackwardsRelevantStoreProperty(DataFlow::Configuration cfg) {
  exists(DataFlow::Node mid | isRelevant(mid, cfg) |
    basicLoadStep(mid, _, result) or
    isAdditionalLoadStep(mid, _, result, cfg)
  )
  or
  result = getAPropertyUsedInLoadStore(cfg)
}

/**
 * Holds if `nd` may be reachable from a source under `cfg`.
 *
 * No call/return matching is done, so this is a relatively coarse over-approximation.
 */
private predicate isRelevantForward(DataFlow::Node nd, DataFlow::Configuration cfg) {
  isSource(nd, cfg, _) and isLive()
  or
  exists(DataFlow::Node mid | isRelevantForward(mid, cfg) |
    exploratoryFlowStep(mid, nd, cfg) or
    exploratoryForwardStoreStep(mid, nd, cfg)
  )
}

/**
 * Holds if `nd` may be on a path from a source to a sink under `cfg`.
 *
 * No call/return matching is done, so this is a relatively coarse over-approximation.
 */
private predicate isRelevant(DataFlow::Node nd, DataFlow::Configuration cfg) {
  isRelevantForward(nd, cfg) and isSink(nd, cfg, _)
  or
  exists(DataFlow::Node mid | isRelevant(mid, cfg) | isRelevantBackStep(mid, nd, cfg))
}

/**
 * Holds if there is backwards data-flow step from `mid` to `nd` under `cfg`.
 */
private predicate isRelevantBackStep(
  DataFlow::Node mid, DataFlow::Node nd, DataFlow::Configuration cfg
) {
  isRelevantForward(nd, cfg) and
  (
    exploratoryFlowStep(nd, mid, cfg) or
    exploratoryBackwardStoreStep(nd, mid, cfg)
  )
}

/**
 * Holds if `pred` is an input to `f` which is passed to `succ` at `invk`; that is,
 * either `pred` is an argument of `f` and `succ` the corresponding parameter, or
 * `pred` is a variable definition whose value is captured by `f` at `succ`.
 */
private predicate callInputStep(
  Function f, DataFlow::Node invk, DataFlow::Node pred, DataFlow::Node succ,
  DataFlow::Configuration cfg
) {
  (
    isRelevant(pred, cfg) and
    argumentPassing(invk, pred, f, succ)
    or
    isRelevant(pred, cfg) and
    exists(LocalVariable variable, SsaDefinition def |
      pred = DataFlow::capturedVariableNode(variable) and
      calls(invk, f) and
      captures(f, variable, def) and
      succ = DataFlow::ssaDefinitionNode(def)
    )
  ) and
  not cfg.isBarrier(succ) and
  not isBarrierEdge(cfg, pred, succ)
}

/**
 * Holds if `input`, which is either an argument to `f` at `invk` or a definition
 * that is captured by `f`, may flow to `nd` under configuration `cfg` (possibly through
 * callees, but not containing any unmatched calls or returns) along a path summarized by
 * `summary`.
 *
 * Note that the summary does not take the initial step from argument to parameter
 * into account.
 */
pragma[nomagic]
private predicate reachableFromInput(
  Function f, DataFlow::Node invk, DataFlow::Node input, DataFlow::Node nd,
  DataFlow::Configuration cfg, PathSummary summary
) {
  callInputStep(f, invk, input, nd, cfg) and
  summary = PathSummary::level()
  or
  exists(DataFlow::Node mid, PathSummary oldSummary |
    reachableFromInput(f, invk, input, mid, cfg, oldSummary) and
    appendStep(mid, cfg, oldSummary, nd, summary)
  )
}

/**
 * Holds if there is a level step from `pred` to `succ` under `cfg` that can be appended
 * to a path represented by `oldSummary` yielding a path represented by `newSummary`.
 */
pragma[noinline]
private predicate appendStep(
  DataFlow::Node pred, DataFlow::Configuration cfg, PathSummary oldSummary, DataFlow::Node succ,
  PathSummary newSummary
) {
  exists(PathSummary stepSummary |
    flowStep(pred, cfg, succ, stepSummary) and
    stepSummary.isLevel() and
    newSummary = oldSummary.append(stepSummary)
  )
}

/**
 * Holds if a function invoked at `invk` may return an expression into which `input`,
 * which is either an argument or a definition captured by the function, flows under
 * configuration `cfg`, possibly through callees.
 */
private predicate flowThroughCall(
  DataFlow::Node input, DataFlow::Node output, DataFlow::Configuration cfg, PathSummary summary
) {
  exists(Function f, DataFlow::FunctionReturnNode ret |
    ret.getFunction() = f and
    (calls(output, f) or callsBound(output, f, _)) and // Do not consider partial calls
    reachableFromInput(f, output, input, ret, cfg, summary) and
    not isBarrierEdge(cfg, ret, output) and
    not isLabeledBarrierEdge(cfg, ret, output, summary.getEndLabel()) and
    not cfg.isLabeledBarrier(output, summary.getEndLabel())
  )
  or
  exists(Function f, DataFlow::Node invk, DataFlow::Node ret |
    DataFlow::exceptionalFunctionReturnNode(ret, f) and
    DataFlow::exceptionalInvocationReturnNode(output, invk.asExpr()) and
    (calls(invk, f) or callsBound(invk, f, _)) and
    reachableFromInput(f, invk, input, ret, cfg, summary) and
    not isBarrierEdge(cfg, ret, output) and
    not isLabeledBarrierEdge(cfg, ret, output, summary.getEndLabel()) and
    not cfg.isLabeledBarrier(output, summary.getEndLabel())
  )
  or
  // exception thrown inside an immediately awaited function call.
  exists(DataFlow::FunctionNode f, DataFlow::Node invk, DataFlow::Node ret |
    f.getFunction().isAsync()
  |
    (calls(invk, f.getFunction()) or callsBound(invk, f.getFunction(), _)) and
    reachableFromInput(f.getFunction(), invk, input, ret, cfg, summary) and
    output = invk.asExpr().getExceptionTarget() and
    f.getExceptionalReturn() = getThrowTarget(ret) and
    invk = getAwaitOperand(_)
  )
}

/**
 * Holds if `pred` may flow into property `prop` of `succ` under configuration `cfg`
 * along a path summarized by `summary`.
 */
pragma[nomagic]
private predicate storeStep(
  DataFlow::Node pred, DataFlow::Node succ, string prop, DataFlow::Configuration cfg,
  PathSummary summary
) {
  isRelevant(pred, cfg) and
  basicStoreStep(pred, succ, prop) and
  summary = PathSummary::level()
  or
  isRelevant(pred, cfg) and
  isAdditionalStoreStep(pred, succ, prop, cfg) and
  summary = PathSummary::level()
  or
  exists(Function f, DataFlow::Node mid, DataFlow::Node invk |
    not f.isAsyncOrGenerator() and invk = succ
    or
    // store in an immediately awaited function call
    f.isAsync() and
    invk = getAwaitOperand(succ)
  |
    // `f` stores its parameter `pred` in property `prop` of a value that flows back to the caller,
    // and `succ` is an invocation of `f`
    reachableFromInput(f, invk, pred, mid, cfg, summary) and
    (
      returnedPropWrite(f, _, prop, mid)
      or
      exists(DataFlow::SourceNode base | base.flowsToExpr(f.getAReturnedExpr()) |
        isAdditionalStoreStep(mid, base, prop, cfg)
      )
      or
      invk instanceof DataFlow::NewNode and
      receiverPropWrite(f, prop, mid)
    )
  )
}

/**
 * Gets a dataflow-node for the operand of the await-expression `await`.
 */
private DataFlow::Node getAwaitOperand(DataFlow::Node await) {
  exists(AwaitExpr awaitExpr |
    result = awaitExpr.getOperand().getUnderlyingValue().flow() and
    await.asExpr() = awaitExpr
  )
}

/**
 * Holds if `f` may `read` property `prop` of parameter `parm`.
 */
private predicate parameterPropRead(
  Function f, DataFlow::Node invk, DataFlow::Node arg, string prop, DataFlow::Node read,
  DataFlow::Configuration cfg
) {
  exists(DataFlow::SourceNode parm |
    callInputStep(f, invk, arg, parm, cfg) and
    (
      read = parm.getAPropertyRead(prop)
      or
      exists(DataFlow::Node use | parm.flowsTo(use) | isAdditionalLoadStep(use, read, prop, cfg))
    )
  )
}

/**
 * Holds if `nd` may flow into a return statement of `f` under configuration `cfg`
 * (possibly through callees) along a path summarized by `summary`.
 */
private predicate reachesReturn(
  Function f, DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary
) {
  isRelevant(nd, cfg) and
  returnExpr(f, nd, _) and
  summary = PathSummary::level()
  or
  exists(DataFlow::Node mid, PathSummary oldSummary, PathSummary newSummary |
    flowStep(nd, cfg, mid, oldSummary) and
    reachesReturn(f, mid, cfg, newSummary) and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
 */
private predicate isAdditionalLoadStep(
  DataFlow::Node pred, DataFlow::Node succ, string prop, DataFlow::Configuration cfg
) {
  any(AdditionalFlowStep s).loadStep(pred, succ, prop)
  or
  cfg.isAdditionalLoadStep(pred, succ, prop)
}

/**
 * Holds if `pred` should be stored in the object `succ` under the property `prop`.
 */
private predicate isAdditionalStoreStep(
  DataFlow::Node pred, DataFlow::Node succ, string prop, DataFlow::Configuration cfg
) {
  any(AdditionalFlowStep s).storeStep(pred, succ, prop)
  or
  cfg.isAdditionalStoreStep(pred, succ, prop)
}

/**
 * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
 */
private predicate isAdditionalLoadStoreStep(
  DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp,
  DataFlow::Configuration cfg
) {
  any(AdditionalFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  or
  cfg.isAdditionalLoadStoreStep(pred, succ, loadProp, storeProp)
  or
  loadProp = storeProp and
  (
    any(AdditionalFlowStep s).loadStoreStep(pred, succ, loadProp)
    or
    cfg.isAdditionalLoadStoreStep(pred, succ, loadProp)
  )
}

/**
 * Holds if property `prop` of `pred` may flow into `succ` along a path summarized by
 * `summary`.
 */
private predicate loadStep(
  DataFlow::Node pred, DataFlow::Node succ, string prop, DataFlow::Configuration cfg,
  PathSummary summary
) {
  isRelevant(pred, cfg) and
  basicLoadStep(pred, succ, prop) and
  summary = PathSummary::level()
  or
  isRelevant(pred, cfg) and
  isAdditionalLoadStep(pred, succ, prop, cfg) and
  summary = PathSummary::level()
  or
  exists(Function f, DataFlow::Node read, DataFlow::Node invk |
    not f.isAsyncOrGenerator() and invk = succ
    or
    // load from an immediately awaited function call
    f.isAsync() and
    invk = getAwaitOperand(succ)
  |
    parameterPropRead(f, invk, pred, prop, read, cfg) and
    reachesReturn(f, read, cfg, summary)
  )
}

/**
 * Holds if `rhs` is the right-hand side of a write to property `prop`, and `nd` is reachable
 * from the base of that write under configuration `cfg` (possibly through callees) along a
 * path summarized by `summary`.
 */
pragma[nomagic]
private predicate reachableFromStoreBase(
  string prop, DataFlow::Node rhs, DataFlow::Node nd, DataFlow::Configuration cfg,
  PathSummary summary
) {
  exists(PathSummary s1, PathSummary s2 |
    reachableFromSource(rhs, cfg, s1)
    or
    reachableFromStoreBase(_, _, rhs, cfg, s1)
  |
    storeStep(rhs, nd, prop, cfg, s2) and
    summary =
      MkPathSummary(false, s1.hasCall().booleanOr(s2.hasCall()), s2.getStartLabel(),
        s2.getEndLabel())
  )
  or
  exists(PathSummary newSummary, PathSummary oldSummary |
    reachableFromStoreBaseStep(prop, rhs, nd, cfg, oldSummary, newSummary) and
    summary = oldSummary.appendValuePreserving(newSummary)
  )
}

/**
 * Holds if `rhs` is the right-hand side of a write to property `prop`, and `nd` is reachable
 * from the base of that write under configuration `cfg` (possibly through callees) along a
 * path whose last step is summarized by `newSummary`, and the previous steps are summarized
 * by `oldSummary`.
 */
pragma[noinline]
private predicate reachableFromStoreBaseStep(
  string prop, DataFlow::Node rhs, DataFlow::Node nd, DataFlow::Configuration cfg,
  PathSummary oldSummary, PathSummary newSummary
) {
  exists(DataFlow::Node mid |
    reachableFromStoreBase(prop, rhs, mid, cfg, oldSummary) and
    flowStep(mid, cfg, nd, newSummary)
    or
    exists(string midProp |
      reachableFromStoreBase(midProp, rhs, mid, cfg, oldSummary) and
      isAdditionalLoadStoreStep(mid, nd, midProp, prop, cfg) and
      newSummary = PathSummary::level()
    )
  )
}

/**
 * Holds if the value of `pred` is written to a property of some base object, and that base
 * object may flow into the base of property read `succ` under configuration `cfg` along
 * a path summarized by `summary`.
 *
 * In other words, `pred` may flow to `succ` through a property.
 */
pragma[noinline]
private predicate flowThroughProperty(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg, PathSummary summary
) {
  exists(PathSummary oldSummary, PathSummary newSummary |
    storeToLoad(pred, succ, cfg, oldSummary, newSummary) and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if the value of `pred` is written to a property of some base object, and that base
 * object may flow into the base of property read `succ` under configuration `cfg` along
 * a path whose last step is summarized by `newSummary`, and the previous steps are summarized
 * by `oldSummary`.
 */
pragma[noinline]
private predicate storeToLoad(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg, PathSummary oldSummary,
  PathSummary newSummary
) {
  exists(string prop, DataFlow::Node base |
    reachableFromStoreBase(prop, pred, base, cfg, oldSummary) and
    loadStep(base, succ, prop, cfg, newSummary)
  )
}

/**
 * Holds if `arg` and `cb` are passed as arguments to a function which in turn
 * invokes `cb`, passing `arg` as its `i`th argument.
 *
 * All of this is done under configuration `cfg`, and `arg` flows along a path
 * summarized by `summary`, while `cb` is only tracked locally.
 */
private predicate summarizedHigherOrderCall(
  DataFlow::Node arg, DataFlow::Node cb, int i, DataFlow::Configuration cfg, PathSummary summary
) {
  exists(
    Function f, DataFlow::InvokeNode outer, DataFlow::InvokeNode inner, int j,
    DataFlow::Node innerArg, DataFlow::SourceNode cbParm, PathSummary oldSummary
  |
    reachableFromInput(f, outer, arg, innerArg, cfg, oldSummary) and
    argumentPassing(outer, cb, f, cbParm) and
    innerArg = inner.getArgument(j)
  |
    // direct higher-order call
    cbParm.flowsTo(inner.getCalleeNode()) and
    i = j and
    summary = oldSummary
    or
    // indirect higher-order call
    exists(DataFlow::Node cbArg, PathSummary newSummary |
      cbParm.flowsTo(cbArg) and
      summarizedHigherOrderCall(innerArg, cbArg, i, cfg, newSummary) and
      summary = oldSummary.append(PathSummary::call()).append(newSummary)
    )
  )
}

/**
 * Holds if `arg` is passed as the `i`th argument to `callback` through a callback invocation.
 *
 * This can be a summarized call, that is, `arg` and `callback` flow into a call,
 * `f(arg, callback)`, which performs the invocation.
 *
 * Alternatively, the callback can flow into a call `f(callback)` which itself provides the `arg`.
 * That is, `arg` refers to a value defined in `f` or one of its callees.
 *
 * In the latter case, the summary will consists of both a `return` and `call` step, for the following reasons:
 *
 * - Having `return` in the summary ensures that arguments passsed to `f` can't propagate back out along this edge.
 *   This is, `arg` should be defined in `f` or one of its callees, since a context-dependent value (i.e. parameter)
 *   should not propagate to every callback passed to `f`.
 *   In reality, `arg` may refer to a parameter, but in that case, the `return` summary prevents the edge from ever
 *   being used.
 *
 * - Having `call` in the summary ensures that values we propagate into the callback definition along this edge
 *   can't propagate out to other callers of that function through a return statement.
 *
 * - The flow label mapping of the summary corresponds to the transformation from `arg` to the
 *   invocation of the callback.
 */
pragma[nomagic]
private predicate higherOrderCall(
  DataFlow::Node arg, DataFlow::SourceNode callback, int i, DataFlow::Configuration cfg,
  PathSummary summary
) {
  // Summarized call
  exists(DataFlow::Node cb |
    summarizedHigherOrderCall(arg, cb, i, cfg, summary) and
    callback.flowsTo(cb)
  )
  or
  // Local invocation of a parameter
  isRelevant(arg, cfg) and
  exists(DataFlow::InvokeNode invoke |
    arg = invoke.getArgument(i) and
    invoke = callback.(DataFlow::ParameterNode).getACall() and
    summary = PathSummary::call()
  )
  or
  // Forwarding of the callback parameter (but not the argument).
  exists(DataFlow::Node cbArg, DataFlow::SourceNode innerCb, PathSummary oldSummary |
    higherOrderCall(arg, innerCb, i, cfg, oldSummary) and
    callStep(cbArg, innerCb) and
    callback.flowsTo(cbArg) and
    // Prepend a 'return' summary to prevent context-dependent values (i.e. parameters) from using this edge.
    summary = PathSummary::return().append(oldSummary)
  )
}

/**
 * Holds if `pred` is passed as an argument to a function `f` which also takes a
 * callback parameter `cb` and then invokes `cb`, passing `pred` into parameter `succ`
 * of `cb`.
 *
 * All of this is done under configuration `cfg`, and `arg` flows along a path
 * summarized by `summary`, while `cb` is only tracked locally.
 */
private predicate flowIntoHigherOrderCall(
  DataFlow::Node pred, DataFlow::Node succ, DataFlow::Configuration cfg, PathSummary summary
) {
  exists(DataFlow::FunctionNode cb, int i, PathSummary oldSummary |
    higherOrderCall(pred, cb, i, cfg, oldSummary) and
    succ = cb.getParameter(i) and
    summary = oldSummary.append(PathSummary::call())
  )
  or
  exists(
    DataFlow::SourceNode cb, DataFlow::FunctionNode f, int i, int boundArgs, PathSummary oldSummary
  |
    higherOrderCall(pred, cb, i, cfg, oldSummary) and
    cb = CallGraph::getABoundFunctionReference(f, boundArgs, false) and
    succ = f.getParameter(boundArgs + i) and
    summary = oldSummary.append(PathSummary::call())
  )
}

/**
 * Holds if there is a flow step from `pred` to `succ` described by `summary`
 * under configuration `cfg`.
 */
private predicate flowStep(
  DataFlow::Node pred, DataFlow::Configuration cfg, DataFlow::Node succ, PathSummary summary
) {
  (
    basicFlowStepNoBarrier(pred, succ, summary, cfg) and
    isRelevant(pred, cfg)
    or
    // Flow through a function that returns a value that depends on one of its arguments
    // or a captured variable
    flowThroughCall(pred, succ, cfg, summary)
    or
    // Flow through a property write/read pair
    flowThroughProperty(pred, succ, cfg, summary)
    or
    // Flow into higher-order call
    flowIntoHigherOrderCall(pred, succ, cfg, summary)
  ) and
  not cfg.isBarrier(succ) and
  not isBarrierEdge(cfg, pred, succ) and
  not isLabeledBarrierEdge(cfg, pred, succ, summary.getEndLabel()) and
  not cfg.isLabeledBarrier(succ, summary.getEndLabel())
}

/**
 * Holds if `source` can flow to `sink` under configuration `cfg`
 * in zero or more steps.
 */
pragma[nomagic]
private predicate flowsTo(
  PathNode flowsource, DataFlow::Node source, SinkPathNode flowsink, DataFlow::Node sink,
  DataFlow::Configuration cfg
) {
  flowsource.wraps(source, cfg) and
  flowsink = flowsource.getASuccessor*() and
  flowsink.wraps(sink, id(cfg))
}

/**
 * Holds if `nd` is reachable from a source under `cfg` along a path summarized by
 * `summary`.
 */
pragma[nomagic]
private predicate reachableFromSource(
  DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary
) {
  exists(FlowLabel lbl |
    isSource(nd, cfg, lbl) and
    not cfg.isBarrier(nd) and
    not cfg.isLabeledBarrier(nd, lbl) and
    summary = PathSummary::level(lbl)
  )
  or
  exists(DataFlow::Node pred, PathSummary oldSummary, PathSummary newSummary |
    reachableFromSource(pred, cfg, oldSummary) and
    flowStep(pred, cfg, nd, newSummary) and
    summary = oldSummary.append(newSummary)
  )
}

/**
 * Holds if `nd` can be reached from a source under `cfg`, and in turn a sink is
 * reachable from `nd`, where the path from the source to `nd` is summarized by `summary`.
 */
private predicate onPath(DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary) {
  reachableFromSource(nd, cfg, summary) and
  isSink(nd, cfg, summary.getEndLabel()) and
  not cfg.isBarrier(nd) and
  not cfg.isLabeledBarrier(nd, summary.getEndLabel())
  or
  exists(DataFlow::Node mid, PathSummary stepSummary |
    onPathStep(nd, cfg, summary, stepSummary, mid) and
    onPath(mid, id(cfg), summary.append(stepSummary))
  )
}

/**
 * Holds if `nd` can be reached from a source under `cfg`,
 * and there is a flowStep from `nd` (with summary `summary`) to `mid` (with summary `stepSummary`).
 *
 * This predicate has been outlined from `onPath` to give the optimizer a hint about join-ordering.
 */
private predicate onPathStep(
  DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary, PathSummary stepSummary,
  DataFlow::Node mid
) {
  reachableFromSource(nd, cfg, summary) and
  flowStep(nd, id(cfg), mid, stepSummary)
}

/**
 * Holds if there is a configuration that has at least one source and at least one sink.
 */
pragma[noinline]
private predicate isLive() {
  exists(DataFlow::Configuration cfg | isSource(_, cfg, _) and isSink(_, cfg, _))
}

/**
 * A data flow node on an inter-procedural path from a source.
 */
private newtype TPathNode =
  MkSourceNode(DataFlow::Node nd, DataFlow::Configuration cfg) { isSourceNode(nd, cfg, _) } or
  MkMidNode(DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary) {
    isLive() and
    onPath(nd, cfg, summary)
  } or
  MkSinkNode(DataFlow::Node nd, DataFlow::Configuration cfg) { isSinkNode(nd, cfg, _) }

/**
 * Holds if `nd` is a source node for configuration `cfg`, and there is a path from `nd` to a sink
 * with the given `summary`.
 */
private predicate isSourceNode(DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary) {
  exists(FlowLabel lbl | summary = PathSummary::level(lbl) |
    isSource(nd, cfg, lbl) and
    isLive() and
    onPath(nd, cfg, summary)
  )
}

/**
 * Holds if `nd` is a sink node for configuration `cfg`, and there is a path from a source to `nd`
 * with the given `summary`.
 */
private predicate isSinkNode(DataFlow::Node nd, DataFlow::Configuration cfg, PathSummary summary) {
  isSink(nd, cfg, summary.getEndLabel()) and
  isLive() and
  onPath(nd, cfg, summary)
}

/**
 * Maps `cfg` to itself.
 *
 * This is an auxiliary predicate that is needed in some places to prevent us
 * from computing a cross-product of all path nodes belonging to the same configuration.
 */
bindingset[cfg, result]
private DataFlow::Configuration id(DataFlow::Configuration cfg) { result >= cfg and cfg >= result }

/**
 * A data-flow node on an inter-procedural path from a source to a sink.
 *
 * A path node wraps a data-flow node `nd` and a data-flow configuration `cfg` such that `nd` is
 * on a path from a source to a sink under `cfg`.
 *
 * There are three kinds of path nodes:
 *
 *  - source nodes: wrapping a source node and a configuration such that there is a path from that
 *    source to some sink under the configuration;
 *  - sink nodes: wrapping a sink node and a configuration such that there is a path from some source
 *    to that sink under the configuration;
 *  - mid nodes: wrapping a node, a configuration and a path summary such that there is a path from
 *    some source to the node with the given summary that can be extended to a path to some sink node,
 *    all under the configuration.
 */
class PathNode extends TPathNode {
  DataFlow::Node nd;
  Configuration cfg;

  PathNode() {
    this = MkSourceNode(nd, cfg) or
    this = MkMidNode(nd, cfg, _) or
    this = MkSinkNode(nd, cfg)
  }

  /** Holds if this path node wraps data-flow node `nd` and configuration `c`. */
  predicate wraps(DataFlow::Node n, DataFlow::Configuration c) { nd = n and cfg = c }

  /** Gets the underlying configuration of this path node. */
  DataFlow::Configuration getConfiguration() { result = cfg }

  /** Gets the underlying data-flow node of this path node. */
  DataFlow::Node getNode() { result = nd }

  /** Gets a successor node of this path node. */
  final PathNode getASuccessor() { result = getASuccessor(this) }

  /** Gets a textual representation of this path node. */
  string toString() { result = nd.toString() }

  /**
   * Holds if this path node is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    nd.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** Gets the mid node corresponding to `src`. */
private MidPathNode initialMidNode(SourcePathNode src) {
  exists(DataFlow::Node nd, Configuration cfg, PathSummary summary |
    result.wraps(nd, cfg, summary) and
    src = MkSourceNode(nd, cfg) and
    isSourceNode(nd, cfg, summary)
  )
}

/** Gets the mid node corresponding to `snk`. */
private MidPathNode finalMidNode(SinkPathNode snk) {
  exists(DataFlow::Node nd, Configuration cfg, PathSummary summary |
    result.wraps(nd, cfg, summary) and
    snk = MkSinkNode(nd, cfg) and
    isSinkNode(nd, cfg, summary)
  )
}

/**
 * Holds if `nd` is a mid node wrapping `(predNd, cfg, summary)`, and there is a flow step
 * from `predNd` to `succNd` under `cfg` with summary `newSummary`.
 *
 * This helper predicate exists to clarify the intended join order in `getASuccessor` below.
 */
pragma[noinline]
private predicate midNodeStep(
  PathNode nd, DataFlow::Node predNd, Configuration cfg, PathSummary summary, DataFlow::Node succNd,
  PathSummary newSummary
) {
  nd = MkMidNode(predNd, cfg, summary) and
  flowStep(predNd, id(cfg), succNd, newSummary)
}

/**
 * Gets a node to which data from `nd` may flow in one step.
 */
private PathNode getASuccessor(PathNode nd) {
  // source node to mid node
  result = initialMidNode(nd)
  or
  // mid node to mid node
  exists(
    Configuration cfg, DataFlow::Node predNd, PathSummary summary, DataFlow::Node succNd,
    PathSummary newSummary
  |
    midNodeStep(nd, predNd, cfg, summary, succNd, newSummary) and
    result = MkMidNode(succNd, id(cfg), summary.append(newSummary))
  )
  or
  // mid node to sink node
  nd = finalMidNode(result)
}

private PathNode getASuccessorIfHidden(PathNode nd) {
  nd.(MidPathNode).isHidden() and
  result = getASuccessor(nd)
}

/**
 * A path node corresponding to an intermediate node on a path from a source to a sink.
 *
 * A mid node is a triple `(nd, cfg, summary)` where `nd` is a data-flow node and `cfg`
 * is a configuration such that `nd` is on a path from a source to a sink under `cfg`
 * summarized by `summary`.
 */
class MidPathNode extends PathNode, MkMidNode {
  PathSummary summary;

  MidPathNode() { this = MkMidNode(nd, cfg, summary) }

  /** Gets the summary of the path underlying this path node. */
  PathSummary getPathSummary() { result = summary }

  /** Holds if this path node wraps data-flow node `nd`, configuration `c` and summary `s`. */
  predicate wraps(DataFlow::Node n, DataFlow::Configuration c, PathSummary s) {
    nd = n and cfg = c and summary = s
  }

  /**
   * Holds if this node is hidden from paths in path explanation queries, except
   * in cases where it is the source or sink.
   */
  predicate isHidden() {
    // Skip phi, refinement, and capture nodes
    nd.(DataFlow::SsaDefinitionNode).getSsaVariable().getDefinition() instanceof
      SsaImplicitDefinition
    or
    // Skip SSA definition of parameter as its location coincides with the parameter node
    nd = DataFlow::ssaDefinitionNode(SSA::definition(any(SimpleParameter p)))
    or
    // Skip to the top of big left-leaning string concatenation trees.
    nd = any(AddExpr add).flow() and
    nd = any(AddExpr add).getAnOperand().flow()
    or
    // Skip the exceptional return on functions, as this highlights the entire function.
    nd = any(DataFlow::FunctionNode f).getExceptionalReturn()
    or
    // Skip the special return node for functions, as this highlights the entire function (and the returned expr is the previous node).
    nd = any(DataFlow::FunctionNode f).getReturnNode()
    or
    // Skip the synthetic 'this' node, as a ThisExpr will be the next node anyway
    nd = DataFlow::thisNode(_)
    or
    // Skip captured variable nodes as the successor will be a use of that variable anyway.
    nd = DataFlow::capturedVariableNode(_)
  }
}

/**
 * A path node corresponding to a flow source.
 */
class SourcePathNode extends PathNode, MkSourceNode {
  SourcePathNode() { this = MkSourceNode(nd, cfg) }
}

/**
 * A path node corresponding to a flow sink.
 */
class SinkPathNode extends PathNode, MkSinkNode {
  SinkPathNode() { this = MkSinkNode(nd, cfg) }
}

/**
 * Provides the query predicates needed to include a graph in a path-problem query.
 */
module PathGraph {
  /** Holds if `nd` is a node in the graph of data flow path explanations. */
  query predicate nodes(PathNode nd) { not nd.(MidPathNode).isHidden() }

  /**
   * Gets a node to which data from `nd` may flow in one step, skipping over hidden nodes.
   */
  private PathNode succ0(PathNode nd) {
    result = getASuccessorIfHidden*(nd.getASuccessor()) and
    // skip hidden nodes
    nodes(nd) and
    nodes(result)
  }

  /**
   * Gets a node to which data from `nd` may flow in one step, where outgoing edges from intermediate
   * nodes are merged with any incoming edge from a corresponding source node.
   *
   * For example, assume that `src` is a source node for `nd1`, which has `nd2` as its direct
   * successor. Then `succ0` will yield two edges `src` &rarr; `nd1` and `nd1` &rarr; `nd2`,
   * to which `succ1` will add the edge `src` &rarr; `nd2`.
   */
  private PathNode succ1(PathNode nd) {
    result = succ0(nd)
    or
    result = succ0(initialMidNode(nd))
  }

  /**
   * Gets a node to which data from `nd` may flow in one step, where incoming edges into intermediate
   * nodes are merged with any outgoing edge to a corresponding sink node.
   *
   * For example, assume that `snk` is a source node for `nd2`, which has `nd1` as its direct
   * predecessor. Then `succ1` will yield two edges `nd1` &rarr; `nd2` and `nd2` &rarr; `snk`,
   * while `succ2` will yield just one edge `nd1` &rarr; `snk`.
   */
  private PathNode succ2(PathNode nd) {
    result = succ1(nd)
    or
    succ1(nd) = finalMidNode(result)
  }

  /** Holds if `pred` &rarr; `succ` is an edge in the graph of data flow path explanations. */
  query predicate edges(PathNode pred, PathNode succ) {
    succ = succ2(pred) and
    // skip over uninteresting edges
    not succ = initialMidNode(pred) and
    not pred = finalMidNode(succ)
  }
}

/**
 * Gets an operand of the given `&&` operator.
 *
 * We use this to construct the transitive closure over a relation
 * that does not include all of `BinaryExpr.getAnOperand`.
 */
private Expr getALogicalAndOperand(LogAndExpr e) { result = e.getAnOperand() }

/**
 * Gets an operand of the given `||` operator.
 *
 * We use this to construct the transitive closure over a relation
 * that does not include all of `BinaryExpr.getAnOperand`.
 */
private Expr getALogicalOrOperand(LogOrExpr e) { result = e.getAnOperand() }

/**
 * A `BarrierGuardNode` that controls which data flow
 * configurations it is used in.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isBarrierGuard`
 * for analysis-specific barrier guards.
 */
abstract class AdditionalBarrierGuardNode extends BarrierGuardNode {
  abstract predicate appliesTo(Configuration cfg);
}

/**
 * A function that returns the result of a barrier guard.
 */
private class BarrierGuardFunction extends Function {
  DataFlow::ParameterNode sanitizedParameter;
  BarrierGuardNode guard;
  boolean guardOutcome;
  string label;

  BarrierGuardFunction() {
    barrierGuardIsRelevant(guard) and
    exists(Expr e |
      exists(Expr returnExpr |
        returnExpr = guard.asExpr()
        or
        // ad hoc support for conjunctions:
        getALogicalAndOperand+(returnExpr) = guard.asExpr() and guardOutcome = true
        or
        // ad hoc support for disjunctions:
        getALogicalOrOperand+(returnExpr) = guard.asExpr() and guardOutcome = false
      |
        exists(SsaExplicitDefinition ssa |
          ssa.getDef().getSource() = returnExpr and
          ssa.getVariable().getAUse() = getAReturnedExpr()
        )
        or
        returnExpr = getAReturnedExpr()
      ) and
      sanitizedParameter.flowsToExpr(e) and
      barrierGuardBlocksExpr(guard, guardOutcome, e, label)
    ) and
    getNumParameter() = 1 and
    sanitizedParameter.getParameter() = getParameter(0)
  }

  /**
   * Holds if this function sanitizes argument `e` of call `call`, provided the call evaluates to `outcome`.
   */
  predicate isBarrierCall(DataFlow::CallNode call, Expr e, boolean outcome, string lbl) {
    exists(DataFlow::Node arg |
      arg.asExpr() = e and
      arg = call.getArgument(0) and
      call.getNumArgument() = 1 and
      argumentPassing(call, arg, this, sanitizedParameter) and
      outcome = guardOutcome and
      lbl = label
    )
  }

  /**
   * Holds if this function applies to the flow in `cfg`.
   */
  predicate appliesTo(Configuration cfg) { cfg.isBarrierGuard(guard) }
}

/**
 * A call that sanitizes an argument.
 */
private class AdditionalBarrierGuardCall extends AdditionalBarrierGuardNode, DataFlow::CallNode {
  BarrierGuardFunction f;

  AdditionalBarrierGuardCall() { f.isBarrierCall(this, _, _, _) }

  override predicate blocks(boolean outcome, Expr e) { f.isBarrierCall(this, e, outcome, "") }

  predicate internalBlocksLabel(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    f.isBarrierCall(this, e, outcome, label)
  }

  override predicate appliesTo(Configuration cfg) { f.appliesTo(cfg) }
}

/**
 * A guard node for a variable in a negative condition, such as `x` in `if(!x)`.
 * Can be added to a `isBarrier` in a data-flow configuration to block flow through such checks.
 */
class VarAccessBarrier extends DataFlow::Node {
  VarAccessBarrier() {
    exists(ConditionGuardNode guard, SsaRefinementNode refinement |
      this = DataFlow::ssaDefinitionNode(refinement) and
      refinement.getGuard() = guard and
      guard.getTest() instanceof VarAccess and
      guard.getOutcome() = false
    )
  }
}
