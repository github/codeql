/**
 * Provides classes and predicates for defining flow summaries.
 *
 * The definitions in this file are language-independent, and language-specific
 * definitions are passed in via the `DataFlowImplSpecific` and
 * `FlowSummaryImplSpecific` modules.
 */

private import FlowSummaryImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public
private import DataFlowImplCommon

/** Provides classes and predicates for defining flow summaries. */
module Public {
  private import Private

  /**
   * A component used in a flow summary.
   *
   * Either a parameter or an argument at a given position, a specific
   * content type, or a return kind.
   */
  class SummaryComponent extends TSummaryComponent {
    /** Gets a textual representation of this summary component. */
    string toString() {
      exists(ContentSet c | this = TContentSummaryComponent(c) and result = c.toString())
      or
      exists(ArgumentPosition pos |
        this = TParameterSummaryComponent(pos) and result = "parameter " + pos
      )
      or
      exists(ParameterPosition pos |
        this = TArgumentSummaryComponent(pos) and result = "argument " + pos
      )
      or
      exists(ReturnKind rk | this = TReturnSummaryComponent(rk) and result = "return (" + rk + ")")
    }
  }

  /** Provides predicates for constructing summary components. */
  module SummaryComponent {
    /** Gets a summary component for content `c`. */
    SummaryComponent content(ContentSet c) { result = TContentSummaryComponent(c) }

    /** Gets a summary component for a parameter at position `pos`. */
    SummaryComponent parameter(ArgumentPosition pos) { result = TParameterSummaryComponent(pos) }

    /** Gets a summary component for an argument at position `pos`. */
    SummaryComponent argument(ParameterPosition pos) { result = TArgumentSummaryComponent(pos) }

    /** Gets a summary component for a return of kind `rk`. */
    SummaryComponent return(ReturnKind rk) { result = TReturnSummaryComponent(rk) }
  }

  /**
   * A (non-empty) stack of summary components.
   *
   * A stack is used to represent where data is read from (input) or where it
   * is written to (output). For example, an input stack `[Field f, Argument 0]`
   * means that data is read from field `f` from the `0`th argument, while an
   * output stack `[Field g, Return]` means that data is written to the field
   * `g` of the returned object.
   */
  class SummaryComponentStack extends TSummaryComponentStack {
    /** Gets the head of this stack. */
    SummaryComponent head() {
      this = TSingletonSummaryComponentStack(result) or
      this = TConsSummaryComponentStack(result, _)
    }

    /** Gets the tail of this stack, if any. */
    SummaryComponentStack tail() { this = TConsSummaryComponentStack(_, result) }

    /** Gets the length of this stack. */
    int length() {
      this = TSingletonSummaryComponentStack(_) and result = 1
      or
      result = 1 + this.tail().length()
    }

    /** Gets the stack obtained by dropping the first `i` elements, if any. */
    SummaryComponentStack drop(int i) {
      i = 0 and result = this
      or
      result = this.tail().drop(i - 1)
    }

    /** Holds if this stack contains summary component `c`. */
    predicate contains(SummaryComponent c) { c = this.drop(_).head() }

    /** Gets the bottom element of this stack. */
    SummaryComponent bottom() {
      this = TSingletonSummaryComponentStack(result) or result = this.tail().bottom()
    }

    /** Gets a textual representation of this stack. */
    string toString() {
      exists(SummaryComponent head, SummaryComponentStack tail |
        head = this.head() and
        tail = this.tail() and
        result = tail + "." + head
      )
      or
      exists(SummaryComponent c |
        this = TSingletonSummaryComponentStack(c) and
        result = c.toString()
      )
    }
  }

  /** Provides predicates for constructing stacks of summary components. */
  module SummaryComponentStack {
    /** Gets a singleton stack containing `c`. */
    SummaryComponentStack singleton(SummaryComponent c) {
      result = TSingletonSummaryComponentStack(c)
    }

    /**
     * Gets the stack obtained by pushing `head` onto `tail`.
     *
     * Make sure to override `RequiredSummaryComponentStack::required()` in order
     * to ensure that the constructed stack exists.
     */
    SummaryComponentStack push(SummaryComponent head, SummaryComponentStack tail) {
      result = TConsSummaryComponentStack(head, tail)
    }

    /** Gets a singleton stack for an argument at position `pos`. */
    SummaryComponentStack argument(ParameterPosition pos) {
      result = singleton(SummaryComponent::argument(pos))
    }

    /** Gets a singleton stack representing a return of kind `rk`. */
    SummaryComponentStack return(ReturnKind rk) { result = singleton(SummaryComponent::return(rk)) }
  }

  private predicate noComponentSpecificCsv(SummaryComponent sc) {
    not exists(getComponentSpecificCsv(sc))
  }

  /** Gets a textual representation of this component used for flow summaries. */
  private string getComponentCsv(SummaryComponent sc) {
    result = getComponentSpecificCsv(sc)
    or
    noComponentSpecificCsv(sc) and
    (
      exists(ArgumentPosition pos |
        sc = TParameterSummaryComponent(pos) and
        result = "Parameter[" + getArgumentPositionCsv(pos) + "]"
      )
      or
      exists(ParameterPosition pos |
        sc = TArgumentSummaryComponent(pos) and
        result = "Argument[" + getParameterPositionCsv(pos) + "]"
      )
      or
      sc = TReturnSummaryComponent(getReturnValueKind()) and result = "ReturnValue"
    )
  }

  /** Gets a textual representation of this stack used for flow summaries. */
  string getComponentStackCsv(SummaryComponentStack stack) {
    exists(SummaryComponent head, SummaryComponentStack tail |
      head = stack.head() and
      tail = stack.tail() and
      result = getComponentStackCsv(tail) + "." + getComponentCsv(head)
    )
    or
    exists(SummaryComponent c |
      stack = TSingletonSummaryComponentStack(c) and
      result = getComponentCsv(c)
    )
  }

  /**
   * A class that exists for QL technical reasons only (the IPA type used
   * to represent component stacks needs to be bounded).
   */
  class RequiredSummaryComponentStack extends Unit {
    /**
     * Holds if the stack obtained by pushing `head` onto `tail` is required.
     */
    abstract predicate required(SummaryComponent head, SummaryComponentStack tail);
  }

  /** A callable with a flow summary. */
  abstract class SummarizedCallable extends DataFlowCallable {
    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step
     * or a taint-step.
     *
     * Input specifications are restricted to stacks that end with
     * `SummaryComponent::argument(_)`, preceded by zero or more
     * `SummaryComponent::return(_)` or `SummaryComponent::content(_)` components.
     *
     * Output specifications are restricted to stacks that end with
     * `SummaryComponent::return(_)` or `SummaryComponent::argument(_)`.
     *
     * Output stacks ending with `SummaryComponent::return(_)` can be preceded by zero
     * or more `SummaryComponent::content(_)` components.
     *
     * Output stacks ending with `SummaryComponent::argument(_)` can be preceded by an
     * optional `SummaryComponent::parameter(_)` component, which in turn can be preceded
     * by zero or more `SummaryComponent::content(_)` components.
     */
    pragma[nomagic]
    predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      none()
    }

    /**
     * Holds if values stored inside `content` are cleared on objects passed as
     * arguments at position `pos` to this callable.
     */
    pragma[nomagic]
    predicate clearsContent(ParameterPosition pos, ContentSet content) { none() }
  }
}

/**
 * Provides predicates for compiling flow summaries down to atomic local steps,
 * read steps, and store steps.
 */
module Private {
  private import Public
  import AccessPathSyntax

  newtype TSummaryComponent =
    TContentSummaryComponent(ContentSet c) or
    TParameterSummaryComponent(ArgumentPosition pos) or
    TArgumentSummaryComponent(ParameterPosition pos) or
    TReturnSummaryComponent(ReturnKind rk)

  private TParameterSummaryComponent thisParam() {
    result = TParameterSummaryComponent(instanceParameterPosition())
  }

  newtype TSummaryComponentStack =
    TSingletonSummaryComponentStack(SummaryComponent c) or
    TConsSummaryComponentStack(SummaryComponent head, SummaryComponentStack tail) {
      any(RequiredSummaryComponentStack x).required(head, tail)
      or
      any(RequiredSummaryComponentStack x).required(TParameterSummaryComponent(_), tail) and
      head = thisParam()
      or
      derivedFluentFlowPush(_, _, _, head, tail, _)
    }

  pragma[nomagic]
  private predicate summary(
    SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
    boolean preservesValue
  ) {
    c.propagatesFlow(input, output, preservesValue)
    or
    // observe side effects of callbacks on input arguments
    c.propagatesFlow(output, input, preservesValue) and
    preservesValue = true and
    isCallbackParameter(input) and
    isContentOfArgument(output, _)
    or
    // flow from the receiver of a callback into the instance-parameter
    exists(SummaryComponentStack s, SummaryComponentStack callbackRef |
      c.propagatesFlow(s, _, _) or c.propagatesFlow(_, s, _)
    |
      callbackRef = s.drop(_) and
      (isCallbackParameter(callbackRef) or callbackRef.head() = TReturnSummaryComponent(_)) and
      input = callbackRef.tail() and
      output = TConsSummaryComponentStack(thisParam(), input) and
      preservesValue = true
    )
    or
    exists(SummaryComponentStack arg, SummaryComponentStack return |
      derivedFluentFlow(c, input, arg, return, preservesValue)
    |
      arg.length() = 1 and
      output = return
      or
      exists(SummaryComponent head, SummaryComponentStack tail |
        derivedFluentFlowPush(c, input, arg, head, tail, 0) and
        output = SummaryComponentStack::push(head, tail)
      )
    )
    or
    // Chain together summaries where values get passed into callbacks along the way
    exists(SummaryComponentStack mid, boolean preservesValue1, boolean preservesValue2 |
      c.propagatesFlow(input, mid, preservesValue1) and
      c.propagatesFlow(mid, output, preservesValue2) and
      mid.drop(mid.length() - 2) =
        SummaryComponentStack::push(TParameterSummaryComponent(_),
          SummaryComponentStack::singleton(TArgumentSummaryComponent(_))) and
      preservesValue = preservesValue1.booleanAnd(preservesValue2)
    )
  }

  /**
   * Holds if `c` has a flow summary from `input` to `arg`, where `arg`
   * writes to (contents of) arguments at position `pos`, and `c` has a
   * value-preserving flow summary from the arguments at position `pos`
   * to a return value (`return`).
   *
   * In such a case, we derive flow from `input` to (contents of) the return
   * value.
   *
   * As an example, this simplifies modeling of fluent methods:
   * for `StringBuilder.append(x)` with a specified value flow from qualifier to
   * return value and taint flow from argument 0 to the qualifier, then this
   * allows us to infer taint flow from argument 0 to the return value.
   */
  pragma[nomagic]
  private predicate derivedFluentFlow(
    SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack arg,
    SummaryComponentStack return, boolean preservesValue
  ) {
    exists(ParameterPosition pos |
      summary(c, input, arg, preservesValue) and
      isContentOfArgument(arg, pos) and
      summary(c, SummaryComponentStack::argument(pos), return, true) and
      return.bottom() = TReturnSummaryComponent(_)
    )
  }

  pragma[nomagic]
  private predicate derivedFluentFlowPush(
    SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack arg,
    SummaryComponent head, SummaryComponentStack tail, int i
  ) {
    derivedFluentFlow(c, input, arg, tail, _) and
    head = arg.drop(i).head() and
    i = arg.length() - 2
    or
    exists(SummaryComponent head0, SummaryComponentStack tail0 |
      derivedFluentFlowPush(c, input, arg, head0, tail0, i + 1) and
      head = arg.drop(i).head() and
      tail = SummaryComponentStack::push(head0, tail0)
    )
  }

  private predicate isCallbackParameter(SummaryComponentStack s) {
    s.head() = TParameterSummaryComponent(_) and exists(s.tail())
  }

  private predicate isContentOfArgument(SummaryComponentStack s, ParameterPosition pos) {
    s.head() = TContentSummaryComponent(_) and isContentOfArgument(s.tail(), pos)
    or
    s = SummaryComponentStack::argument(pos)
  }

  private predicate outputState(SummarizedCallable c, SummaryComponentStack s) {
    summary(c, _, s, _)
    or
    exists(SummaryComponentStack out |
      outputState(c, out) and
      out.head() = TContentSummaryComponent(_) and
      s = out.tail()
    )
    or
    // Add the argument node corresponding to the requested post-update node
    inputState(c, s) and isCallbackParameter(s)
  }

  private predicate inputState(SummarizedCallable c, SummaryComponentStack s) {
    summary(c, s, _, _)
    or
    exists(SummaryComponentStack inp | inputState(c, inp) and s = inp.tail())
    or
    exists(SummaryComponentStack out |
      outputState(c, out) and
      out.head() = TParameterSummaryComponent(_) and
      s = out.tail()
    )
  }

  private newtype TSummaryNodeState =
    TSummaryNodeInputState(SummaryComponentStack s) { inputState(_, s) } or
    TSummaryNodeOutputState(SummaryComponentStack s) { outputState(_, s) } or
    TSummaryNodeClearsContentState(ParameterPosition pos, boolean post) {
      any(SummarizedCallable sc).clearsContent(pos, _) and post in [false, true]
    }

  /**
   * A state used to break up (complex) flow summaries into atomic flow steps.
   * For a flow summary
   *
   * ```ql
   * propagatesFlow(
   *   SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
   * )
   * ```
   *
   * the following states are used:
   *
   * - `TSummaryNodeInputState(SummaryComponentStack s)`:
   *   this state represents that the components in `s` _have been read_ from the
   *   input.
   * - `TSummaryNodeOutputState(SummaryComponentStack s)`:
   *   this state represents that the components in `s` _remain to be written_ to
   *   the output.
   */
  class SummaryNodeState extends TSummaryNodeState {
    /** Holds if this state is a valid input state for `c`. */
    pragma[nomagic]
    predicate isInputState(SummarizedCallable c, SummaryComponentStack s) {
      this = TSummaryNodeInputState(s) and
      inputState(c, s)
    }

    /** Holds if this state is a valid output state for `c`. */
    pragma[nomagic]
    predicate isOutputState(SummarizedCallable c, SummaryComponentStack s) {
      this = TSummaryNodeOutputState(s) and
      outputState(c, s)
    }

    /** Gets a textual representation of this state. */
    string toString() {
      exists(SummaryComponentStack s |
        this = TSummaryNodeInputState(s) and
        result = "read: " + s
      )
      or
      exists(SummaryComponentStack s |
        this = TSummaryNodeOutputState(s) and
        result = "to write: " + s
      )
      or
      exists(ParameterPosition pos, boolean post, string postStr |
        this = TSummaryNodeClearsContentState(pos, post) and
        (if post = true then postStr = " (post)" else postStr = "") and
        result = "clear: " + pos + postStr
      )
    }
  }

  /**
   * Holds if `state` represents having read from a parameter at position
   * `pos` in `c`. In this case we are not synthesizing a data-flow node,
   * but instead assume that a relevant parameter node already exists.
   */
  private predicate parameterReadState(
    SummarizedCallable c, SummaryNodeState state, ParameterPosition pos
  ) {
    state.isInputState(c, SummaryComponentStack::argument(pos))
  }

  /**
   * Holds if a synthesized summary node is needed for the state `state` in summarized
   * callable `c`.
   */
  predicate summaryNodeRange(SummarizedCallable c, SummaryNodeState state) {
    state.isInputState(c, _) and
    not parameterReadState(c, state, _)
    or
    state.isOutputState(c, _)
    or
    exists(ParameterPosition pos |
      c.clearsContent(pos, _) and
      state = TSummaryNodeClearsContentState(pos, _)
    )
  }

  pragma[noinline]
  private Node summaryNodeInputState(SummarizedCallable c, SummaryComponentStack s) {
    exists(SummaryNodeState state | state.isInputState(c, s) |
      result = summaryNode(c, state)
      or
      exists(ParameterPosition pos |
        parameterReadState(c, state, pos) and
        result.(ParamNode).isParameterOf(c, pos)
      )
    )
  }

  pragma[noinline]
  private Node summaryNodeOutputState(SummarizedCallable c, SummaryComponentStack s) {
    exists(SummaryNodeState state |
      state.isOutputState(c, s) and
      result = summaryNode(c, state)
    )
  }

  /**
   * Holds if a write targets `post`, which is a post-update node for a
   * parameter at position `pos` in `c`.
   */
  private predicate isParameterPostUpdate(Node post, SummarizedCallable c, ParameterPosition pos) {
    post = summaryNodeOutputState(c, SummaryComponentStack::argument(pos))
  }

  /** Holds if a parameter node at position `pos` is required for `c`. */
  predicate summaryParameterNodeRange(SummarizedCallable c, ParameterPosition pos) {
    parameterReadState(c, _, pos)
    or
    isParameterPostUpdate(_, c, pos)
    or
    c.clearsContent(pos, _)
  }

  private predicate callbackOutput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ReturnKind rk
  ) {
    any(SummaryNodeState state).isInputState(c, s) and
    s.head() = TReturnSummaryComponent(rk) and
    receiver = summaryNodeInputState(c, s.drop(1))
  }

  private predicate callbackInput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ArgumentPosition pos
  ) {
    any(SummaryNodeState state).isOutputState(c, s) and
    s.head() = TParameterSummaryComponent(pos) and
    receiver = summaryNodeInputState(c, s.drop(1))
  }

  /** Holds if a call targeting `receiver` should be synthesized inside `c`. */
  predicate summaryCallbackRange(SummarizedCallable c, Node receiver) {
    callbackOutput(c, _, receiver, _)
    or
    callbackInput(c, _, receiver, _)
  }

  /**
   * Gets the type of synthesized summary node `n`.
   *
   * The type is computed based on the language-specific predicates
   * `getContentType()`, `getReturnType()`, `getCallbackParameterType()`, and
   * `getCallbackReturnType()`.
   */
  DataFlowType summaryNodeType(Node n) {
    exists(Node pre |
      summaryPostUpdateNode(n, pre) and
      result = getNodeType(pre)
    )
    or
    exists(SummarizedCallable c, SummaryComponentStack s, SummaryComponent head | head = s.head() |
      n = summaryNodeInputState(c, s) and
      (
        exists(ContentSet cont |
          head = TContentSummaryComponent(cont) and result = getContentType(cont)
        )
        or
        exists(ReturnKind rk |
          head = TReturnSummaryComponent(rk) and
          result =
            getCallbackReturnType(getNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                  s.drop(1))), rk)
        )
      )
      or
      n = summaryNodeOutputState(c, s) and
      (
        exists(ContentSet cont |
          head = TContentSummaryComponent(cont) and result = getContentType(cont)
        )
        or
        s.length() = 1 and
        exists(ReturnKind rk |
          head = TReturnSummaryComponent(rk) and
          result = getReturnType(c, rk)
        )
        or
        exists(ArgumentPosition pos | head = TParameterSummaryComponent(pos) |
          result =
            getCallbackParameterType(getNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                  s.drop(1))), pos)
        )
      )
    )
    or
    exists(SummarizedCallable c, ParameterPosition pos, ParamNode p |
      n = summaryNode(c, TSummaryNodeClearsContentState(pos, false)) and
      p.isParameterOf(c, pos) and
      result = getNodeType(p)
    )
  }

  /** Holds if summary node `out` contains output of kind `rk` from call `c`. */
  predicate summaryOutNode(DataFlowCall c, Node out, ReturnKind rk) {
    exists(SummarizedCallable callable, SummaryComponentStack s, Node receiver |
      callbackOutput(callable, s, receiver, rk) and
      out = summaryNodeInputState(callable, s) and
      c = summaryDataFlowCall(receiver)
    )
  }

  /** Holds if summary node `arg` is at position `pos` in the call `c`. */
  predicate summaryArgumentNode(DataFlowCall c, Node arg, ArgumentPosition pos) {
    exists(SummarizedCallable callable, SummaryComponentStack s, Node receiver |
      callbackInput(callable, s, receiver, pos) and
      arg = summaryNodeOutputState(callable, s) and
      c = summaryDataFlowCall(receiver)
    )
  }

  /** Holds if summary node `post` is a post-update node with pre-update node `pre`. */
  predicate summaryPostUpdateNode(Node post, Node pre) {
    exists(SummarizedCallable c, ParameterPosition pos |
      isParameterPostUpdate(post, c, pos) and
      pre.(ParamNode).isParameterOf(c, pos)
      or
      pre = summaryNode(c, TSummaryNodeClearsContentState(pos, false)) and
      post = summaryNode(c, TSummaryNodeClearsContentState(pos, true))
    )
    or
    exists(SummarizedCallable callable, SummaryComponentStack s |
      callbackInput(callable, s, _, _) and
      pre = summaryNodeOutputState(callable, s) and
      post = summaryNodeInputState(callable, s)
    )
  }

  /** Holds if summary node `ret` is a return node of kind `rk`. */
  predicate summaryReturnNode(Node ret, ReturnKind rk) {
    exists(SummarizedCallable callable, SummaryComponentStack s |
      ret = summaryNodeOutputState(callable, s) and
      s = TSingletonSummaryComponentStack(TReturnSummaryComponent(rk))
    )
  }

  /**
   * Holds if flow is allowed to pass from parameter `p`, to a return
   * node, and back out to `p`.
   */
  predicate summaryAllowParameterReturnInSelf(ParamNode p) {
    exists(SummarizedCallable c, ParameterPosition ppos | p.isParameterOf(c, ppos) |
      c.clearsContent(ppos, _)
      or
      exists(SummaryComponentStack inputContents, SummaryComponentStack outputContents |
        summary(c, inputContents, outputContents, _) and
        inputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(ppos)) and
        outputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(ppos))
      )
    )
  }

  /** Provides a compilation of flow summaries to atomic data-flow steps. */
  module Steps {
    /**
     * Holds if there is a local step from `pred` to `succ`, which is synthesized
     * from a flow summary.
     */
    predicate summaryLocalStep(Node pred, Node succ, boolean preservesValue) {
      exists(
        SummarizedCallable c, SummaryComponentStack inputContents,
        SummaryComponentStack outputContents
      |
        summary(c, inputContents, outputContents, preservesValue) and
        pred = summaryNodeInputState(c, inputContents) and
        succ = summaryNodeOutputState(c, outputContents)
      |
        preservesValue = true
        or
        preservesValue = false and not summary(c, inputContents, outputContents, true)
      )
      or
      exists(SummarizedCallable c, ParameterPosition pos |
        pred.(ParamNode).isParameterOf(c, pos) and
        succ = summaryNode(c, TSummaryNodeClearsContentState(pos, _)) and
        preservesValue = true
      )
    }

    /**
     * Holds if there is a read step of content `c` from `pred` to `succ`, which
     * is synthesized from a flow summary.
     */
    predicate summaryReadStep(Node pred, ContentSet c, Node succ) {
      exists(SummarizedCallable sc, SummaryComponentStack s |
        pred = summaryNodeInputState(sc, s.drop(1)) and
        succ = summaryNodeInputState(sc, s) and
        SummaryComponent::content(c) = s.head()
      )
    }

    /**
     * Holds if there is a store step of content `c` from `pred` to `succ`, which
     * is synthesized from a flow summary.
     */
    predicate summaryStoreStep(Node pred, ContentSet c, Node succ) {
      exists(SummarizedCallable sc, SummaryComponentStack s |
        pred = summaryNodeOutputState(sc, s) and
        succ = summaryNodeOutputState(sc, s.drop(1)) and
        SummaryComponent::content(c) = s.head()
      )
    }

    /**
     * Holds if values stored inside content `c` are cleared at `n`. `n` is a
     * synthesized summary node, so in order for values to be cleared at calls
     * to the relevant method, it is important that flow does not pass over
     * the argument, either via use-use flow or def-use flow.
     *
     * Example:
     *
     * ```
     * a.b = taint;
     * a.clearB(); // assume we have a flow summary for `clearB` that clears `b` on the qualifier
     * sink(a.b);
     * ```
     *
     * In the above, flow should not pass from `a` on the first line (or the second
     * line) to `a` on the third line. Instead, there will be synthesized flow from
     * `a` on line 2 to the post-update node for `a` on that line (via an intermediate
     * node where field `b` is cleared).
     */
    predicate summaryClearsContent(Node n, ContentSet c) {
      exists(SummarizedCallable sc, ParameterPosition pos |
        n = summaryNode(sc, TSummaryNodeClearsContentState(pos, true)) and
        sc.clearsContent(pos, c)
      )
    }

    pragma[noinline]
    private predicate viableParam(
      DataFlowCall call, SummarizedCallable sc, ParameterPosition ppos, ParamNode p
    ) {
      p.isParameterOf(sc, ppos) and
      sc = viableCallable(call)
    }

    /**
     * Holds if values stored inside content `c` are cleared inside a
     * callable to which `arg` is an argument.
     *
     * In such cases, it is important to prevent use-use flow out of
     * `arg` (see comment for `summaryClearsContent`).
     */
    pragma[nomagic]
    predicate summaryClearsContentArg(ArgNode arg, ContentSet c) {
      exists(DataFlowCall call, SummarizedCallable sc, ParameterPosition ppos |
        argumentPositionMatch(call, arg, ppos) and
        viableParam(call, sc, ppos, _) and
        sc.clearsContent(ppos, c)
      )
    }

    pragma[nomagic]
    private ParamNode summaryArgParam0(DataFlowCall call, ArgNode arg) {
      exists(ParameterPosition ppos, SummarizedCallable sc |
        argumentPositionMatch(call, arg, ppos) and
        viableParam(call, sc, ppos, result)
      )
    }

    pragma[nomagic]
    private ParamNode summaryArgParam(ArgNode arg, ReturnKindExt rk, OutNodeExt out) {
      exists(DataFlowCall call |
        result = summaryArgParam0(call, arg) and
        out = rk.getAnOutNode(call)
      )
    }

    /**
     * Holds if `arg` flows to `out` using a simple flow summary, that is, a flow
     * summary without reads and stores.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summaryThroughStep(ArgNode arg, Node out, boolean preservesValue) {
      exists(ReturnKindExt rk, ReturnNodeExt ret |
        summaryLocalStep(summaryArgParam(arg, rk, out), ret, preservesValue) and
        ret.getKind() = rk
      )
    }

    /**
     * Holds if there is a read(+taint) of `c` from `arg` to `out` using a
     * flow summary.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summaryGetterStep(ArgNode arg, ContentSet c, Node out) {
      exists(ReturnKindExt rk, Node mid, ReturnNodeExt ret |
        summaryReadStep(summaryArgParam(arg, rk, out), c, mid) and
        summaryLocalStep(mid, ret, _) and
        ret.getKind() = rk
      )
    }

    /**
     * Holds if there is a (taint+)store of `arg` into content `c` of `out` using a
     * flow summary.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summarySetterStep(ArgNode arg, ContentSet c, Node out) {
      exists(ReturnKindExt rk, Node mid, ReturnNodeExt ret |
        summaryLocalStep(summaryArgParam(arg, rk, out), mid, _) and
        summaryStoreStep(mid, c, ret) and
        ret.getKind() = rk
      )
    }
  }

  /**
   * Provides a means of translating externally (e.g., CSV) defined flow
   * summaries into a `SummarizedCallable`s.
   */
  module External {
    /** Holds if `spec` is a relevant external specification. */
    private predicate relevantSpec(string spec) {
      summaryElement(_, spec, _, _, _) or
      summaryElement(_, _, spec, _, _) or
      sourceElement(_, spec, _, _) or
      sinkElement(_, spec, _, _)
    }

    private class AccessPathRange extends AccessPath::Range {
      AccessPathRange() { relevantSpec(this) }
    }

    /** Holds if specification component `c` parses as parameter `n`. */
    predicate parseParam(AccessPathToken token, ArgumentPosition pos) {
      token.getName() = "Parameter" and
      pos = parseParamBody(token.getAnArgument())
    }

    /** Holds if specification component `c` parses as argument `n`. */
    predicate parseArg(AccessPathToken token, ParameterPosition pos) {
      token.getName() = "Argument" and
      pos = parseArgBody(token.getAnArgument())
    }

    private SummaryComponent interpretComponent(AccessPathToken token) {
      exists(ParameterPosition pos |
        parseArg(token, pos) and result = SummaryComponent::argument(pos)
      )
      or
      exists(ArgumentPosition pos |
        parseParam(token, pos) and result = SummaryComponent::parameter(pos)
      )
      or
      token = "ReturnValue" and result = SummaryComponent::return(getReturnValueKind())
      or
      result = interpretComponentSpecific(token)
    }

    /**
     * Holds if `spec` specifies summary component stack `stack`.
     */
    predicate interpretSpec(AccessPath spec, SummaryComponentStack stack) {
      interpretSpec(spec, spec.getNumToken(), stack)
    }

    /** Holds if the first `n` tokens of `spec` resolves to `stack`. */
    private predicate interpretSpec(AccessPath spec, int n, SummaryComponentStack stack) {
      n = 1 and
      stack = SummaryComponentStack::singleton(interpretComponent(spec.getToken(0)))
      or
      exists(SummaryComponent head, SummaryComponentStack tail |
        interpretSpec(spec, n, head, tail) and
        stack = SummaryComponentStack::push(head, tail)
      )
    }

    /** Holds if the first `n` tokens of `spec` resolves to `head` followed by `tail` */
    private predicate interpretSpec(
      AccessPath spec, int n, SummaryComponent head, SummaryComponentStack tail
    ) {
      interpretSpec(spec, n - 1, tail) and
      head = interpretComponent(spec.getToken(n - 1))
    }

    private class MkStack extends RequiredSummaryComponentStack {
      override predicate required(SummaryComponent head, SummaryComponentStack tail) {
        interpretSpec(_, _, head, tail)
      }
    }

    private class SummarizedCallableExternal extends SummarizedCallable {
      SummarizedCallableExternal() { summaryElement(this, _, _, _, _) }

      private predicate relevantSummaryElement(AccessPath inSpec, AccessPath outSpec, string kind) {
        summaryElement(this, inSpec, outSpec, kind, false)
        or
        summaryElement(this, inSpec, outSpec, kind, true) and
        not summaryElement(this, _, _, _, false)
      }

      override predicate propagatesFlow(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
      ) {
        exists(AccessPath inSpec, AccessPath outSpec, string kind |
          this.relevantSummaryElement(inSpec, outSpec, kind) and
          interpretSpec(inSpec, input) and
          interpretSpec(outSpec, output)
        |
          kind = "value" and preservesValue = true
          or
          kind = "taint" and preservesValue = false
        )
      }
    }

    /** Holds if component `c` of specification `spec` cannot be parsed. */
    predicate invalidSpecComponent(AccessPath spec, string c) {
      c = spec.getToken(_) and
      not exists(interpretComponent(c))
    }

    private predicate inputNeedsReference(AccessPathToken c) {
      c.getName() = "Argument" or
      inputNeedsReferenceSpecific(c)
    }

    private predicate outputNeedsReference(AccessPathToken c) {
      c.getName() = ["Argument", "ReturnValue"] or
      outputNeedsReferenceSpecific(c)
    }

    private predicate sourceElementRef(InterpretNode ref, AccessPath output, string kind) {
      exists(SourceOrSinkElement e |
        sourceElement(e, output, kind, _) and
        if outputNeedsReference(output.getToken(0))
        then e = ref.getCallTarget()
        else e = ref.asElement()
      )
    }

    private predicate sinkElementRef(InterpretNode ref, AccessPath input, string kind) {
      exists(SourceOrSinkElement e |
        sinkElement(e, input, kind, _) and
        if inputNeedsReference(input.getToken(0))
        then e = ref.getCallTarget()
        else e = ref.asElement()
      )
    }

    /** Holds if the first `n` tokens of `output` resolve to the given interpretation. */
    private predicate interpretOutput(
      AccessPath output, int n, InterpretNode ref, InterpretNode node
    ) {
      sourceElementRef(ref, output, _) and
      n = 0 and
      (
        if output = ""
        then
          // Allow language-specific interpretation of the empty access path
          interpretOutputSpecific("", ref, node)
        else node = ref
      )
      or
      exists(InterpretNode mid, AccessPathToken c |
        interpretOutput(output, n - 1, ref, mid) and
        c = output.getToken(n - 1)
      |
        exists(ArgumentPosition apos, ParameterPosition ppos |
          node.asNode().(PostUpdateNode).getPreUpdateNode().(ArgNode).argumentOf(mid.asCall(), apos) and
          parameterMatch(ppos, apos)
        |
          c = "Argument" or parseArg(c, ppos)
        )
        or
        exists(ArgumentPosition apos, ParameterPosition ppos |
          node.asNode().(ParamNode).isParameterOf(mid.asCallable(), ppos) and
          parameterMatch(ppos, apos)
        |
          c = "Parameter" or parseParam(c, apos)
        )
        or
        c = "ReturnValue" and
        node.asNode() = getAnOutNodeExt(mid.asCall(), TValueReturn(getReturnValueKind()))
        or
        interpretOutputSpecific(c, mid, node)
      )
    }

    /** Holds if the first `n` tokens of `input` resolve to the given interpretation. */
    private predicate interpretInput(AccessPath input, int n, InterpretNode ref, InterpretNode node) {
      sinkElementRef(ref, input, _) and
      n = 0 and
      (
        if input = ""
        then
          // Allow language-specific interpretation of the empty access path
          interpretInputSpecific("", ref, node)
        else node = ref
      )
      or
      exists(InterpretNode mid, AccessPathToken c |
        interpretInput(input, n - 1, ref, mid) and
        c = input.getToken(n - 1)
      |
        exists(ArgumentPosition apos, ParameterPosition ppos |
          node.asNode().(ArgNode).argumentOf(mid.asCall(), apos) and
          parameterMatch(ppos, apos)
        |
          c = "Argument" or parseArg(c, ppos)
        )
        or
        exists(ReturnNodeExt ret |
          c = "ReturnValue" and
          ret = node.asNode() and
          ret.getKind().(ValueReturnKind).getKind() = getReturnValueKind() and
          mid.asCallable() = getNodeEnclosingCallable(ret)
        )
        or
        interpretInputSpecific(c, mid, node)
      )
    }

    /**
     * Holds if `node` is specified as a source with the given kind in a CSV flow
     * model.
     */
    predicate isSourceNode(InterpretNode node, string kind) {
      exists(InterpretNode ref, AccessPath output |
        sourceElementRef(ref, output, kind) and
        interpretOutput(output, output.getNumToken(), ref, node)
      )
    }

    /**
     * Holds if `node` is specified as a sink with the given kind in a CSV flow
     * model.
     */
    predicate isSinkNode(InterpretNode node, string kind) {
      exists(InterpretNode ref, AccessPath input |
        sinkElementRef(ref, input, kind) and
        interpretInput(input, input.getNumToken(), ref, node)
      )
    }
  }

  /** Provides a query predicate for outputting a set of relevant flow summaries. */
  module TestOutput {
    /** A flow summary to include in the `summary/3` query predicate. */
    abstract class RelevantSummarizedCallable extends SummarizedCallable {
      /** Gets the string representation of this callable used by `summary/1`. */
      abstract string getCallableCsv();

      /** Holds if flow is propagated between `input` and `output`. */
      predicate relevantSummary(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
      ) {
        this.propagatesFlow(input, output, preservesValue)
      }
    }

    /** Render the kind in the format used in flow summaries. */
    private string renderKind(boolean preservesValue) {
      preservesValue = true and result = "value"
      or
      preservesValue = false and result = "taint"
    }

    /**
     * A query predicate for outputting flow summaries in semi-colon separated format in QL tests.
     * The syntax is: "namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind",
     * ext is hardcoded to empty.
     */
    query predicate summary(string csv) {
      exists(
        RelevantSummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
        boolean preservesValue
      |
        c.relevantSummary(input, output, preservesValue) and
        csv =
          c.getCallableCsv() + getComponentStackCsv(input) + ";" + getComponentStackCsv(output) +
            ";" + renderKind(preservesValue)
      )
    }
  }

  /**
   * Provides query predicates for rendering the generated data flow graph for
   * a summarized callable.
   *
   * Import this module into a `.ql` file of `@kind graph` to render the graph.
   * The graph is restricted to callables from `RelevantSummarizedCallable`.
   */
  module RenderSummarizedCallable {
    /** A summarized callable to include in the graph. */
    abstract class RelevantSummarizedCallable extends SummarizedCallable { }

    private newtype TNodeOrCall =
      MkNode(Node n) {
        exists(RelevantSummarizedCallable c |
          n = summaryNode(c, _)
          or
          n.(ParamNode).isParameterOf(c, _)
        )
      } or
      MkCall(DataFlowCall call) {
        call = summaryDataFlowCall(_) and
        call.getEnclosingCallable() instanceof RelevantSummarizedCallable
      }

    private class NodeOrCall extends TNodeOrCall {
      Node asNode() { this = MkNode(result) }

      DataFlowCall asCall() { this = MkCall(result) }

      string toString() {
        result = this.asNode().toString()
        or
        result = this.asCall().toString()
      }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
       */
      predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        this.asNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
        or
        this.asCall().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }
    }

    query predicate nodes(NodeOrCall n, string key, string val) {
      key = "semmle.label" and val = n.toString()
    }

    private predicate edgesComponent(NodeOrCall a, NodeOrCall b, string value) {
      exists(boolean preservesValue |
        Private::Steps::summaryLocalStep(a.asNode(), b.asNode(), preservesValue) and
        if preservesValue = true then value = "value" else value = "taint"
      )
      or
      exists(ContentSet c |
        Private::Steps::summaryReadStep(a.asNode(), c, b.asNode()) and
        value = "read (" + c + ")"
        or
        Private::Steps::summaryStoreStep(a.asNode(), c, b.asNode()) and
        value = "store (" + c + ")"
        or
        Private::Steps::summaryClearsContent(a.asNode(), c) and
        b = a and
        value = "clear (" + c + ")"
      )
      or
      summaryPostUpdateNode(b.asNode(), a.asNode()) and
      value = "post-update"
      or
      b.asCall() = summaryDataFlowCall(a.asNode()) and
      value = "receiver"
      or
      exists(ArgumentPosition pos |
        summaryArgumentNode(b.asCall(), a.asNode(), pos) and
        value = "argument (" + pos + ")"
      )
    }

    query predicate edges(NodeOrCall a, NodeOrCall b, string key, string value) {
      key = "semmle.label" and
      value = strictconcat(string s | edgesComponent(a, b, s) | s, " / ")
    }
  }
}
