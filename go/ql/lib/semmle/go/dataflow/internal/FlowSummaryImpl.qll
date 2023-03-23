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
      exists(ContentSet c | this = TWithoutContentSummaryComponent(c) and result = "without " + c)
      or
      exists(ContentSet c | this = TWithContentSummaryComponent(c) and result = "with " + c)
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
      or
      exists(SummaryComponent::SyntheticGlobal sg |
        this = TSyntheticGlobalSummaryComponent(sg) and
        result = "synthetic global (" + sg + ")"
      )
    }
  }

  /** Provides predicates for constructing summary components. */
  module SummaryComponent {
    /** Gets a summary component for content `c`. */
    SummaryComponent content(ContentSet c) { result = TContentSummaryComponent(c) }

    /** Gets a summary component where data is not allowed to be stored in `c`. */
    SummaryComponent withoutContent(ContentSet c) { result = TWithoutContentSummaryComponent(c) }

    /** Gets a summary component where data must be stored in `c`. */
    SummaryComponent withContent(ContentSet c) { result = TWithContentSummaryComponent(c) }

    /** Gets a summary component for a parameter at position `pos`. */
    SummaryComponent parameter(ArgumentPosition pos) { result = TParameterSummaryComponent(pos) }

    /** Gets a summary component for an argument at position `pos`. */
    SummaryComponent argument(ParameterPosition pos) { result = TArgumentSummaryComponent(pos) }

    /** Gets a summary component for a return of kind `rk`. */
    SummaryComponent return(ReturnKind rk) { result = TReturnSummaryComponent(rk) }

    /** Gets a summary component for synthetic global `sg`. */
    SummaryComponent syntheticGlobal(SyntheticGlobal sg) {
      result = TSyntheticGlobalSummaryComponent(sg)
    }

    /**
     * A synthetic global. This represents some form of global state, which
     * summaries can read and write individually.
     */
    abstract class SyntheticGlobal extends string {
      bindingset[this]
      SyntheticGlobal() { any() }
    }
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
    pragma[assume_small_delta]
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

  private predicate noComponentSpecific(SummaryComponent sc) {
    not exists(getComponentSpecific(sc))
  }

  /** Gets a textual representation of this component used for flow summaries. */
  private string getComponent(SummaryComponent sc) {
    result = getComponentSpecific(sc)
    or
    noComponentSpecific(sc) and
    (
      exists(ArgumentPosition pos |
        sc = TParameterSummaryComponent(pos) and
        result = "Parameter[" + getArgumentPosition(pos) + "]"
      )
      or
      exists(ParameterPosition pos |
        sc = TArgumentSummaryComponent(pos) and
        result = "Argument[" + getParameterPosition(pos) + "]"
      )
      or
      sc = TReturnSummaryComponent(getReturnValueKind()) and result = "ReturnValue"
    )
  }

  /** Gets a textual representation of this stack used for flow summaries. */
  string getComponentStack(SummaryComponentStack stack) {
    exists(SummaryComponent head, SummaryComponentStack tail |
      head = stack.head() and
      tail = stack.tail() and
      result = getComponentStack(tail) + "." + getComponent(head)
    )
    or
    exists(SummaryComponent c |
      stack = TSingletonSummaryComponentStack(c) and
      result = getComponent(c)
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
  abstract class SummarizedCallable extends SummarizedCallableBase {
    bindingset[this]
    SummarizedCallable() { any() }

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
     * Holds if all the summaries that apply to `this` are auto generated and not manually created.
     */
    final predicate isAutoGenerated() {
      this.hasProvenance(["generated", "ai-generated"]) and not this.isManual()
    }

    /**
     * Holds if there exists a manual summary that applies to `this`.
     */
    final predicate isManual() { this.hasProvenance("manual") }

    /**
     * Holds if there exists a summary that applies to `this` that has provenance `provenance`.
     */
    predicate hasProvenance(string provenance) { none() }
  }

  /** A callable where there is no flow via the callable. */
  class NeutralCallable extends SummarizedCallableBase {
    NeutralCallable() { neutralElement(this, _) }

    /**
     * Holds if the neutral is auto generated.
     */
    predicate isAutoGenerated() { neutralElement(this, ["generated", "ai-generated"]) }

    /**
     * Holds if there exists a manual neutral that applies to `this`.
     */
    final predicate isManual() { this.hasProvenance("manual") }

    /**
     * Holds if the neutral has provenance `provenance`.
     */
    predicate hasProvenance(string provenance) { neutralElement(this, provenance) }
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
    TReturnSummaryComponent(ReturnKind rk) or
    TSyntheticGlobalSummaryComponent(SummaryComponent::SyntheticGlobal sg) or
    TWithoutContentSummaryComponent(ContentSet c) or
    TWithContentSummaryComponent(ContentSet c)

  private TParameterSummaryComponent callbackSelfParam() {
    result = TParameterSummaryComponent(callbackSelfParameterPosition())
  }

  newtype TSummaryComponentStack =
    TSingletonSummaryComponentStack(SummaryComponent c) or
    TConsSummaryComponentStack(SummaryComponent head, SummaryComponentStack tail) {
      any(RequiredSummaryComponentStack x).required(head, tail)
      or
      any(RequiredSummaryComponentStack x).required(TParameterSummaryComponent(_), tail) and
      head = callbackSelfParam()
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
      output = TConsSummaryComponentStack(callbackSelfParam(), input) and
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
    or
    // Add the post-update node corresponding to the requested argument node
    outputState(c, s) and isCallbackParameter(s)
  }

  private newtype TSummaryNodeState =
    TSummaryNodeInputState(SummaryComponentStack s) { inputState(_, s) } or
    TSummaryNodeOutputState(SummaryComponentStack s) { outputState(_, s) }

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
  }

  pragma[noinline]
  private Node summaryNodeInputState(SummarizedCallable c, SummaryComponentStack s) {
    exists(SummaryNodeState state | state.isInputState(c, s) |
      result = summaryNode(c, state)
      or
      exists(ParameterPosition pos |
        parameterReadState(c, state, pos) and
        result.(ParamNode).isParameterOf(inject(c), pos)
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
    // Same as `isParameterPostUpdate(_, c, pos)`, but can be used in a negative context
    any(SummaryNodeState state).isOutputState(c, SummaryComponentStack::argument(pos))
  }

  private predicate callbackOutput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ReturnKind rk
  ) {
    any(SummaryNodeState state).isInputState(c, s) and
    s.head() = TReturnSummaryComponent(rk) and
    receiver = summaryNodeInputState(c, s.tail())
  }

  private predicate callbackInput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ArgumentPosition pos
  ) {
    any(SummaryNodeState state).isOutputState(c, s) and
    s.head() = TParameterSummaryComponent(pos) and
    receiver = summaryNodeInputState(c, s.tail())
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
        exists(ContentSet cont | result = getContentType(cont) |
          head = TContentSummaryComponent(cont) or
          head = TWithContentSummaryComponent(cont)
        )
        or
        head = TWithoutContentSummaryComponent(_) and
        result = getNodeType(summaryNodeInputState(c, s.tail()))
        or
        exists(ReturnKind rk |
          head = TReturnSummaryComponent(rk) and
          result =
            getCallbackReturnType(getNodeType(summaryNodeInputState(pragma[only_bind_out](c),
                  s.tail())), rk)
        )
        or
        exists(SummaryComponent::SyntheticGlobal sg |
          head = TSyntheticGlobalSummaryComponent(sg) and
          result = getSyntheticGlobalType(sg)
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
                  s.tail())), pos)
        )
        or
        exists(SummaryComponent::SyntheticGlobal sg |
          head = TSyntheticGlobalSummaryComponent(sg) and
          result = getSyntheticGlobalType(sg)
        )
      )
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
      pre.(ParamNode).isParameterOf(inject(c), pos)
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
    exists(SummaryComponentStack s |
      ret = summaryNodeOutputState(_, s) and
      s = TSingletonSummaryComponentStack(TReturnSummaryComponent(rk))
    )
  }

  /**
   * Holds if flow is allowed to pass from parameter `p`, to a return
   * node, and back out to `p`.
   */
  predicate summaryAllowParameterReturnInSelf(ParamNode p) {
    exists(SummarizedCallable c, ParameterPosition ppos | p.isParameterOf(inject(c), ppos) |
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
      exists(SummarizedCallable c, SummaryComponentStack s |
        pred = summaryNodeInputState(c, s.tail()) and
        succ = summaryNodeInputState(c, s) and
        s.head() = [SummaryComponent::withContent(_), SummaryComponent::withoutContent(_)] and
        preservesValue = true
      )
    }

    /**
     * Holds if there is a read step of content `c` from `pred` to `succ`, which
     * is synthesized from a flow summary.
     */
    predicate summaryReadStep(Node pred, ContentSet c, Node succ) {
      exists(SummarizedCallable sc, SummaryComponentStack s |
        pred = summaryNodeInputState(sc, s.tail()) and
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
        succ = summaryNodeOutputState(sc, s.tail()) and
        SummaryComponent::content(c) = s.head()
      )
    }

    /**
     * Holds if there is a jump step from `pred` to `succ`, which is synthesized
     * from a flow summary.
     */
    predicate summaryJumpStep(Node pred, Node succ) {
      exists(SummaryComponentStack s |
        s = SummaryComponentStack::singleton(SummaryComponent::syntheticGlobal(_)) and
        pred = summaryNodeOutputState(_, s) and
        succ = summaryNodeInputState(_, s)
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
      exists(SummarizedCallable sc, SummaryNodeState state, SummaryComponentStack stack |
        n = summaryNode(sc, state) and
        state.isInputState(sc, stack) and
        stack.head() = SummaryComponent::withoutContent(c)
      )
    }

    /**
     * Holds if the value that is being tracked is expected to be stored inside
     * content `c` at `n`.
     */
    predicate summaryExpectsContent(Node n, ContentSet c) {
      exists(SummarizedCallable sc, SummaryNodeState state, SummaryComponentStack stack |
        n = summaryNode(sc, state) and
        state.isInputState(sc, stack) and
        stack.head() = SummaryComponent::withContent(c)
      )
    }

    pragma[noinline]
    private predicate viableParam(
      DataFlowCall call, SummarizedCallable sc, ParameterPosition ppos, ParamNode p
    ) {
      exists(DataFlowCallable c |
        c = inject(sc) and
        p.isParameterOf(c, ppos) and
        c = viableCallable(call)
      )
    }

    pragma[nomagic]
    private ParamNode summaryArgParam0(DataFlowCall call, ArgNode arg, SummarizedCallable sc) {
      exists(ParameterPosition ppos |
        argumentPositionMatch(call, arg, ppos) and
        viableParam(call, sc, ppos, result)
      )
    }

    /**
     * Holds if `p` can reach `n` in a summarized callable, using only value-preserving
     * local steps. `clearsOrExpects` records whether any node on the path from `p` to
     * `n` either clears or expects contents.
     */
    private predicate paramReachesLocal(ParamNode p, Node n, boolean clearsOrExpects) {
      viableParam(_, _, _, p) and
      n = p and
      clearsOrExpects = false
      or
      exists(Node mid, boolean clearsOrExpectsMid |
        paramReachesLocal(p, mid, clearsOrExpectsMid) and
        summaryLocalStep(mid, n, true) and
        if
          summaryClearsContent(n, _) or
          summaryExpectsContent(n, _)
        then clearsOrExpects = true
        else clearsOrExpects = clearsOrExpectsMid
      )
    }

    /**
     * Holds if use-use flow starting from `arg` should be prohibited.
     *
     * This is the case when `arg` is the argument of a call that targets a
     * flow summary where the corresponding parameter either clears contents
     * or expects contents.
     */
    pragma[nomagic]
    predicate prohibitsUseUseFlow(ArgNode arg, SummarizedCallable sc) {
      exists(ParamNode p, ParameterPosition ppos, Node ret |
        paramReachesLocal(p, ret, true) and
        p = summaryArgParam0(_, arg, sc) and
        p.isParameterOf(_, pragma[only_bind_into](ppos)) and
        isParameterPostUpdate(ret, _, pragma[only_bind_into](ppos))
      )
    }

    bindingset[ret]
    private ParamNode summaryArgParam(
      ArgNode arg, ReturnNodeExt ret, OutNodeExt out, SummarizedCallable sc
    ) {
      exists(DataFlowCall call, ReturnKindExt rk |
        result = summaryArgParam0(call, arg, sc) and
        ret.getKind() = pragma[only_bind_into](rk) and
        out = pragma[only_bind_into](rk).getAnOutNode(call)
      )
    }

    /**
     * Holds if `arg` flows to `out` using a simple value-preserving flow
     * summary, that is, a flow summary without reads and stores.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summaryThroughStepValue(ArgNode arg, Node out, SummarizedCallable sc) {
      exists(ReturnKind rk, ReturnNode ret, DataFlowCall call |
        summaryLocalStep(summaryArgParam0(call, arg, sc), ret, true) and
        ret.getKind() = pragma[only_bind_into](rk) and
        out = getAnOutNode(call, pragma[only_bind_into](rk))
      )
    }

    /**
     * Holds if `arg` flows to `out` using a simple flow summary involving taint
     * step, that is, a flow summary without reads and stores.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summaryThroughStepTaint(ArgNode arg, Node out, SummarizedCallable sc) {
      exists(ReturnNodeExt ret | summaryLocalStep(summaryArgParam(arg, ret, out, sc), ret, false))
    }

    /**
     * Holds if there is a read(+taint) of `c` from `arg` to `out` using a
     * flow summary.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summaryGetterStep(ArgNode arg, ContentSet c, Node out, SummarizedCallable sc) {
      exists(Node mid, ReturnNodeExt ret |
        summaryReadStep(summaryArgParam(arg, ret, out, sc), c, mid) and
        summaryLocalStep(mid, ret, _)
      )
    }

    /**
     * Holds if there is a (taint+)store of `arg` into content `c` of `out` using a
     * flow summary.
     *
     * NOTE: This step should not be used in global data-flow/taint-tracking, but may
     * be useful to include in the exposed local data-flow/taint-tracking relations.
     */
    predicate summarySetterStep(ArgNode arg, ContentSet c, Node out, SummarizedCallable sc) {
      exists(Node mid, ReturnNodeExt ret |
        summaryLocalStep(summaryArgParam(arg, ret, out, sc), mid, _) and
        summaryStoreStep(mid, c, ret)
      )
    }
  }

  /**
   * Provides a means of translating externally (e.g., MaD) defined flow
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

    /** Holds if specification component `token` parses as parameter `pos`. */
    predicate parseParam(AccessPathToken token, ArgumentPosition pos) {
      token.getName() = "Parameter" and
      pos = parseParamBody(token.getAnArgument())
    }

    /** Holds if specification component `token` parses as argument `pos`. */
    predicate parseArg(AccessPathToken token, ParameterPosition pos) {
      token.getName() = "Argument" and
      pos = parseArgBody(token.getAnArgument())
    }

    /** Holds if specification component `token` parses as synthetic global `sg`. */
    predicate parseSynthGlobal(AccessPathToken token, string sg) {
      token.getName() = "SyntheticGlobal" and
      sg = token.getAnArgument()
    }

    private class SyntheticGlobalFromAccessPath extends SummaryComponent::SyntheticGlobal {
      SyntheticGlobalFromAccessPath() { parseSynthGlobal(_, this) }
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
      exists(string sg |
        parseSynthGlobal(token, sg) and result = SummaryComponent::syntheticGlobal(sg)
      )
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

      private predicate relevantSummaryElementGenerated(
        AccessPath inSpec, AccessPath outSpec, string kind
      ) {
        summaryElement(this, inSpec, outSpec, kind, ["generated", "ai-generated"]) and
        not summaryElement(this, _, _, _, "manual")
      }

      private predicate relevantSummaryElement(AccessPath inSpec, AccessPath outSpec, string kind) {
        summaryElement(this, inSpec, outSpec, kind, "manual")
        or
        this.relevantSummaryElementGenerated(inSpec, outSpec, kind)
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

      override predicate hasProvenance(string provenance) {
        summaryElement(this, _, _, _, provenance)
      }
    }

    /** Holds if component `c` of specification `spec` cannot be parsed. */
    predicate invalidSpecComponent(AccessPath spec, string c) {
      c = spec.getToken(_) and
      not exists(interpretComponent(c))
    }

    /**
     * Holds if token `part` of specification `spec` has an invalid index.
     * E.g., `Argument[-1]`.
     */
    predicate invalidIndexComponent(AccessPath spec, AccessPathToken part) {
      part = spec.getToken(_) and
      part.getName() = ["Parameter", "Argument"] and
      AccessPath::parseInt(part.getArgumentList()) < 0
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
     * Holds if `node` is specified as a source with the given kind in a MaD flow
     * model.
     */
    predicate isSourceNode(InterpretNode node, string kind) {
      exists(InterpretNode ref, AccessPath output |
        sourceElementRef(ref, output, kind) and
        interpretOutput(output, output.getNumToken(), ref, node)
      )
    }

    /**
     * Holds if `node` is specified as a sink with the given kind in a MaD flow
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
    /** A flow summary to include in the `summary/1` query predicate. */
    abstract class RelevantSummarizedCallable instanceof SummarizedCallable {
      /** Gets the string representation of this callable used by `summary/1`. */
      abstract string getCallableCsv();

      /** Holds if flow is propagated between `input` and `output`. */
      predicate relevantSummary(
        SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
      ) {
        super.propagatesFlow(input, output, preservesValue)
      }

      string toString() { result = super.toString() }
    }

    /** A model to include in the `neutral/1` query predicate. */
    abstract class RelevantNeutralCallable instanceof NeutralCallable {
      /** Gets the string representation of this callable used by `neutral/1`. */
      abstract string getCallableCsv();

      string toString() { result = super.toString() }
    }

    /** Render the kind in the format used in flow summaries. */
    private string renderKind(boolean preservesValue) {
      preservesValue = true and result = "value"
      or
      preservesValue = false and result = "taint"
    }

    private string renderProvenance(SummarizedCallable c) {
      if c.isManual() then result = "manual" else c.hasProvenance(result)
    }

    private string renderProvenanceNeutral(NeutralCallable c) {
      if c.isManual() then result = "manual" else c.hasProvenance(result)
    }

    /**
     * A query predicate for outputting flow summaries in semi-colon separated format in QL tests.
     * The syntax is: "namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind;provenance",
     * ext is hardcoded to empty.
     */
    query predicate summary(string csv) {
      exists(
        RelevantSummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
        boolean preservesValue
      |
        c.relevantSummary(input, output, preservesValue) and
        csv =
          c.getCallableCsv() // Callable information
            + getComponentStack(input) + ";" // input
            + getComponentStack(output) + ";" // output
            + renderKind(preservesValue) + ";" // kind
            + renderProvenance(c) // provenance
      )
    }

    /**
     * Holds if a neutral model `csv` exists (semi-colon separated format). Used for testing purposes.
     * The syntax is: "namespace;type;name;signature;provenance"",
     */
    query predicate neutral(string csv) {
      exists(RelevantNeutralCallable c |
        csv =
          c.getCallableCsv() // Callable information
            + renderProvenanceNeutral(c) // provenance
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
    abstract class RelevantSummarizedCallable instanceof SummarizedCallable {
      string toString() { result = super.toString() }
    }

    private newtype TNodeOrCall =
      MkNode(Node n) {
        exists(RelevantSummarizedCallable c |
          n = summaryNode(c, _)
          or
          n.(ParamNode).isParameterOf(inject(c), _)
        )
      } or
      MkCall(DataFlowCall call) {
        call = summaryDataFlowCall(_) and
        call.getEnclosingCallable() = inject(any(RelevantSummarizedCallable c))
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
        or
        Private::Steps::summaryExpectsContent(a.asNode(), c) and
        b = a and
        value = "expect (" + c + ")"
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
