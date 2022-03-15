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
private import semmle.javascript.Unit
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.internal.CachedStages

/**
 * Provides classes for modeling taint propagation.
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
  cached
  abstract class AdditionalSanitizerGuardNode extends SanitizerGuardNode {
    /**
     * Holds if this guard applies to the flow in `cfg`.
     */
    cached
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
   * A taint-propagating data flow edge that should be added to all taint tracking
   * configurations in addition to standard data flow edges.
   *
   * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isAdditionalTaintStep`
   * for analysis-specific taint steps.
   *
   * This class has multiple kinds of `step` predicates; these all have the same
   * effect on taint-tracking configurations. However, the categorization of steps
   * allows some data-flow configurations to opt in to specific kinds of taint steps.
   */
  class SharedTaintStep extends Unit {
    // Each step relation in this class should have a cached version in the `Cached` module
    // and be included in the `sharedTaintStep` predicate.
    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge.
     */
    predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through URI manipulation.
     *
     * Does not include string operations that aren't specific to URIs, such
     * as concatenation and substring operations.
     */
    predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge contributed by the heuristics library.
     *
     * Such steps are provided by the `semmle.javascript.heuristics` libraries
     * and will default to be being empty if those libraries are not imported.
     */
    predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through persistent storage.
     */
    predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through the heap.
     */
    predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through arrays.
     *
     * These steps considers an array to be tainted if it contains tainted elements.
     */
    predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through the `state` or `props` or a React component.
     */
    predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through string concatenation.
     */
    predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through string manipulation (other than concatenation).
     */
    predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through data serialization, such as `JSON.stringify`.
     */
    predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through data deserialization, such as `JSON.parse`.
     */
    predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through a promise.
     *
     * These steps consider a promise object to tainted if it can resolve to
     * a tainted value.
     */
    predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) { none() }
  }

  /**
   * Module existing only to ensure all taint steps are cached as a single stage,
   * and without the the `Unit` type column.
   */
  cached
  private module Cached {
    cached
    predicate forceStage() { Stages::Taint::ref() }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge, which doesn't fit into a more specific category.
     */
    cached
    predicate genericStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).step(pred, succ)
    }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge, contribued by the heuristics library.
     */
    cached
    predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).heuristicStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is an edge contributed by an `AdditionalTaintStep` instance.
     */
    cached
    predicate legacyAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(InternalAdditionalTaintStep step).step(pred, succ)
    }

    /**
     * Public taint step relations.
     */
    cached
    module Public {
      /**
       * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
       * data flow edge through a URI library function.
       */
      cached
      predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).uriStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through persistent storage.
       */
      cached
      predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).persistentStorageStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through the heap.
       */
      cached
      predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).heapStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through an array.
       */
      cached
      predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).arrayStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through the
       * properties of a view compenent, such as the `state` or `props` of a React component.
       */
      cached
      predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).viewComponentStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through string
       * concatenation.
       */
      cached
      predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).stringConcatenationStep(pred, succ)
      }

      /**
       * Holds if `pred -> succ` is a taint propagating data flow edge through string manipulation
       * (other than concatenation).
       */
      cached
      predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).stringManipulationStep(pred, succ)
      }

      /**
       *  Holds if `pred` &rarr; `succ` should be considered a taint-propagating
       * data flow edge through data serialization, such as `JSON.stringify`.
       */
      cached
      predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).serializeStep(pred, succ)
      }

      /**
       * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
       * data flow edge through data deserialization, such as `JSON.parse`.
       */
      cached
      predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).deserializeStep(pred, succ)
      }

      /**
       * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
       * data flow edge through a promise.
       *
       * These steps consider a promise object to tainted if it can resolve to
       * a tainted value.
       */
      cached
      predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) {
        any(SharedTaintStep step).promiseStep(pred, succ)
      }
    }
  }

  import Cached::Public

  /**
   * Holds if `pred -> succ` is a taint propagating data flow edge through a string operation.
   * DEPRECATED: Use `stringConcatenationStep` and `stringManipulationStep` instead.
   */
  pragma[inline]
  deprecated predicate stringStep(DataFlow::Node pred, DataFlow::Node succ) {
    stringConcatenationStep(pred, succ) or
    stringManipulationStep(pred, succ)
  }

  /**
   * Holds if `pred -> succ` is an edge used by all taint-tracking configurations.
   */
  predicate sharedTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    Cached::legacyAdditionalTaintStep(pred, succ) or
    Cached::genericStep(pred, succ) or
    Cached::heuristicStep(pred, succ) or
    uriStep(pred, succ) or
    persistentStorageStep(pred, succ) or
    heapStep(pred, succ) or
    arrayStep(pred, succ) or
    viewComponentStep(pred, succ) or
    stringConcatenationStep(pred, succ) or
    stringManipulationStep(pred, succ) or
    serializeStep(pred, succ) or
    deserializeStep(pred, succ) or
    promiseStep(pred, succ)
  }

  /**
   * DEPRECATED. Subclasses should extend `SharedTaintStep` instead, unless the subclass
   * is part of a query, in which case it should be moved into the `isAdditionalTaintStep` predicate
   * of the relevant taint-tracking configuration.
   * Other uses of the `step` relation in this class should instead use the `TaintTracking::sharedTaintStep`
   * predicate.
   *
   * A taint-propagating data flow edge that should be added to all taint tracking
   * configurations in addition to standard data flow edges.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isAdditionalTaintStep`
   * for analysis-specific taint steps.
   */
  deprecated class AdditionalTaintStep = InternalAdditionalTaintStep;

  /** Internal version of `AdditionalTaintStep` that won't trigger deprecation warnings. */
  abstract private class InternalAdditionalTaintStep extends DataFlow::Node {
    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge.
     */
    abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);
  }

  /** Gets a data flow node referring to the client side URL. */
  private DataFlow::SourceNode clientSideUrlRef(DataFlow::TypeTracker t) {
    t.start() and
    result.(ClientSideRemoteFlowSource).getKind().isUrl()
    or
    exists(DataFlow::TypeTracker t2 | result = clientSideUrlRef(t2).track(t2, t))
  }

  /** Gets a data flow node referring to the client side URL. */
  private DataFlow::SourceNode clientSideUrlRef() {
    result = clientSideUrlRef(DataFlow::TypeTracker::end())
  }

  /**
   * Holds if `read` reads a property of the client-side URL, which is not tainted.
   * In this case, the read is excluded from the default set of taint steps.
   */
  private predicate isSafeClientSideUrlProperty(DataFlow::PropRead read) {
    // Block all properties of client-side URLs, as .hash and .search are considered sources of their own
    read = clientSideUrlRef().getAPropertyRead()
    or
    exists(StringSplitCall c |
      c.getBaseString().getALocalSource() =
        [DOM::locationRef(), DOM::locationRef().getAPropertyRead("href")] and
      c.getSeparator() = "?" and
      read = c.getAPropertyRead("0")
    )
  }

  /**
   * A taint propagating data flow edge through object or array elements and
   * promises.
   */
  private class HeapTaintStep extends SharedTaintStep {
    override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
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
      succ.(DataFlow::PropRead).getBase() = pred and
      not (
        AccessPath::DominatingPaths::hasDominatingWrite(succ) and
        exists(succ.(DataFlow::PropRead).getPropertyName())
      ) and
      not isSafeClientSideUrlProperty(succ) and
      not ClassValidator::isAccessToSanitizedField(succ)
      or
      // iterating over a tainted iterator taints the loop variable
      exists(ForOfStmt fos |
        pred = DataFlow::valueNode(fos.getIterationDomain()) and
        succ = DataFlow::lvalueNode(fos.getLValue())
      )
      or
      // taint-tracking rest patterns in l-values. E.g. `const {...spread} = foo()` or `const [...spread] = foo()`.
      exists(DestructuringPattern pattern |
        pred = DataFlow::lvalueNode(pattern) and
        succ = DataFlow::lvalueNode(pattern.getRest())
      )
    }
  }

  /**
   * A taint propagating data flow edge through persistent storage.
   * Use `TaintTracking::persistentStorageStep` instead of accessing this class.
   */
  private class PersistentStorageTaintStep extends SharedTaintStep {
    override predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(PersistentReadAccess read |
        pred = read.getAWrite().getValue() and
        succ = read
      )
    }
  }

  /**
   * A taint propagating data flow edge for assignments of the form `o[k] = v`, where
   * one of the following holds:
   *
   * - `k` is not a constant and `o` refers to some object literal. The rationale
   *   here is that `o` is most likely being used like a dictionary object.
   *
   * - `k` refers to `o.length`, that is, the assignment is of form `o[o.length] = v`.
   *   In this case, the assignment behaves like `o.push(v)`.
   */
  private class ComputedPropWriteTaintStep extends SharedTaintStep {
    override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(AssignExpr assgn, IndexExpr idx, DataFlow::SourceNode obj |
        assgn.getTarget() = idx and
        obj.flowsToExpr(idx.getBase()) and
        not exists(idx.getPropertyName()) and
        pred = DataFlow::valueNode(assgn.getRhs()) and
        succ = obj
      |
        obj instanceof DataFlow::ObjectLiteralNode
        or
        obj.getAPropertyRead("length").flowsToExpr(idx.getPropertyNameExpr())
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from string concatenations.
   *
   * Note that since we cannot easily distinguish string append from addition,
   * we consider any `+` operation to propagate taint.
   */
  class StringConcatenationTaintStep extends SharedTaintStep {
    override predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) {
      StringConcatenation::taintStep(pred, succ)
    }
  }

  /**
   * A taint propagating data flow edge arising from string manipulation
   * functions defined in the standard library.
   */
  private class StringManipulationTaintStep extends SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node target) {
      exists(DataFlow::ValueNode succ | target = succ |
        // string operations that propagate taint
        exists(string name | name = succ.getAstNode().(MethodCallExpr).getMethodName() |
          pred.asExpr() = succ.getAstNode().(MethodCallExpr).getReceiver() and
          (
            // sorted, interesting, properties of String.prototype
            name =
              [
                "anchor", "big", "blink", "bold", "concat", "fixed", "fontcolor", "fontsize",
                "italics", "link", "padEnd", "padStart", "repeat", "replace", "replaceAll", "slice",
                "small", "split", "strike", "sub", "substr", "substring", "sup",
                "toLocaleLowerCase", "toLocaleUpperCase", "toLowerCase", "toUpperCase", "trim",
                "trimLeft", "trimRight"
              ]
            or
            // sorted, interesting, properties of Object.prototype
            name = ["toString", "valueOf"]
            or
            // sorted, interesting, properties of Array.prototype
            name = "join"
          )
          or
          exists(int i | pred.asExpr() = succ.getAstNode().(MethodCallExpr).getArgument(i) |
            name = "concat"
            or
            name = ["replace", "replaceAll"] and i = 1
          )
        )
        or
        // standard library constructors that propagate taint: `RegExp` and `String`
        exists(DataFlow::InvokeNode invk, string gv | gv = "RegExp" or gv = "String" |
          succ = invk and
          invk = DataFlow::globalVarRef(gv).getAnInvocation() and
          pred = invk.getArgument(0)
        )
        or
        // String.fromCharCode and String.fromCodePoint
        exists(int i, MethodCallExpr mce |
          mce = succ.getAstNode() and
          pred.asExpr() = mce.getArgument(i) and
          (mce.getMethodName() = "fromCharCode" or mce.getMethodName() = "fromCodePoint")
        )
        or
        // `(encode|decode)URI(Component)?` propagate taint
        exists(DataFlow::CallNode c |
          succ = c and
          c =
            DataFlow::globalVarRef([
                "encodeURI", "decodeURI", "encodeURIComponent", "decodeURIComponent"
              ]).getACall() and
          pred = c.getArgument(0)
        )
        or
        // In and out of .replace callbacks
        exists(StringReplaceCall call |
          // Into the callback if the regexp does not sanitize matches
          hasWildcardReplaceRegExp(call) and
          pred = call.getReceiver() and
          succ = call.getReplacementCallback().getParameter(0)
          or
          // Out of the callback
          pred = call.getReplacementCallback().getReturnNode() and
          succ = call
        )
      )
    }
  }

  /** Holds if the given call takes a regexp containing a wildcard. */
  pragma[noinline]
  private predicate hasWildcardReplaceRegExp(StringReplaceCall call) {
    RegExp::isWildcardLike(call.getRegExp().getRoot().getAChild*())
  }

  /**
   * A taint propagating data flow edge arising from string formatting.
   */
  private class StringFormattingTaintStep extends SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
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
    exists(DataFlow::AnalyzedNode analyzed |
      pragma[only_bind_into](analyzed) = result.getReceiver().analyze() and
      analyzed.getAType() = TTRegExp()
    )
  }

  /**
   * A taint-propagating data flow edge from the first (and only) argument in a call to
   * `RegExp.prototype.exec` to its result.
   */
  private class RegExpExecTaintStep extends SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
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
    exists(DataFlow::AnalyzedNode analyzed |
      pragma[only_bind_into](analyzed) = result.getArgument(0).analyze() and
      analyzed.getAType() = TTRegExp()
    )
  }

  /**
   * A taint propagating data flow edge arising from calling `String.prototype.match()`.
   */
  private class StringMatchTaintStep extends SharedTaintStep {
    override predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
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
  private class JsonStringifyTaintStep extends SharedTaintStep {
    override predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(JsonStringifyCall call |
        pred = call.getArgument(0) and
        succ = call
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from JSON parsing.
   */
  private class JsonParserTaintStep extends SharedTaintStep {
    override predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
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
   * Gets a pseudo-property a `URL` that stores a value that can be obtained
   * with a `get` or `getAll` call to the `searchParams` property.
   */
  private string hiddenUrlPseudoProperty() { result = "$hiddenSearchPararms" }

  /**
   * Gets a pseudo-property on a `URLSearchParams` that can be obtained
   * with a `get` or `getAll` call.
   */
  private string getableUrlPseudoProperty() { result = "$gettableSearchPararms" }

  /**
   * A taint propagating data flow edge arising from URL parameter parsing.
   */
  private class UrlSearchParamsTaintStep extends DataFlow::SharedFlowStep {
    /**
     * Holds if `succ` is a `URLSearchParams` providing access to the
     * parameters encoded in `pred`.
     */
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      isUrlSearchParams(succ, pred)
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
      prop = ["searchParams", "hash", "search", hiddenUrlPseudoProperty()] and
      exists(DataFlow::NewNode newUrl | succ = newUrl |
        newUrl = DataFlow::globalVarRef("URL").getAnInstantiation() and
        pred = newUrl.getArgument(0)
      )
      or
      prop = getableUrlPseudoProperty() and
      isUrlSearchParams(succ, pred)
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
  private class SortTaintStep extends SharedTaintStep {
    override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
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
  class ErrorConstructorTaintStep extends SharedTaintStep {
    override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::NewNode invoke, string name |
        invoke = DataFlow::globalVarRef(name).getAnInvocation() and
        pred = invoke.getArgument(0) and
        succ = invoke
      |
        name =
          [
            "Error", "EvalError", "RangeError", "ReferenceError", "SyntaxError", "TypeError",
            "URIError"
          ]
      )
    }
  }

  private module RegExpCaptureSteps {
    /** Gets a reference to a string derived from the most recent RegExp match, such as `RegExp.$1`. */
    private DataFlow::PropRead getAStaticCaptureRef() {
      result =
        DataFlow::globalVarRef("RegExp")
            .getAPropertyRead([
                "$" + [1 .. 9], "input", "lastMatch", "leftContext", "rightContext", "$&", "$^",
                "$`"
              ])
    }

    /**
     * Gets a control-flow node where `input` is used in a RegExp match.
     */
    private ControlFlowNode getACaptureSetter(DataFlow::Node input) {
      exists(DataFlow::MethodCallNode call | result = call.asExpr() |
        call.getMethodName() = ["search", "replace", "replaceAll", "match"] and
        input = call.getReceiver()
        or
        call.getMethodName() = ["test", "exec"] and input = call.getArgument(0)
      )
    }

    /**
     * Gets a control-flow node that can locally reach the given static capture reference
     * without passing through a capture setter.
     *
     * This is essentially an intraprocedural def-use analysis that ignores potential
     * side effects from calls.
     */
    private ControlFlowNode getANodeReachingCaptureRef(DataFlow::PropRead read) {
      result = read.asExpr() and
      read = getAStaticCaptureRef()
      or
      exists(ControlFlowNode mid |
        result = getANodeReachingCaptureRefAux(read, mid) and
        not mid = getACaptureSetter(_)
      )
    }

    pragma[nomagic]
    private ControlFlowNode getANodeReachingCaptureRefAux(
      DataFlow::PropRead read, ControlFlowNode mid
    ) {
      mid = getANodeReachingCaptureRef(read) and
      result = mid.getAPredecessor()
    }

    /**
     * A step `pred -> succ` from the input of a RegExp match to a static property of `RegExp`.
     */
    private class StaticRegExpCaptureStep extends SharedTaintStep {
      override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
        getACaptureSetter(pred) = getANodeReachingCaptureRef(succ)
        or
        exists(StringReplaceCall replace |
          getANodeReachingCaptureRef(succ) =
            replace.getReplacementCallback().getFunction().getEntry() and
          pred = replace.getReceiver()
        )
      }
    }
  }

  /**
   * A taint step through the Node.JS function `util.inspect(..)`.
   */
  class UtilInspectTaintStep extends SharedTaintStep {
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
        unique(InferredType tp | tp = pragma[only_bind_into](undef.getAType())) = TTUndefined()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity().booleanNot() and
      e = x
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /** A check of the form `type x === "undefined"`, which sanitized `x` in its "then" branch. */
  class TypeOfUndefinedSanitizer extends AdditionalSanitizerGuardNode, DataFlow::ValueNode {
    Expr x;
    override EqualityTest astNode;

    TypeOfUndefinedSanitizer() { isTypeofGuard(astNode, x, "undefined") }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = astNode.getPolarity() and
      e = x
    }

    override predicate appliesTo(Configuration cfg) { any() }
  }

  /**
   * Holds if `test` is a guard that checks if `operand` is typeof `tag`.
   *
   * See `TypeOfUndefinedSanitizer` for example usage.
   */
  predicate isTypeofGuard(EqualityTest test, Expr operand, TypeofTag tag) {
    exists(Expr str, TypeofExpr typeof | test.hasOperands(str, typeof) |
      str.mayHaveStringValue(tag) and
      typeof.getOperand() = operand
    )
  }

  /** Holds if `guard` is a test that checks if `operand` is a number. */
  predicate isNumberGuard(DataFlow::Node guard, Expr operand, boolean polarity) {
    exists(DataFlow::CallNode isNaN |
      isNaN = DataFlow::globalVarRef("isNaN").getACall() and guard = isNaN and polarity = false
    |
      operand = isNaN.getArgument(0).asExpr()
      or
      exists(DataFlow::CallNode parse |
        parse = DataFlow::globalVarRef(["parseInt", "parseFloat"]).getACall()
      |
        parse = isNaN.getArgument(0) and
        operand = parse.getArgument(0).asExpr()
      )
      or
      exists(UnaryExpr unary | unary.getOperator() = ["+", "-"] |
        unary = isNaN.getArgument(0).asExpr() and
        operand = unary.getOperand()
      )
      or
      exists(BinaryExpr bin | bin.getOperator() = ["+", "-"] |
        bin = isNaN.getArgument(0).asExpr() and
        operand = bin.getAnOperand() and
        bin.getAnOperand() instanceof NumberLiteral
      )
    )
    or
    isTypeofGuard(guard.asExpr(), operand, "number") and
    polarity = guard.asExpr().(EqualityTest).getPolarity()
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

  /**
   * A check of the form `whitelist.includes(x)` or equivalent, which sanitizes `x` in its "then" branch.
   */
  class MembershipTestSanitizer extends AdditionalSanitizerGuardNode {
    MembershipCandidate candidate;

    MembershipTestSanitizer() { this = candidate.getTest() }

    override predicate sanitizes(boolean outcome, Expr e) {
      candidate = e.flow() and candidate.getTestPolarity() = outcome
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
   * DEPRECATED: Use `TaintTracking::sharedTaintStep` and `DataFlow::Node::getALocalSource()` instead.
   */
  deprecated predicate localTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    DataFlow::localFlowStep(pred, succ) or
    sharedTaintStep(pred, succ)
  }
}
