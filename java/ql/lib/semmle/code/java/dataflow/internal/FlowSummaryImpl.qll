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

  newtype TSummaryComponentStack =
    TSingletonSummaryComponentStack(SummaryComponent c) or
    TConsSummaryComponentStack(SummaryComponent head, SummaryComponentStack tail) {
      tail.(RequiredSummaryComponentStack).required(head)
    }

  pragma[nomagic]
  private predicate summary(
    SummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
    boolean preservesValue
  ) {
    c.propagatesFlow(input, output, preservesValue)
  }

  private newtype TSummaryNodeState =
    TSummaryNodeInputState(SummaryComponentStack s) {
      exists(SummaryComponentStack input |
        summary(_, input, _, _) and
        s = input.drop(_)
      )
    } or
    TSummaryNodeOutputState(SummaryComponentStack s) {
      exists(SummaryComponentStack output |
        summary(_, _, output, _) and
        s = output.drop(_)
      )
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
      exists(SummaryComponentStack input |
        summary(c, input, _, _) and
        s = input.drop(_)
      )
    }

    /** Holds if this state is a valid output state for `c`. */
    pragma[nomagic]
    predicate isOutputState(SummarizedCallable c, SummaryComponentStack s) {
      this = TSummaryNodeOutputState(s) and
      exists(SummaryComponentStack output |
        summary(c, _, output, _) and
        s = output.drop(_)
      )
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
  }

  private predicate callbackOutput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, ReturnKind rk
  ) {
    any(SummaryNodeState state).isInputState(c, s) and
    s.head() = TReturnSummaryComponent(rk) and
    receiver = summaryNodeInputState(c, s.drop(1))
  }

  private Node pre(Node post) {
    summaryPostUpdateNode(post, result)
    or
    not summaryPostUpdateNode(post, _) and
    result = post
  }

  private predicate callbackInput(
    SummarizedCallable c, SummaryComponentStack s, Node receiver, int i
  ) {
    any(SummaryNodeState state).isOutputState(c, s) and
    s.head() = TParameterSummaryComponent(i) and
    receiver = pre(summaryNodeOutputState(c, s.drop(1)))
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
            getCallbackParameterType(getNodeType(summaryNodeOutputState(pragma[only_bind_out](c),
                  s.drop(1))), i)
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

  /** Holds if summary node `arg` is the `i`th argument of call `c`. */
  predicate summaryArgumentNode(DataFlowCall c, Node arg, int i) {
    exists(SummarizedCallable callable, SummaryComponentStack s, Node receiver |
      callbackInput(callable, s, receiver, i) and
      arg = summaryNodeOutputState(callable, s) and
      c = summaryDataFlowCall(receiver)
    )
  }

  /** Holds if summary node `post` is a post-update node with pre-update node `pre`. */
  predicate summaryPostUpdateNode(Node post, ParamNode pre) {
    exists(SummarizedCallable c, int i |
      isParameterPostUpdate(post, c, i) and
      pre.isParameterOf(c, i)
    )
  }

  /** Holds if summary node `ret` is a return node of kind `rk`. */
  predicate summaryReturnNode(Node ret, ReturnKind rk) {
    exists(SummarizedCallable callable, SummaryComponentStack s |
      ret = summaryNodeOutputState(callable, s) and
      s = TSingletonSummaryComponentStack(TReturnSummaryComponent(rk))
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
      // If flow through a method updates a parameter from some input A, and that
      // parameter also is returned through B, then we'd like a combined flow from A
      // to B as well. As an example, this simplifies modeling of fluent methods:
      // for `StringBuilder.append(x)` with a specified value flow from qualifier to
      // return value and taint flow from argument 0 to the qualifier, then this
      // allows us to infer taint flow from argument 0 to the return value.
      summaryPostUpdateNode(pred, succ) and preservesValue = true
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
     * Holds if values stored inside content `c` are cleared when passed as
     * input of type `input` in `call`.
     */
    predicate summaryClearsContent(ArgNode arg, Content c) {
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

    /**
     * Holds if data is written into content `c` of argument `arg` using a flow summary.
     *
     * Depending on the type of `c`, this predicate may be relevant to include in the
     * definition of `clearsContent()`.
     */
    predicate summaryStoresIntoArg(Content c, Node arg) {
      exists(ParamUpdateReturnKind rk, ReturnNodeExt ret, PostUpdateNode out |
        exists(DataFlowCall call, SummarizedCallable callable |
          getNodeEnclosingCallable(ret) = callable and
          viableCallable(call) = callable and
          summaryStoreStep(_, c, ret) and
          ret.getKind() = pragma[only_bind_into](rk) and
          out = rk.getAnOutNode(call) and
          arg = out.getPreUpdateNode()
        )
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
      /** Gets the string representation of this callable used by `summary/3`. */
      string getFullString() { result = this.toString() }
    }

    /** A query predicate for outputting flow summaries in QL tests. */
    query predicate summary(string callable, string flow, boolean preservesValue) {
      exists(
        RelevantSummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output
      |
        callable = c.getFullString() and
        c.propagatesFlow(input, output, preservesValue) and
        flow = input + " -> " + output
      )
    }
  }
}
