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
      exists(Content c | this = TContentSummaryComponent(c) and result = c.toString())
      or
      exists(int i | this = TParameterSummaryComponent(i) and result = "parameter " + i)
      or
      exists(int i | this = TArgumentSummaryComponent(i) and result = "argument " + i)
      or
      exists(ReturnKind rk | this = TReturnSummaryComponent(rk) and result = "return (" + rk + ")")
    }
  }

  /** Provides predicates for constructing summary components. */
  module SummaryComponent {
    /** Gets a summary component for content `c`. */
    SummaryComponent content(Content c) { result = TContentSummaryComponent(c) }

    /** Gets a summary component for parameter `i`. */
    SummaryComponent parameter(int i) { result = TParameterSummaryComponent(i) }

    /** Gets a summary component for argument `i`. */
    SummaryComponent argument(int i) { result = TArgumentSummaryComponent(i) }

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
    SummaryComponent bottom() { result = this.drop(this.length() - 1).head() }

    /** Gets a textual representation of this stack. */
    string toString() {
      exists(SummaryComponent head, SummaryComponentStack tail |
        head = this.head() and
        tail = this.tail() and
        result = head + " of " + tail
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

    /** Gets a singleton stack for argument `i`. */
    SummaryComponentStack argument(int i) { result = singleton(SummaryComponent::argument(i)) }

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
      exists(int i | sc = TParameterSummaryComponent(i) and result = "Parameter[" + i + "]")
      or
      exists(int i | sc = TArgumentSummaryComponent(i) and result = "Argument[" + i + "]")
      or
      sc = TReturnSummaryComponent(getReturnValueKind()) and result = "ReturnValue"
    )
  }

  /** Gets a textual representation of this stack used for flow summaries. */
  string getComponentStackCsv(SummaryComponentStack stack) {
    exists(SummaryComponent head, SummaryComponentStack tail |
      head = stack.head() and
      tail = stack.tail() and
      result = getComponentCsv(head) + " of " + getComponentStackCsv(tail)
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
  abstract class RequiredSummaryComponentStack extends SummaryComponentStack {
    /**
     * Holds if the stack obtained by pushing `head` onto `tail` is required.
     */
    abstract predicate required(SummaryComponent c);
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
     * the `i`th argument to this callable.
     */
    pragma[nomagic]
    predicate clearsContent(int i, Content content) { none() }
  }
}

/**
 * Provides predicates for compiling flow summaries down to atomic local steps,
 * read steps, and store steps.
 */
module Private {
  private import Public

  newtype TSummaryComponent =
    TContentSummaryComponent(Content c) or
    TParameterSummaryComponent(int i) { parameterPosition(i) } or
    TArgumentSummaryComponent(int i) { parameterPosition(i) } or
    TReturnSummaryComponent(ReturnKind rk)

  private TSummaryComponent thisParam() {
    result = TParameterSummaryComponent(instanceParameterPosition())
  }

  newtype TSummaryComponentStack =
    TSingletonSummaryComponentStack(SummaryComponent c) or
    TConsSummaryComponentStack(SummaryComponent head, SummaryComponentStack tail) {
      tail.(RequiredSummaryComponentStack).required(head)
      or
      tail.(RequiredSummaryComponentStack).required(TParameterSummaryComponent(_)) and
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
   * writes to (contents of) the `i`th argument, and `c` has a
   * value-preserving flow summary from the `i`th argument to a return value
   * (`return`).
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
    exists(int i |
      summary(c, input, arg, preservesValue) and
      isContentOfArgument(arg, i) and
      summary(c, SummaryComponentStack::singleton(TArgumentSummaryComponent(i)), return, true) and
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

  private predicate isContentOfArgument(SummaryComponentStack s, int i) {
    s.head() = TContentSummaryComponent(_) and isContentOfArgument(s.tail(), i)
    or
    s = TSingletonSummaryComponentStack(TArgumentSummaryComponent(i))
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
    TSummaryNodeClearsContentState(int i, boolean post) {
      any(SummarizedCallable sc).clearsContent(i, _) and post in [false, true]
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
      exists(int i, boolean post, string postStr |
        this = TSummaryNodeClearsContentState(i, post) and
        (if post = true then postStr = " (post)" else postStr = "") and
        result = "clear: " + i + postStr
      )
    }
  }

  /**
   * Holds if `state` represents having read the `i`th argument for `c`. In this case
   * we are not synthesizing a data-flow node, but instead assume that a relevant
   * parameter node already exists.
   */
  private predicate parameterReadState(SummarizedCallable c, SummaryNodeState state, int i) {
    state.isInputState(c, SummaryComponentStack::argument(i))
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
    exists(int i |
      c.clearsContent(i, _) and
      state = TSummaryNodeClearsContentState(i, _)
    )
  }

  pragma[noinline]
  private Node summaryNodeInputState(SummarizedCallable c, SummaryComponentStack s) {
    exists(SummaryNodeState state | state.isInputState(c, s) |
      result = summaryNode(c, state)
      or
      exists(int i |
        parameterReadState(c, state, i) and
        result.(ParamNode).isParameterOf(c, i)
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
   * Holds if a write targets `post`, which is a post-update node for the `i`th
   * parameter of `c`.
   */
  private predicate isParameterPostUpdate(Node post, SummarizedCallable c, int i) {
    post = summaryNodeOutputState(c, SummaryComponentStack::argument(i))
  }

  /** Holds if a parameter node is required for the `i`th parameter of `c`. */
  predicate summaryParameterNodeRange(SummarizedCallable c, int i) {
    parameterReadState(c, _, i)
    or
    isParameterPostUpdate(_, c, i)
    or
    c.clearsContent(i, _)
  }

  private predicate callbackOutput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ReturnKind rk
  ) {
    any(SummaryNodeState state).isInputState(c, s) and
    s.head() = TReturnSummaryComponent(rk) and
    receiver = summaryNodeInputState(c, s.drop(1))
  }

  private predicate callbackInput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, int i
  ) {
    any(SummaryNodeState state).isOutputState(c, s) and
    s.head() = TParameterSummaryComponent(i) and
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
        exists(Content cont |
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
        exists(Content cont |
          head = TContentSummaryComponent(cont) and result = getContentType(cont)
        )
        or
        s.length() = 1 and
        exists(ReturnKind rk |
          head = TReturnSummaryComponent(rk) and
          result = getReturnType(c, rk)
        )
        or
        exists(int i | head = TParameterSummaryComponent(i) |
          result =
            getCallbackParameterType(getNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                  s.drop(1))), i)
        )
      )
    )
    or
    exists(SummarizedCallable c, int i, ParamNode p |
      n = summaryNode(c, TSummaryNodeClearsContentState(i, false)) and
      p.isParameterOf(c, i) and
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

  /** Holds if summary node `arg` is the `i`th argument of call `c`. */
  predicate summaryArgumentNode(DataFlowCall c, Node arg, int i) {
    exists(SummarizedCallable callable, SummaryComponentStack s, Node receiver |
      callbackInput(callable, s, receiver, i) and
      arg = summaryNodeOutputState(callable, s) and
      c = summaryDataFlowCall(receiver)
    )
  }

  /** Holds if summary node `post` is a post-update node with pre-update node `pre`. */
  predicate summaryPostUpdateNode(Node post, Node pre) {
    exists(SummarizedCallable c, int i |
      isParameterPostUpdate(post, c, i) and
      pre.(ParamNode).isParameterOf(c, i)
      or
      pre = summaryNode(c, TSummaryNodeClearsContentState(i, false)) and
      post = summaryNode(c, TSummaryNodeClearsContentState(i, true))
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
    exists(SummarizedCallable c, int i | p.isParameterOf(c, i) |
      c.clearsContent(i, _)
      or
      exists(SummaryComponentStack inputContents, SummaryComponentStack outputContents |
        summary(c, inputContents, outputContents, _) and
        inputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(i)) and
        outputContents.bottom() = pragma[only_bind_into](TArgumentSummaryComponent(i))
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
      exists(SummarizedCallable c, int i |
        pred.(ParamNode).isParameterOf(c, i) and
        succ = summaryNode(c, TSummaryNodeClearsContentState(i, _)) and
        preservesValue = true
      )
    }

    /**
     * Holds if there is a read step of content `c` from `pred` to `succ`, which
     * is synthesized from a flow summary.
     */
    predicate summaryReadStep(Node pred, Content c, Node succ) {
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
    predicate summaryStoreStep(Node pred, Content c, Node succ) {
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
    predicate summaryClearsContent(Node n, Content c) {
      exists(SummarizedCallable sc, int i |
        n = summaryNode(sc, TSummaryNodeClearsContentState(i, true)) and
        sc.clearsContent(i, c)
      )
    }

    /**
     * Holds if values stored inside content `c` are cleared inside a
     * callable to which `arg` is an argument.
     *
     * In such cases, it is important to prevent use-use flow out of
     * `arg` (see comment for `summaryClearsContent`).
     */
    predicate summaryClearsContentArg(ArgNode arg, Content c) {
      exists(DataFlowCall call, int i |
        viableCallable(call).(SummarizedCallable).clearsContent(i, c) and
        arg.argumentOf(call, i)
      )
    }

    pragma[nomagic]
    private ParamNode summaryArgParam(ArgNode arg, ReturnKindExt rk, OutNodeExt out) {
      exists(DataFlowCall call, int pos, SummarizedCallable callable |
        arg.argumentOf(call, pos) and
        viableCallable(call) = callable and
        result.isParameterOf(callable, pos) and
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
    predicate summaryGetterStep(ArgNode arg, Content c, Node out) {
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
    predicate summarySetterStep(ArgNode arg, Content c, Node out) {
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
      summaryElement(_, spec, _, _) or
      summaryElement(_, _, spec, _) or
      sourceElement(_, spec, _) or
      sinkElement(_, spec, _)
    }

    /** Holds if the `n`th component of specification `s` is `c`. */
    predicate specSplit(string s, string c, int n) { relevantSpec(s) and s.splitAt(" of ", n) = c }

    /** Holds if specification `s` has length `len`. */
    predicate specLength(string s, int len) { len = 1 + max(int n | specSplit(s, _, n)) }

    /** Gets the last component of specification `s`. */
    string specLast(string s) {
      exists(int len |
        specLength(s, len) and
        specSplit(s, result, len - 1)
      )
    }

    /** Holds if specification component `c` parses as parameter `n`. */
    predicate parseParam(string c, int n) {
      specSplit(_, c, _) and
      (
        c.regexpCapture("Parameter\\[([-0-9]+)\\]", 1).toInt() = n
        or
        exists(int n1, int n2 |
          c.regexpCapture("Parameter\\[([-0-9]+)\\.\\.([0-9]+)\\]", 1).toInt() = n1 and
          c.regexpCapture("Parameter\\[([-0-9]+)\\.\\.([0-9]+)\\]", 2).toInt() = n2 and
          n = [n1 .. n2]
        )
      )
    }

    /** Holds if specification component `c` parses as argument `n`. */
    predicate parseArg(string c, int n) {
      specSplit(_, c, _) and
      (
        c.regexpCapture("Argument\\[([-0-9]+)\\]", 1).toInt() = n
        or
        exists(int n1, int n2 |
          c.regexpCapture("Argument\\[([-0-9]+)\\.\\.([0-9]+)\\]", 1).toInt() = n1 and
          c.regexpCapture("Argument\\[([-0-9]+)\\.\\.([0-9]+)\\]", 2).toInt() = n2 and
          n = [n1 .. n2]
        )
      )
    }

    private SummaryComponent interpretComponent(string c) {
      specSplit(_, c, _) and
      (
        exists(int pos | parseArg(c, pos) and result = SummaryComponent::argument(pos))
        or
        exists(int pos | parseParam(c, pos) and result = SummaryComponent::parameter(pos))
        or
        c = "ReturnValue" and result = SummaryComponent::return(getReturnValueKind())
        or
        result = interpretComponentSpecific(c)
      )
    }

    /**
     * Holds if `spec` specifies summary component stack `stack`.
     */
    predicate interpretSpec(string spec, SummaryComponentStack stack) {
      interpretSpec(spec, 0, stack)
    }

    private predicate interpretSpec(string spec, int idx, SummaryComponentStack stack) {
      exists(string c |
        relevantSpec(spec) and
        specLength(spec, idx + 1) and
        specSplit(spec, c, idx) and
        stack = SummaryComponentStack::singleton(interpretComponent(c))
      )
      or
      exists(SummaryComponent head, SummaryComponentStack tail |
        interpretSpec(spec, idx, head, tail) and
        stack = SummaryComponentStack::push(head, tail)
      )
    }

    private predicate interpretSpec(
      string output, int idx, SummaryComponent head, SummaryComponentStack tail
    ) {
      exists(string c |
        interpretSpec(output, idx + 1, tail) and
        specSplit(output, c, idx) and
        head = interpretComponent(c)
      )
    }

    private class MkStack extends RequiredSummaryComponentStack {
      MkStack() { interpretSpec(_, _, _, this) }

      override predicate required(SummaryComponent c) { interpretSpec(_, _, c, this) }
    }

    private class SummarizedCallableExternal extends SummarizedCallable {
      SummarizedCallableExternal() { summaryElement(this, _, _, _) }

      override predicate propagatesFlow(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
      ) {
        exists(string inSpec, string outSpec, string kind |
          summaryElement(this, inSpec, outSpec, kind) and
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
    predicate invalidSpecComponent(string spec, string c) {
      specSplit(spec, c, _) and
      not exists(interpretComponent(c))
    }

    private predicate inputNeedsReference(string c) {
      c = "Argument" or
      parseArg(c, _)
    }

    private predicate outputNeedsReference(string c) {
      c = "Argument" or
      parseArg(c, _) or
      c = "ReturnValue"
    }

    private predicate sourceElementRef(InterpretNode ref, string output, string kind) {
      exists(SourceOrSinkElement e |
        sourceElement(e, output, kind) and
        if outputNeedsReference(specLast(output))
        then e = ref.getCallTarget()
        else e = ref.asElement()
      )
    }

    private predicate sinkElementRef(InterpretNode ref, string input, string kind) {
      exists(SourceOrSinkElement e |
        sinkElement(e, input, kind) and
        if inputNeedsReference(specLast(input))
        then e = ref.getCallTarget()
        else e = ref.asElement()
      )
    }

    private predicate interpretOutput(string output, int idx, InterpretNode ref, InterpretNode node) {
      sourceElementRef(ref, output, _) and
      specLength(output, idx) and
      node = ref
      or
      exists(InterpretNode mid, string c |
        interpretOutput(output, idx + 1, ref, mid) and
        specSplit(output, c, idx)
      |
        exists(int pos |
          node.asNode().(PostUpdateNode).getPreUpdateNode().(ArgNode).argumentOf(mid.asCall(), pos)
        |
          c = "Argument" or parseArg(c, pos)
        )
        or
        exists(int pos | node.asNode().(ParamNode).isParameterOf(mid.asCallable(), pos) |
          c = "Parameter" or parseParam(c, pos)
        )
        or
        c = "ReturnValue" and
        node.asNode() = getAnOutNodeExt(mid.asCall(), TValueReturn(getReturnValueKind()))
        or
        interpretOutputSpecific(c, mid, node)
      )
    }

    private predicate interpretInput(string input, int idx, InterpretNode ref, InterpretNode node) {
      sinkElementRef(ref, input, _) and
      specLength(input, idx) and
      node = ref
      or
      exists(InterpretNode mid, string c |
        interpretInput(input, idx + 1, ref, mid) and
        specSplit(input, c, idx)
      |
        exists(int pos | node.asNode().(ArgNode).argumentOf(mid.asCall(), pos) |
          c = "Argument" or parseArg(c, pos)
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
      exists(InterpretNode ref, string output |
        sourceElementRef(ref, output, kind) and
        interpretOutput(output, 0, ref, node)
      )
    }

    /**
     * Holds if `node` is specified as a sink with the given kind in a CSV flow
     * model.
     */
    predicate isSinkNode(InterpretNode node, string kind) {
      exists(InterpretNode ref, string input |
        sinkElementRef(ref, input, kind) and
        interpretInput(input, 0, ref, node)
      )
    }
  }

  /** Provides a query predicate for outputting a set of relevant flow summaries. */
  module TestOutput {
    /** A flow summary to include in the `summary/3` query predicate. */
    abstract class RelevantSummarizedCallable extends SummarizedCallable {
      /** Gets the string representation of this callable used by `summary/1`. */
      abstract string getCallableCsv();

      /** Holds if flow is progated between `input` and `output` */
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
          c.getCallableCsv() + ";;" + getComponentStackCsv(input) + ";" +
            getComponentStackCsv(output) + ";" + renderKind(preservesValue)
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
      exists(Content c |
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
      exists(int i |
        summaryArgumentNode(b.asCall(), a.asNode(), i) and
        value = "argument (" + i + ")"
      )
    }

    query predicate edges(NodeOrCall a, NodeOrCall b, string key, string value) {
      key = "semmle.label" and
      value = strictconcat(string s | edgesComponent(a, b, s) | s, " / ")
    }
  }
}
