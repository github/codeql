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

    /** Holds if the intermediate node `node` is a taint sanitizer. */
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
     */
    predicate isSanitizerGuard(SanitizerGuardNode guard) { none() }

    final override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      isSanitizer(node)
    }

    final override predicate isBarrierEdge(DataFlow::Node source, DataFlow::Node sink) {
      super.isBarrierEdge(source, sink) or
      isSanitizerEdge(source, sink)
    }

    final override predicate isBarrierEdge(
      DataFlow::Node source, DataFlow::Node sink, DataFlow::FlowLabel lbl
    ) {
      super.isBarrierEdge(source, sink, lbl) or
      isSanitizerEdge(source, sink, lbl)
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
      any(AdditionalTaintStep dts).step(pred, succ)
    }

    final override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, boolean valuePreserving
    ) {
      isAdditionalFlowStep(pred, succ) and valuePreserving = false
    }
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
    override predicate blocks(boolean outcome, Expr e) { sanitizes(outcome, e) }

    /**
     * Holds if this node sanitizes expression `e`, provided it evaluates
     * to `outcome`.
     */
    abstract predicate sanitizes(boolean outcome, Expr e);

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
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
    final override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      sanitizes(outcome, e, label)
    }

    override predicate sanitizes(boolean outcome, Expr e) { none() }
  }

  /**
   * A taint-propagating data flow edge that should be added to all taint tracking
   * configurations in addition to standard data flow edges.
   *
   * Note: For performance reasons, all subclasses of this class should be part
   * of the standard library. Override `Configuration::isAdditionalTaintStep`
   * for analysis-specific taint steps.
   */
  cached
  abstract class AdditionalTaintStep extends DataFlow::Node {
    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge.
     */
    cached
    abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * A taint propagating data flow edge through object or array elements and
   * promises.
   */
  private class HeapTaintStep extends AdditionalTaintStep {
    HeapTaintStep() {
      this = DataFlow::valueNode(_) or
      this = DataFlow::parameterNode(_) or
      this instanceof DataFlow::PropRead
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      succ = this and
      exists(Expr e, Expr f | e = this.asExpr() and f = pred.asExpr() |
        // arrays with tainted elements and objects with tainted property names are tainted
        e.(ArrayExpr).getAnElement() = f
        or
        exists(Property prop | e.(ObjectExpr).getAProperty() = prop |
          prop.isComputed() and f = prop.getNameExpr()
        )
        or
        // awaiting a tainted expression gives a tainted result
        e.(AwaitExpr).getOperand() = f
        or
        // spreading a tainted object into an object literal gives a tainted object
        e.(ObjectExpr).getAProperty().(SpreadProperty).getInit().(SpreadElement).getOperand() = f
        or
        // spreading a tainted value into an array literal gives a tainted array
        e.(ArrayExpr).getAnElement().(SpreadElement).getOperand() = f
      )
      or
      // reading from a tainted object yields a tainted result
      this = succ and
      succ.(DataFlow::PropRead).getBase() = pred
      or
      // iterating over a tainted iterator taints the loop variable
      exists(ForOfStmt fos |
        this = DataFlow::valueNode(fos.getIterationDomain()) and
        pred = this and
        succ = DataFlow::lvalueNode(fos.getLValue())
      )
    }
  }

  /**
   * A taint propagating data flow edge through persistent storage.
   */
  class PersistentStorageTaintStep extends AdditionalTaintStep {
    PersistentReadAccess read;

    PersistentStorageTaintStep() { this = read }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = read.getAWrite().getValue() and
      succ = read
    }
  }

  /**
   * A taint propagating data flow edge caused by the builtin array functions.
   */
  private class ArrayFunctionTaintStep extends AdditionalTaintStep {
    DataFlow::CallNode call;

    ArrayFunctionTaintStep() { this = call }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // `array.map(function (elt, i, ary) { ... })`: if `array` is tainted, then so are
      // `elt` and `ary`; similar for `forEach`
      exists(string name, Function f, int i |
        (name = "map" or name = "forEach") and
        (i = 0 or i = 2) and
        call.getArgument(0).analyze().getAValue().(AbstractFunction).getFunction() = f and
        call.(DataFlow::MethodCallNode).getMethodName() = name and
        pred = call.getReceiver() and
        succ = DataFlow::parameterNode(f.getParameter(i))
      )
      or
      // `array.map` with tainted return value in callback
      exists(DataFlow::FunctionNode f |
        call.(DataFlow::MethodCallNode).getMethodName() = "map" and
        call.getArgument(0) = f and // Require the argument to be a closure to avoid spurious call/return flow
        pred = f.getAReturn() and
        succ = call
      )
      or
      // `array.push(e)`, `array.unshift(e)`: if `e` is tainted, then so is `array`.
      exists(string name |
        name = "push" or
        name = "unshift"
      |
        pred = call.getAnArgument() and
        succ.(DataFlow::SourceNode).getAMethodCall(name) = call
      )
      or
      // `array.push(...e)`, `array.unshift(...e)`: if `e` is tainted, then so is `array`.
      exists(string name |
        name = "push" or
        name = "unshift"
      |
        pred = call.getASpreadArgument() and
        // Make sure we handle reflective calls
        succ = call.getReceiver().getALocalSource() and
        call.getCalleeName() = name
      )
      or
      // `array.splice(i, del, e)`: if `e` is tainted, then so is `array`.
      exists(string name | name = "splice" |
        pred = call.getArgument(2) and
        succ.(DataFlow::SourceNode).getAMethodCall(name) = call
      )
      or
      // `e = array.pop()`, `e = array.shift()`, or similar: if `array` is tainted, then so is `e`.
      exists(string name |
        name = "pop" or
        name = "shift" or
        name = "slice" or
        name = "splice"
      |
        call.(DataFlow::MethodCallNode).calls(pred, name) and
        succ = call
      )
      or
      // `e = Array.from(x)`: if `x` is tainted, then so is `e`.
      call = DataFlow::globalVarRef("Array").getAPropertyRead("from").getACall() and
      pred = call.getAnArgument() and
      succ = call
    }
  }

  /**
   * A taint propagating data flow edge for assignments of the form `o[k] = v`, where
   * `k` is not a constant and `o` refers to some object literal; in this case, we consider
   * taint to flow from `v` to any variable that refers to the object literal.
   *
   * The rationale for this heuristic is that if properties of `o` are accessed by
   * computed (that is, non-constant) names, then `o` is most likely being treated as
   * a map, not as a real object. In this case, it makes sense to consider the entire
   * map to be tainted as soon as one of its entries is.
   */
  private class DictionaryTaintStep extends AdditionalTaintStep, DataFlow::ValueNode {
    override VarAccess astNode;
    DataFlow::Node source;

    DictionaryTaintStep() {
      exists(AssignExpr assgn, IndexExpr idx, AbstractObjectLiteral obj |
        assgn.getTarget() = idx and
        idx.getBase().analyze().getAValue() = obj and
        not exists(idx.getPropertyName()) and
        astNode.analyze().getAValue() = obj and
        source = DataFlow::valueNode(assgn.getRhs())
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = source and succ = this
    }
  }

  /**
   * A taint propagating data flow edge for assignments of the form `c1.state.p = v`,
   * where `c1` is an instance of React component `C`; in this case, we consider
   * taint to flow from `v` to any read of `c2.state.p`, where `c2`
   * also is an instance of `C`.
   */
  private class ReactComponentStateTaintStep extends AdditionalTaintStep, DataFlow::ValueNode {
    DataFlow::Node source;

    ReactComponentStateTaintStep() {
      exists(ReactComponent c, DataFlow::PropRead prn, DataFlow::PropWrite pwn |
        (
          c.getACandidateStateSource().flowsTo(pwn.getBase()) or
          c.getADirectStateAccess().flowsTo(pwn.getBase())
        ) and
        (
          c.getAPreviousStateSource().flowsTo(prn.getBase()) or
          c.getADirectStateAccess().flowsTo(prn.getBase())
        )
      |
        prn.getPropertyName() = pwn.getPropertyName() and
        this = prn and
        source = pwn.getRhs()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = source and succ = this
    }
  }

  /**
   * A taint propagating data flow edge for assignments of the form `c1.props.p = v`,
   * where `c1` is an instance of React component `C`; in this case, we consider
   * taint to flow from `v` to any read of `c2.props.p`, where `c2`
   * also is an instance of `C`.
   */
  private class ReactComponentPropsTaintStep extends AdditionalTaintStep, DataFlow::ValueNode {
    DataFlow::Node source;

    ReactComponentPropsTaintStep() {
      exists(ReactComponent c, string name, DataFlow::PropRead prn |
        prn = c.getAPropRead(name) or
        prn = c.getAPreviousPropsSource().getAPropertyRead(name)
      |
        source = c.getACandidatePropsValue(name) and
        this = prn
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = source and succ = this
    }
  }

  /**
   * A taint propagating data flow edge arising from string concatenations.
   *
   * Note that since we cannot easily distinguish string append from addition,
   * we consider any `+` operation to propagate taint.
   */
  class StringConcatenationTaintStep extends AdditionalTaintStep {
    StringConcatenationTaintStep() { StringConcatenation::taintStep(_, this) }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      succ = this and
      StringConcatenation::taintStep(pred, succ)
    }
  }

  /**
   * A taint propagating data flow edge arising from string manipulation
   * functions defined in the standard library.
   */
  private class StringManipulationTaintStep extends AdditionalTaintStep, DataFlow::ValueNode {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      succ = this and
      (
        // string operations that propagate taint
        exists(string name | name = astNode.(MethodCallExpr).getMethodName() |
          pred.asExpr() = astNode.(MethodCallExpr).getReceiver() and
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
          exists(int i | pred.asExpr() = astNode.(MethodCallExpr).getArgument(i) |
            name = "concat"
            or
            name = "replace" and i = 1
          )
        )
        or
        // standard library constructors that propagate taint: `RegExp` and `String`
        exists(DataFlow::InvokeNode invk, string gv | gv = "RegExp" or gv = "String" |
          this = invk and
          invk = DataFlow::globalVarRef(gv).getAnInvocation() and
          pred = invk.getArgument(0)
        )
        or
        // String.fromCharCode and String.fromCodePoint
        exists(int i, MethodCallExpr mce |
          mce = astNode and
          pred.asExpr() = mce.getArgument(i) and
          (mce.getMethodName() = "fromCharCode" or mce.getMethodName() = "fromCodePoint")
        )
        or
        // `(encode|decode)URI(Component)?` propagate taint
        exists(DataFlow::CallNode c, string name |
          this = c and
          c = DataFlow::globalVarRef(name).getACall() and
          pred = c.getArgument(0)
        |
          name = "encodeURI" or
          name = "decodeURI" or
          name = "encodeURIComponent" or
          name = "decodeURIComponent"
        )
      )
    }
  }

  /**
   * A taint propagating data flow edge arising from string formatting.
   */
  private class StringFormattingTaintStep extends AdditionalTaintStep {
    PrintfStyleCall call;

    StringFormattingTaintStep() {
      this = call and
      call.returnsFormatted()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      succ = this and
      (
        pred = call.getFormatString()
        or
        pred = call.getFormatArgument(_)
      )
    }
  }

  /**
   * A taint-propagating data flow edge from the first (and only) argument in a call to
   * `RegExp.prototype.exec` to its result.
   */
  private class RegExpExecTaintStep extends AdditionalTaintStep {
    DataFlow::MethodCallNode self;

    RegExpExecTaintStep() {
      this = self and
      self.getReceiver().analyze().getAType() = TTRegExp() and
      self.getMethodName() = "exec" and
      self.getNumArgument() = 1
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = self.getArgument(0) and
      succ = this
    }
  }
  

  /**
   * A taint propagating data flow edge arising from calling `String.prototype.match()`.
   */
  private class StringMatchTaintStep extends AdditionalTaintStep, DataFlow::MethodCallNode {
    StringMatchTaintStep() {
      this.getMethodName() = "match" and
      this.getNumArgument() = 1 and
      this.getArgument(0) .analyze().getAType() = TTRegExp()
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = this.getReceiver() and
      succ = this
    }
  }

  /**
   * A taint propagating data flow edge arising from JSON unparsing.
   */
  private class JsonStringifyTaintStep extends AdditionalTaintStep, DataFlow::MethodCallNode {
    JsonStringifyTaintStep() { this = DataFlow::globalVarRef("JSON").getAMemberCall("stringify") }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(0) and succ = this
    }
  }

  /**
   * A taint propagating data flow edge arising from JSON parsing.
   */
  private class JsonParserTaintStep extends AdditionalTaintStep, DataFlow::CallNode {
    JsonParserCall call;

    JsonParserTaintStep() { this = call }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = call.getInput() and
      succ = call.getOutput()
    }
  }

  /**
   * Holds if `params` is a `URLSearchParams` object providing access to
   * the parameters encoded in `input`.
   */
  predicate isUrlSearchParams(DataFlow::SourceNode params, DataFlow::Node input) {
    exists(DataFlow::GlobalVarRefNode urlSearchParams, NewExpr newUrlSearchParams |
      urlSearchParams.getName() = "URLSearchParams" and
      newUrlSearchParams = urlSearchParams.getAnInstantiation().asExpr() and
      params.asExpr() = newUrlSearchParams and
      input.asExpr() = newUrlSearchParams.getArgument(0)
    )
    or
    exists(DataFlow::NewNode newUrl |
      newUrl = DataFlow::globalVarRef("URL").getAnInstantiation() and
      params = newUrl.getAPropertyRead("searchParams") and
      input = newUrl.getArgument(0)
    )
  }

  /**
   * A taint propagating data flow edge arising from URL parameter parsing.
   */
  private class UrlSearchParamsTaintStep extends AdditionalTaintStep, DataFlow::ValueNode {
    DataFlow::Node source;

    UrlSearchParamsTaintStep() {
      // either this is itself an `URLSearchParams` object
      isUrlSearchParams(this, source)
      or
      // or this is a call to `get` or `getAll` on a `URLSearchParams` object
      exists(DataFlow::SourceNode searchParams, string m |
        isUrlSearchParams(searchParams, source) and
        this = searchParams.getAMethodCall(m) and
        m.matches("get%")
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = source and succ = this
    }
  }

  /**
   * A taint propagating data flow edge arising from sorting.
   */
  private class SortTaintStep extends AdditionalTaintStep, DataFlow::MethodCallNode {
    SortTaintStep() { getMethodName() = "sort" }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getReceiver() and succ = this
    }
  }

  /**
   * A taint step through an exception constructor, such as `x` to `new Error(x)`.
   */
  class ErrorConstructorTaintStep extends AdditionalTaintStep, DataFlow::InvokeNode {
    ErrorConstructorTaintStep() {
      exists(string name | this = DataFlow::globalVarRef(name).getAnInvocation() |
        name = "Error" or
        name = "EvalError" or
        name = "RangeError" or
        name = "ReferenceError" or
        name = "SyntaxError" or
        name = "TypeError" or
        name = "URIError"
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(0) and
      succ = this
    }
  }

  /**
   * A taint step through the Node.JS function `util.inspect(..)`.
   */
  class UtilInspectTaintStep extends AdditionalTaintStep, DataFlow::InvokeNode {
    UtilInspectTaintStep() {
      this = DataFlow::moduleImport("util").getAMemberCall("inspect")
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      succ = this and
      this.getAnArgument() = pred
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
        RegExp::isGenericRegExpSanitizer(RegExp::getRegExpObjectFromNode(base.flow()), sanitizedOutcome) and
        (m = "test" or m = "exec") and
        firstArg = expr
        or
        // u.match(/re/) or u.match("re")
        base = expr and
        m = "match" and
        RegExp::isGenericRegExpSanitizer(RegExp::getRegExpFromNode(firstArg.flow()), sanitizedOutcome)
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
      getCalleeName().regexpMatch("(?i).*((?<!un)safe|whitelist|allow|(?<!un)auth(?!or\\b)).*") and
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
    any(AdditionalTaintStep s).step(pred, succ)
  }
}
