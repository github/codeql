/**
 * Provides classes for performing customized taint tracking.
 *
 * The classes in this module allow performing inter-procedural taint tracking
 * from a custom set of source nodes to a custom set of sink nodes. In addition
 * to normal data flow edges, taint is propagated along _taint edges_ that do
 * not preserve the value of their input but only its taintedness, such as taking
 * substrings. As for data flow configurations, additional flow edges can be
 * specified, and conversely certain nodes or edges can be designated as taint
 * _sanitizers_ that block flow.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 */

import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
private import semmle.javascript.dataflow.internal.Unit
private import semmle.javascript.dataflow.InferredTypes

/**
 * Provides classes for modelling taint propagation.
 */
module TaintTracking {
  /**
   * A data flow tracking configuration that considers taint propagation through
   * objects, arrays, promises and strings in addition to standard data flow.
   *
   * If a different set of flow edges is desired, extend this class and override
   * `isAdditionalTaintStep`.
   */
  abstract class Configuration extends DataFlow::Configuration {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant taint source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate isSource(DataFlow::Node source) { super.isSource(source) }

    /**
     * Holds if `sink` is a relevant taint sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate isSink(DataFlow::Node sink) { super.isSink(sink) }

    /**
     * Holds if the intermediate node `node` is a taint sanitizer, that is,
     * tainted values can not flow into or out of `node`.
     *
     * Note that this only blocks flow through nodes that operate directly on the tainted value.
     * An object _containing_ a tainted value in a property can still flow into and out of `node`.
     * To block such objects, override `isBarrier` or use a labeled sanitizer to block the `data` flow label.
     *
     * For operations that _check_ if a value is tainted or safe, use `isSanitizerGuard` instead.
     */
    predicate isSanitizer(DataFlow::Node node) { none() }

    /**
     * DEPRECATED: Use `isSanitizerEdge` instead.
     *
     * Holds if the edge from `source` to `sink` is a taint sanitizer.
     */
    deprecated predicate isSanitizer(DataFlow::Node source, DataFlow::Node sink) { none() }

    /**
     * DEPRECATED: Use `isSanitizerEdge` instead.
     *
     * Holds if the edge from `source` to `sink` is a taint sanitizer for data labelled with `lbl`.
     */
    deprecated predicate isSanitizer(
      DataFlow::Node source, DataFlow::Node sink, DataFlow::FlowLabel lbl
    ) {
      none()
    }

    /** Holds if the edge from `pred` to `succ` is a taint sanitizer. */
    predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /** Holds if the edge from `pred` to `succ` is a taint sanitizer for data labelled with `lbl`. */
    predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel lbl) {
      none()
    }

    /**
     * Holds if data flow node `guard` can act as a sanitizer when appearing
     * in a condition.
     *
     * For example, if `guard` is the comparison expression in
     * `if(x == 'some-constant'){ ... x ... }`, it could sanitize flow of
     * `x` into the "then" branch.
     *
     * Node that this only handles checks that operate directly on the tainted value.
     * Objects that _contain_ a tainted value in a property may still flow across the check.
     * To block such objects, use a labeled sanitizer guard to block the `data` label.
     */
    predicate isSanitizerGuard(SanitizerGuardNode guard) { none() }

    override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
      super.isLabeledBarrier(node, lbl)
      or
      isSanitizer(node) and lbl.isTaint()
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node)
      or
      // For variable accesses we block both the data and taint label, as a falsy value
      // can't be an object, and thus can't have any tainted properties.
      node instanceof DataFlow::VarAccessBarrier
    }

    final override predicate isBarrierEdge(
      DataFlow::Node source, DataFlow::Node sink, DataFlow::FlowLabel lbl
    ) {
      super.isBarrierEdge(source, sink, lbl)
      or
      isSanitizerEdge(source, sink, lbl)
      or
      isSanitizerEdge(source, sink) and lbl.isTaint()
    }

    final override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      super.isBarrierGuard(guard) or
      guard.(AdditionalSanitizerGuardNode).appliesTo(this) or
      isSanitizerGuard(guard)
    }

    /**
     * Holds if the additional taint propagation step from `pred` to `succ`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      isAdditionalTaintStep(pred, succ) or
      sharedTaintStep(pred, succ)
    }

    final override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, boolean valuePreserving
    ) {
      isAdditionalFlowStep(pred, succ) and valuePreserving = false
    }

    override DataFlow::FlowLabel getDefaultSourceLabel() { result.isTaint() }
  }

  /**
   * A `SanitizerGuardNode` that controls which taint tracking
   * configurations it is used in.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isSanitizerGuard`
   * for analysis-specific taint sanitizer guards.
   */
  abstract class AdditionalSanitizerGuardNode extends SanitizerGuardNode {
    /**
     * Holds if this guard applies to the flow in `cfg`.
     */
    abstract predicate appliesTo(Configuration cfg);
  }

  /**
   * A node that can act as a sanitizer when appearing in a condition.
   *
   * To add a sanitizer guard to a configuration, define a subclass of this class overriding the
   * `sanitizes` predicate, and then extend the configuration's `isSanitizerGuard` predicate to
   * include the new class.
   *
   * Note that it is generally a good idea to make the characteristic predicate of sanitizer guard
   * classes as precise as possible: if two subclasses of `SanitizerGuardNode` overlap, their
   * implementations of `sanitizes` will _both_ apply to any configuration that includes either of
   * them.
   */
  abstract class SanitizerGuardNode extends DataFlow::BarrierGuardNode {
    override predicate blocks(boolean outcome, Expr e) { none() }

    /**
     * Holds if this node sanitizes expression `e`, provided it evaluates
     * to `outcome`.
     */
    abstract predicate sanitizes(boolean outcome, Expr e);

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      sanitizes(outcome, e) and label.isTaint()
      or
      sanitizes(outcome, e, label)
    }

    /**
     * Holds if this node sanitizes expression `e`, provided it evaluates
     * to `outcome`.
     */
    predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) { none() }
  }

  /**
   * A sanitizer guard node that only blocks specific flow labels.
   */
  abstract class LabeledSanitizerGuardNode extends SanitizerGuardNode, DataFlow::BarrierGuardNode {
    override predicate sanitizes(boolean outcome, Expr e) { none() }
  }

  /**
   * A class of taint-propagating data flow edges that should be added to all taint tracking
   * configurations in addition to standard data flow edges.
   *
   * This class should rarely be subclassed directly; prefer one of the specific subclasses
   * such as `TaintTracking::HeapStep`.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isAdditionalTaintStep`
   * for analysis-specific taint steps.
   */
  abstract class SharedTaintStep extends string {
    bindingset[this]
    SharedTaintStep() { any() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge.
     */
    predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }
  }

  cached
  private predicate sharedTaintStepInternal(
    DataFlow::Node pred, DataFlow::Node succ, SharedTaintStep kind
  ) {
    kind.step(pred, succ)
  }

  /**
   * A class of taint-propagating data flow edges that don't belong to any of the more
   * specific categories such as `TaintTracking::HeapStep`.
   */
  class GenericStep extends SharedTaintStep {
    GenericStep() { this = "GenericStep" }
  }

  /**
   * A class of taint-propagating data flow edges through URI manipulation.
   *
   * Does not include string operations that aren't specific to URIs, such
   * as concatenation and substring operations.
   */
  class UriStep extends SharedTaintStep {
    UriStep() { this = "UriStep" }
  }

  /**
   * A class of taint-propagating data flow edges contributed by the heuristics library.
   *
   * Such steps are provided by the `semmle.javascript.heuristics` libraries
   * and will default to be being empty if those libraries are not imported.
   */
  class HeuristicStep extends SharedTaintStep {
    HeuristicStep() { this = "HeuristicStep" }
  }

  /**
   * A class of taint-propagating data flow edges through persistent storage,
   * such as cookies.
   */
  class PersistentStorageStep extends SharedTaintStep {
    PersistentStorageStep() { this = "PersistentStorageStep" }
  }

  /**
   * A class of taint-propagating data flow edges through the heap.
   *
   * The general assumption made by these steps are:
   * - A tainted object has tainted properties.
   * - An object with a tainted property name is tainted.
   *   - However, a tainted property _value_ is not generally enough to
   *     consider the whole object tainted.
   */
  class HeapStep extends SharedTaintStep {
    HeapStep() { this = "HeapStep" }
  }

  /**
   * A class of taint-propagating data flow edges through arrays.
   *
   * The general assumption made by these steps are:
   * - A tainted array has tainted array elements.
   * - An array with a tainted element is tainted.
   */
  class ArrayStep extends SharedTaintStep {
    ArrayStep() { this = "ArrayStep" }
  }

  /**
   * A class of taint-propagating data flow edges through a view component,
   * such as the `state` or `props` or a React component.
   */
  class ViewComponentStep extends SharedTaintStep {
    ViewComponentStep() { this = "ViewComponentStep" }
  }

  /**
   * A class of taint-propagating data flow edges through string concatenation.
   */
  class StringConcatenationStep extends SharedTaintStep {
    StringConcatenationStep() { this = "StringConcatenationStep" }
  }

  /**
   * A class of taint-propagating data flow edges through string manipulation (other than concatenation).
   */
  class StringManipulationStep extends SharedTaintStep {
    StringManipulationStep() { this = "StringManipulationStep" }
  }

  /**
   * A class of taint-propagating data flow edges through data serialization, such as `JSON.stringify`.
   */
  class SerializeStep extends SharedTaintStep {
    SerializeStep() { this = "SerializeStep" }
  }

  /**
   * A class of taint-propagating data flow edges through data deserialization, such as `JSON.parse`.
   */
  class DeserializeStep extends SharedTaintStep {
    DeserializeStep() { this = "DeserializeStep" }
  }

  /**
   * A class of taint-propagating data flow edges through string encoding, such as `encodeURIComponent`
   * or `Buffer.from` (creating a binary encoding of a string).
   *
   * Encoding a string can have the effect of neutralizing meta-characters. For this reason, not all string-encoding
   * operations are included in this category; only those deemed useful for general-purpose taint tracking.
   * In particular, base64 encoding is not included.
   */
  class EncodingStep extends SharedTaintStep {
    EncodingStep() { this = "EncodingStep" }
  }

  /**
   * A class of taint-propagating data flow edges through string decoding, such as `decodeURIComponent`
   * or base64 decoding.
   *
   * For practical reasons this category does not include `toString` calls,
   * even though `Buffer.toString` could be seen as a decoding step.
   */
  class DecodingStep extends SharedTaintStep {
    DecodingStep() { this = "DecodingStep" }
  }

  /**
   * A class of taint-propagating data flow edges through a promise.
   *
   * The general assumption made by these steps are:
   * - A promise object is tainted iff it can succeed with a tainted value.
   */
  class PromiseStep extends SharedTaintStep {
    PromiseStep() { this = "PromiseStep" }
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through a URI library function.
   */
  predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(UriStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through persistent storage.
   */
  predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(PersistentStorageStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through the heap.
   */
  predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(HeapStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through an array.
   */
  predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(ArrayStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through the
   * properties of a view compenent, such as the `state` or `props` of a React component.
   */
  predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(ViewComponentStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through string
   * concatenation.
   */
  predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(StringConcatenationStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through string manipulation
   * (other than concatenation).
   */
  predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(StringManipulationStep step))
  }

  /**
   *  Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data serialization, such as `JSON.stringify`.
   */
  predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(SerializeStep step))
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data deserialization, such as `JSON.parse`.
   */
  predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(DeserializeStep step))
  }

  /**
   *  Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through string encoding, such as `encodeURIComponent`.
   */
  predicate encodingStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(EncodingStep step))
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data decoding, such as `decodeURIComponent`.
   */
  predicate decodingStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(DecodingStep step))
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through a promise.
   *
   * These steps consider a promise object to tainted if it can resolve to
   * a tainted value.
   */
  predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) {
    sharedTaintStepInternal(pred, succ, any(PromiseStep step))
  }

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through a string operation.
   */
  pragma[inline]
  predicate stringStep(DataFlow::Node pred, DataFlow::Node succ) {
    stringConcatenationStep(pred, succ) or
    stringManipulationStep(pred, succ)
  }

  /**
   * Holds if `pred -> succ` is an edge used by all taint-tracking configurations.
   */
  predicate sharedTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalTaintStep s).step(pred, succ) or
    sharedTaintStepInternal(pred, succ, _)
  }

  /**
   * A taint-propagating data flow edge that should be added to all taint tracking
   * configurations in addition to standard data flow edges.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isAdditionalTaintStep`
   * for analysis-specific taint steps.
   */
  abstract class AdditionalTaintStep extends DataFlow::Node {
    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge.
     */
    abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * A taint propagating data flow edge through object or array elements and
   * promises.
   */
  private class DefaultHeapStep extends HeapStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Expr e, Expr f | e = succ.asExpr() and f = pred.asExpr() |
        exists(Property prop | e.(ObjectExpr).getAProperty() = prop |
          prop.isComputed() and f = prop.getNameExpr()
        )
        or
        // spreading a tainted object into an object literal gives a tainted object
        e.(ObjectExpr).getAProperty().(SpreadProperty).getInit().(SpreadElement).getOperand() = f
        or
        // spreading a tainted value into an array literal gives a tainted array
        e.(ArrayExpr).getAnElement().(SpreadElement).getOperand() = f
      )
      or
      // arrays with tainted elements and objects with tainted property names are tainted
      succ.(DataFlow::ArrayCreationNode).getAnElement() = pred and
      not any(PromiseAllCreation call).getArrayNode() = succ
      or
      // reading from a tainted object yields a tainted result
      succ.(DataFlow::PropRead).getBase() = pred
      or
      // iterating over a tainted iterator taints the loop variable
      exists(ForOfStmt fos |
        pred = DataFlow::valueNode(fos.getIterationDomain()) and
        succ = DataFlow::lvalueNode(fos.getLValue())
      )
    }
  }

  /**
   * DEPRECATED. Use the predicate `TaintTracking::persistentStorageStep` instead.
   *
   * A taint propagating data flow edge through persistent storage.
   */
  deprecated class DefaultPersistentStorageStep extends PersistentStorageStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(PersistentReadAccess read |
        pred = read.getAWrite().getValue() and
        succ = read
      )
    }
  }

  deprecated predicate arrayFunctionTaintStep = ArrayTaintTracking::arrayFunctionTaintStep/3;

  /**
   * A taint propagating data flow edge for assignments of the form `o[k] = v`, where
   * `k` is not a constant and `o` refers to some object literal; in this case, we consider
   * taint to flow from `v` to that object literal.
   *
   * The rationale for this heuristic is that if properties of `o` are accessed by
   * computed (that is, non-constant) names, then `o` is most likely being treated as
   * a map, not as a real object. In this case, it makes sense to consider the entire
   * map to be tainted as soon as one of its entries is.
   */
  private class DictionaryTaintStep extends HeapStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(AssignExpr assgn, IndexExpr idx, DataFlow::ObjectLiteralNode obj |
        assgn.getTarget() = idx and
        obj.flowsToExpr(idx.getBase()) and
        not exists(idx.getPropertyName()) and
        pred = DataFlow::valueNode(assgn.getRhs()) and
        succ = obj
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from string concatenations.
   *
   * Note that since we cannot easily distinguish string append from addition,
   * we consider any `+` operation to propagate taint.
   */
  class StringConcatenationTaintStep extends StringConcatenationStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      StringConcatenation::taintStep(pred, succ)
    }
  }

  /**
   * A taint propagating data flow edge arising from string manipulation
   * functions defined in the standard library.
   */
  private class StringManipulationTaintStep extends StringManipulationStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node target) {
      exists(DataFlow::ValueNode succ | target = succ |
        // string operations that propagate taint
        exists(string name | name = succ.getAstNode().(MethodCallExpr).getMethodName() |
          pred.asExpr() = succ.getAstNode().(MethodCallExpr).getReceiver() and
          (
            // sorted, interesting, properties of String.prototype
            name = "anchor" or
            name = "big" or
            name = "blink" or
            name = "bold" or
            name = "concat" or
            name = "fixed" or
            name = "fontcolor" or
            name = "fontsize" or
            name = "italics" or
            name = "link" or
            name = "padEnd" or
            name = "padStart" or
            name = "repeat" or
            name = "replace" or
            name = "slice" or
            name = "small" or
            name = "split" or
            name = "strike" or
            name = "sub" or
            name = "substr" or
            name = "substring" or
            name = "sup" or
            name = "toLocaleLowerCase" or
            name = "toLocaleUpperCase" or
            name = "toLowerCase" or
            name = "toUpperCase" or
            name = "trim" or
            name = "trimLeft" or
            name = "trimRight" or
            // sorted, interesting, properties of Object.prototype
            name = "toString" or
            name = "valueOf" or
            // sorted, interesting, properties of Array.prototype
            name = "join"
          )
          or
          exists(int i | pred.asExpr() = succ.getAstNode().(MethodCallExpr).getArgument(i) |
            name = "concat"
            or
            name = "replace" and i = 1
          )
        )
        or
        // standard library constructors that propagate taint: `RegExp` and `String`
        exists(DataFlow::InvokeNode invk, string gv | gv = "RegExp" or gv = "String" |
          succ = invk and
          invk = DataFlow::globalVarRef(gv).getAnInvocation() and
          pred = invk.getArgument(0)
        )
      )
    }
  }

  /**
   * Taint step through `String.fromCharCode` and `String.fromCodePoint`.
   */
  private class StringDecodingStep extends DecodingStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["fromCharCode", "fromCodePoint"] and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * Taint step through `decodeURI` and `decodeURIComponent`.
   */
  private class UriDecodingStep extends DecodingStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::globalVarRef(["decodeURI", "decodeURIComponent"]).getACall() and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * Taint step through `encodeURI` and `encodeURIComponent`.
   */
  private class UriEncodingStep extends EncodingStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::globalVarRef(["encodeURI", "encodeURIComponent"]).getACall() and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from string formatting.
   */
  private class StringFormattingTaintStep extends StringManipulationStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(PrintfStyleCall call |
        call.returnsFormatted() and
        succ = call
      |
        pred = call.getFormatString()
        or
        pred = call.getFormatArgument(_)
      )
    }
  }

  pragma[nomagic]
  private DataFlow::MethodCallNode execMethodCall() {
    result.getMethodName() = "exec" and
    result.getReceiver().analyze().getAType() = TTRegExp()
  }

  /**
   * A taint-propagating data flow edge from the first (and only) argument in a call to
   * `RegExp.prototype.exec` to its result.
   */
  private class RegExpExecTaintStep extends StringManipulationStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::MethodCallNode call |
        call = execMethodCall() and
        call.getNumArgument() = 1 and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  pragma[nomagic]
  private DataFlow::MethodCallNode matchMethodCall() {
    result.getMethodName() = "match" and
    result.getArgument(0).analyze().getAType() = TTRegExp()
  }

  /**
   * A taint propagating data flow edge arising from calling `String.prototype.match()`.
   */
  private class StringMatchTaintStep extends StringManipulationStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::MethodCallNode call |
        call = matchMethodCall() and
        call.getNumArgument() = 1 and
        pred = call.getReceiver() and
        succ = call
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from JSON unparsing.
   */
  private class JsonStringifyTaintStep extends SerializeStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::globalVarRef("JSON").getAMemberCall("stringify") and
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from JSON parsing.
   */
  private class JsonParserTaintStep extends DeserializeStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(JsonParserCall call |
        pred = call.getInput() and
        succ = call.getOutput()
      )
    }
  }

  /**
   * Holds if `params` is a construction of a `URLSearchParams` that parses
   * the parameters in `input`.
   */
  predicate isUrlSearchParams(DataFlow::SourceNode params, DataFlow::Node input) {
    exists(DataFlow::GlobalVarRefNode urlSearchParams, NewExpr newUrlSearchParams |
      urlSearchParams.getName() = "URLSearchParams" and
      newUrlSearchParams = urlSearchParams.getAnInstantiation().asExpr() and
      params.asExpr() = newUrlSearchParams and
      input.asExpr() = newUrlSearchParams.getArgument(0)
    )
  }

  /**
   * A pseudo-property a `URL` that stores a value that can be obtained
   * with a `get` or `getAll` call to the `searchParams` property.
   */
  private string hiddenUrlPseudoProperty() { result = "$hiddenSearchPararms" }

  /**
   * A pseudo-property on a `URLSearchParams` that can be obtained
   * with a `get` or `getAll` call.
   */
  private string getableUrlPseudoProperty() { result = "$gettableSearchPararms" }

  /**
   * A taint propagating data flow edge arising from URL parameter parsing.
   */
  private class UrlSearchParamsTaintStep extends DataFlow::AdditionalFlowStep, DataFlow::ValueNode {
    /**
     * Holds if `succ` is a `URLSearchParams` providing access to the
     * parameters encoded in `pred`.
     */
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      isUrlSearchParams(succ, pred) and succ = this
    }

    /**
     * Holds if `pred` should be stored in the object `succ` under the property `prop`.
     *
     * This step is used to model 3 facts:
     * 1) A `URL` constructed using `url = new URL(input)` transfers taint from `input` to `url.searchParams`, `url.hash`, and `url.search`.
     * 2) Accessing the `searchParams` on a `URL` results in a `URLSearchParams` object (See the loadStoreStep method on this class and hiddenUrlPseudoProperty())
     * 3) A `URLSearchParams` object (either `url.searchParams` or `new URLSearchParams(input)`) has a tainted value,
     *    which can be accessed using a `get` or `getAll` call. (See getableUrlPseudoProperty())
     */
    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      succ = this and
      (
        prop = ["searchParams", "hash", "search", hiddenUrlPseudoProperty()] and
        exists(DataFlow::NewNode newUrl | succ = newUrl |
          newUrl = DataFlow::globalVarRef("URL").getAnInstantiation() and
          pred = newUrl.getArgument(0)
        )
        or
        prop = getableUrlPseudoProperty() and
        isUrlSearchParams(succ, pred)
      )
    }

    /**
     * Holds if the property `loadStep` should be copied from the object `pred` to the property `storeStep` of object `succ`.
     *
     * This step is used to copy the value of our pseudo-property that can later be accessed using a `get` or `getAll` call.
     * For an expression `url.searchParams`, the property `hiddenUrlPseudoProperty()` from the `url` object is stored in the property `getableUrlPseudoProperty()` on `url.searchParams`.
     */
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
    ) {
      succ = this and
      loadProp = hiddenUrlPseudoProperty() and
      storeProp = getableUrlPseudoProperty() and
      exists(DataFlow::PropRead read | read = succ |
        read.getPropertyName() = "searchParams" and
        read.getBase() = pred
      )
    }

    /**
     * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
     *
     * This step is used to load the value stored in the pseudo-property `getableUrlPseudoProperty()`.
     */
    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      succ = this and
      prop = getableUrlPseudoProperty() and
      // this is a call to `get` or `getAll` on a `URLSearchParams` object
      exists(string m, DataFlow::MethodCallNode call | call = succ |
        call.getMethodName() = m and
        call.getReceiver() = pred and
        m.matches("get%")
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from sorting.
   */
  private class SortTaintStep extends HeapStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "sort" and
        pred = call.getReceiver() and
        succ = call
      )
    }
  }

  /**
   * A taint step through an exception constructor, such as `x` to `new Error(x)`.
   */
  class ErrorConstructorTaintStep extends HeapStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::NewNode invoke, string name |
        invoke = DataFlow::globalVarRef(name).getAnInvocation() and
        pred = invoke.getArgument(0) and
        succ = invoke
      |
        name = "Error" or
        name = "EvalError" or
        name = "RangeError" or
        name = "ReferenceError" or
        name = "SyntaxError" or
        name = "TypeError" or
        name = "URIError"
      )
    }
  }

  /**
   * A taint step through the Node.JS function `util.inspect(..)`.
   */
  class UtilInspectTaintStep extends GenericStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::moduleImport("util").getAMemberCall("inspect") and
        call.getAnArgument() = pred and
        succ = call
      )
    }
  }

  /**
   * A conditional checking a tainted string against a regular expression, which is
   * considered to be a sanitizer for all configurations.
   */
  class SanitizingRegExpTest extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    Expr expr;
    boolean sanitizedOutcome;

    SanitizingRegExpTest() {
      exists(MethodCallExpr mce, Expr base, string m, Expr firstArg |
        mce = astNode and mce.calls(base, m) and firstArg = mce.getArgument(0)
      |
        // /re/.test(u) or /re/.exec(u)
        RegExp::isGenericRegExpSanitizer(RegExp::getRegExpObjectFromNode(base.flow()),
          sanitizedOutcome) and
        (m = "test" or m = "exec") and
        firstArg = expr
        or
        // u.match(/re/) or u.match("re")
        base = expr and
        m = "match" and
        RegExp::isGenericRegExpSanitizer(RegExp::getRegExpFromNode(firstArg.flow()),
          sanitizedOutcome)
      )
      or
      // m = /re/.exec(u) and similar
      exists(SanitizingRegExpTest other |
        other = DataFlow::valueNode(astNode.(AssignExpr).getRhs()) and
        expr = other.getSanitizedExpr() and
        sanitizedOutcome = other.getSanitizedOutcome()
      )
    }

    private Expr getSanitizedExpr() { result = expr }

    private boolean getSanitizedOutcome() { result = sanitizedOutcome }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = sanitizedOutcome and
      e = expr
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * A check of the form `if(o.<contains>(x))`, which sanitizes `x` in its "then" branch.
   *
   * `<contains>` is one of: `contains`, `has`, `hasOwnProperty`
   *
   * Note that the `includes` method is covered by `StringInclusionSanitizer`.
   */
  class WhitelistContainmentCallSanitizer extends AdditionalSanitizerGuardNode,
    DataFlow::MethodCallNode {
    WhitelistContainmentCallSanitizer() {
      exists(string name |
        name = "contains" or
        name = "has" or
        name = "hasOwnProperty"
      |
        getMethodName() = name
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      e = getArgument(0).asExpr()
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * A check of the form `if(<isWhitelisted>(x))`, which sanitizes `x` in its "then" branch.
   *
   * `<isWhitelisted>` is a call with callee name 'safe', 'whitelist', 'allow', or similar.
   *
   * This sanitizer is not enabled by default.
   */
  class AdHocWhitelistCheckSanitizer extends SanitizerGuardNode, DataFlow::CallNode {
    AdHocWhitelistCheckSanitizer() {
      getCalleeName()
          .regexpMatch("(?i).*((?<!un)safe|whitelist|(?<!in)valid|allow|(?<!un)auth(?!or\\b)).*") and
      getNumArgument() = 1
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      e = getArgument(0).asExpr()
    }
  }

  /** A check of the form `if(x in o)`, which sanitizes `x` in its "then" branch. */
  class InSanitizer extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    override InExpr astNode;

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      e = astNode.getLeftOperand()
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /** A check of the form `if(o[x] != undefined)`, which sanitizes `x` in its "then" branch. */
  class UndefinedCheckSanitizer extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    Expr x;
    override EqualityTest astNode;

    UndefinedCheckSanitizer() {
      exists(IndexExpr idx, DataFlow::AnalyzedNode undef |
        astNode.hasOperands(idx, undef.asExpr())
      |
        // one operand is of the form `o[x]`
        idx = astNode.getAnOperand() and
        idx.getPropertyNameExpr() = x and
        // and the other one is guaranteed to be `undefined`
        forex(InferredType tp | tp = undef.getAType() | tp = TTUndefined())
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity().booleanNot() and
      e = x
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * A test of form `x.length === "0"`, preventing `x` from being tainted.
   */
  class IsEmptyGuard extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    override EqualityTest astNode;
    boolean polarity;
    Expr operand;

    IsEmptyGuard() {
      astNode.getPolarity() = polarity and
      astNode.getAnOperand().(ConstantExpr).getIntValue() = 0 and
      exists(DataFlow::PropRead read | read.asExpr() = astNode.getAnOperand() |
        read.getBase().asExpr() = operand and
        read.getPropertyName() = "length"
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) { polarity = outcome and e = operand }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /** DEPRECATED. This class has been renamed to `InclusionSanitizer`. */
  deprecated class StringInclusionSanitizer = InclusionSanitizer;

  /** A check of the form `whitelist.includes(x)` or equivalent, which sanitizes `x` in its "then" branch. */
  class InclusionSanitizer extends AdditionalSanitizerGuardNode {
    InclusionTest inclusion;

    InclusionSanitizer() { this = inclusion }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = inclusion.getPolarity() and
      e = inclusion.getContainedNode().asExpr()
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * A check of form `x.indexOf(y) > 0` or similar, which sanitizes `y` in the "then" branch.
   *
   * The more typical case of `x.indexOf(y) >= 0` is covered by `StringInclusionSanitizer`.
   */
  class PositiveIndexOfSanitizer extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override RelationalComparison astNode;

    PositiveIndexOfSanitizer() {
      indexOf.getMethodName() = "indexOf" and
      exists(int bound |
        astNode.getGreaterOperand() = indexOf and
        astNode.getLesserOperand().getIntValue() = bound and
        bound >= 0
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      e = indexOf.getArgument(0)
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /** Gets a variable that is defined exactly once. */
  private Variable singleDef() { strictcount(result.getADefinition()) = 1 }

  /** A check of the form `if(x == 'some-constant')`, which sanitizes `x` in its "then" branch. */
  class ConstantComparison extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    Expr x;
    override EqualityTest astNode;

    ConstantComparison() {
      exists(Expr const | astNode.hasOperands(x, const) |
        // either the other operand is a constant
        const instanceof ConstantExpr
        or
        // or it's an access to a variable that probably acts as a symbolic constant
        const = singleDef().getAnAccess()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity() and x = e
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * An equality test on `e.origin` or `e.source` where `e` is a `postMessage` event object,
   * considered as a sanitizer for `e`.
   */
  private class PostMessageEventSanitizer extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    VarAccess event;
    override EqualityTest astNode;

    PostMessageEventSanitizer() {
      exists(string prop | prop = "origin" or prop = "source" |
        astNode.getAnOperand().(PropAccess).accesses(event, prop) and
        event.mayReferToParameter(any(PostMessageEventHandler h).getEventParameter())
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity() and
      e = event
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * Holds if taint propagates from `pred` to `succ` in one local (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    DataFlow::localFlowStep(pred, succ) or
    sharedTaintStep(pred, succ)
  }
}
