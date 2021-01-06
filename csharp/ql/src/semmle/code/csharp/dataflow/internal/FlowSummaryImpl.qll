/**
 * Provides classes and predicates for definining flow summaries.
 *
 * The definitions in this file are language-independant, and language-specific
 * definitions are passed in via the `FlowSummarySpecific` module.
 */

private import FlowSummarySpecific::Private

/**
 * Provides classes and predicates for definining flow summaries.
 */
module Public {
  import FlowSummarySpecific::Public

  private newtype TContentList =
    TNilContentList() or
    TConsContentList(Content head, ContentList tail) {
      tail = TNilContentList()
      or
      any(SummarizedCallable c).requiresContentList(head, tail) and
      tail.length() < accessPathLimit()
    }

  /** A content list. */
  class ContentList extends TContentList {
    /** Gets the head of this content list, if any. */
    Content head() { this = TConsContentList(result, _) }

    /** Gets the tail of this content list, if any. */
    ContentList tail() { this = TConsContentList(_, result) }

    /** Gets the length of this content list. */
    int length() {
      this = TNilContentList() and result = 0
      or
      result = 1 + this.tail().length()
    }

    /** Gets the content list obtained by dropping the first `i` elements, if any. */
    ContentList drop(int i) {
      i = 0 and result = this
      or
      result = this.tail().drop(i - 1)
    }

    /** Holds if this content list contains content `c`. */
    predicate contains(Content c) { c = this.drop(_).head() }

    /** Gets a textual representation of this content list. */
    string toString() {
      exists(Content head, ContentList tail |
        head = this.head() and
        tail = this.tail() and
        if tail.length() = 0 then result = head.toString() else result = head + ", " + tail
      )
      or
      this = TNilContentList() and
      result = "<empty>"
    }
  }

  /** Provides predicates for constructing content lists. */
  module ContentList {
    /** Gets the empty content list. */
    ContentList empty() { result = TNilContentList() }

    /** Gets a singleton content list containing `c`. */
    ContentList singleton(Content c) { result = TConsContentList(c, TNilContentList()) }

    /** Gets the content list obtained by consing `head` onto `tail`. */
    ContentList cons(Content head, ContentList tail) { result = TConsContentList(head, tail) }
  }

  /** A callable with flow summaries. */
  abstract class SummarizedCallable extends SummarizableCallable {
    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step
     * or a taint-step.
     */
    pragma[nomagic]
    predicate propagatesFlow(SummaryInput input, SummaryOutput output, boolean preservesValue) {
      none()
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `inputContents` describes the contents that is popped from the access
     * path from the input and `outputContents` describes the contents that
     * is pushed onto the resulting access path.
     *
     * `preservesValue` indicates whether this is a value-preserving step
     * or a taint-step.
     */
    pragma[nomagic]
    predicate propagatesFlow(
      SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      none()
    }

    /**
     * Holds if the content list obtained by consing `head` onto `tail` is needed
     * for a summary specified by `propagatesFlow()`.
     *
     * This predicate is needed for QL technical reasons only (the IPA type used
     * to represent content lists needs to be bounded).
     *
     * Only summaries using content lists of length >= 2 need to override this
     * predicate.
     */
    pragma[nomagic]
    predicate requiresContentList(Content head, ContentList tail) { none() }

    /**
     * Holds if values stored inside `content` are cleared on objects passed as
     * arguments of type `input` to this callable.
     */
    pragma[nomagic]
    predicate clearsContent(SummaryInput input, Content content) { none() }
  }
}

/**
 * Provides predicates for compiling flow summaries down to atomic local steps,
 * read steps, and store steps.
 */
module Private {
  private import Public
  private import DataFlowDispatch
  private import FlowSummarySpecific::Public

  /**
   * Holds if data may flow from `input` to `output` when calling `c`.
   *
   * `inputContents` describes the contents that is popped from the access
   * path from the input and `outputContents` describes the contents that
   * is pushed onto the resulting access path.
   *
   * `preservesValue` indicates whether this is a value-preserving step
   * or a taint-step.
   */
  pragma[nomagic]
  predicate summary(
    SummarizedCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
    ContentList outputContents, boolean preservesValue
  ) {
    c.propagatesFlow(input, output, preservesValue) and
    inputContents = ContentList::empty() and
    outputContents = ContentList::empty()
    or
    c.propagatesFlow(input, inputContents, output, outputContents, preservesValue)
  }

  /** Gets the `i`th element in `l`. */
  pragma[noinline]
  private Content getContent(ContentList l, int i) { result = l.drop(i).head() }

  private newtype TContentListRev =
    TConsNilContentListRev(Content c) or
    TConsContentListRev(Content head, ContentListRev tail) {
      exists(ContentList l, int i |
        tail = reverse(l, i) and
        head = getContent(l, i)
      )
    }

  /**
   * Gets the reversed content list that contains the `i` first elements of `l`
   * in reverse order.
   */
  private ContentListRev reverse(ContentList l, int i) {
    exists(Content head |
      result = TConsNilContentListRev(head) and
      head = l.head() and
      i = 1
      or
      exists(ContentListRev tail |
        result = TConsContentListRev(head, tail) and
        tail = reverse(l, i - 1) and
        head = getContent(l, i - 1)
      )
    )
  }

  /** A reversed, non-empty content list. */
  private class ContentListRev extends TContentListRev {
    /** Gets the head of this reversed content list. */
    Content head() {
      this = TConsNilContentListRev(result) or this = TConsContentListRev(result, _)
    }

    /** Gets the tail of this reversed content list, if any. */
    ContentListRev tail() { this = TConsContentListRev(_, result) }

    /** Gets the length of this reversed content list. */
    int length() {
      this = TConsNilContentListRev(_) and result = 1
      or
      result = 1 + this.tail().length()
    }

    /** Gets a textual representation of this reversed content list. */
    string toString() {
      exists(Content head |
        this = TConsNilContentListRev(head) and
        result = head.toString()
        or
        exists(ContentListRev tail |
          head = this.head() and
          tail = this.tail() and
          result = head + ", " + tail
        )
      )
    }
  }

  private newtype TSummaryInternalNodeState =
    TSummaryInternalNodeReadState(SummaryInput input, ContentListRev l) {
      exists(ContentList inputContents |
        summary(_, input, inputContents, _, _, _) and
        l = reverse(inputContents, _)
      )
    } or
    TSummaryInternalNodeStoreState(SummaryOutput output, ContentListRev l) {
      exists(ContentList outputContents |
        summary(_, _, _, output, outputContents, _) and
        l = reverse(outputContents, _)
      )
    }

  /**
   * A state used to break up (complex) flow summaries into atomic flow steps.
   * For a flow summary with input `input`, input contents `inputContents`, output
   * `output`, and output contents `outputContents`, the following states are used:
   *
   * - `TSummaryInternalNodeReadState(SummaryInput input, ContentListRev l)`:
   *   this state represents that the contents in `l` has been read from `input`,
   *   where `l` is a reversed, non-empty suffix of `inputContents`.
   * - `TSummaryInternalNodeStoreState(SummaryOutput output, ContentListRev l)`:
   *   this state represents that the contents of `l` remains to be stored into
   *   `output`, where `l` is a reversed, non-empty suffix of `outputContents`.
   */
  class SummaryInternalNodeState extends TSummaryInternalNodeState {
    /**
     * Holds if this state represents that the `i` first elements of `inputContents`
     * have been read from `input` in `c`.
     */
    pragma[nomagic]
    predicate isReadState(SummarizedCallable c, SummaryInput input, ContentList inputContents, int i) {
      this = TSummaryInternalNodeReadState(input, reverse(inputContents, i)) and
      summary(c, input, inputContents, _, _, _)
    }

    /**
     * Holds if this state represents that the `i` first elements of `outputContents`
     * remain to be stored into `output` in `c`.
     */
    pragma[nomagic]
    predicate isStoreState(
      SummarizedCallable c, SummaryOutput output, ContentList outputContents, int i
    ) {
      this = TSummaryInternalNodeStoreState(output, reverse(outputContents, i)) and
      summary(c, _, _, output, outputContents, _)
    }

    /** Gets the type of a node in this state. */
    DataFlowType getType() {
      exists(ContentListRev l | result = getContentType(l.head()) |
        this = TSummaryInternalNodeReadState(_, l)
        or
        this = TSummaryInternalNodeStoreState(_, l)
      )
    }

    /** Gets a textual representation of this state. */
    string toString() {
      exists(SummaryInput input, ContentListRev l |
        this = TSummaryInternalNodeReadState(input, l) and
        result = "input: " + input + ", read: " + l
      )
      or
      exists(SummaryOutput output, ContentListRev l |
        this = TSummaryInternalNodeStoreState(output, l) and
        result = "output: " + output + ", to store: " + l
      )
    }
  }

  /**
   * Holds if an internal summary node is needed for the state `state` in summarized
   * callable `c`.
   */
  predicate internalNodeRange(SummarizedCallable c, SummaryInternalNodeState state) {
    state.isReadState(c, _, _, _)
    or
    state.isStoreState(c, _, _, _)
  }

  pragma[noinline]
  private Node internalNodeLastReadState(
    SummarizedCallable c, SummaryInput input, ContentList inputContents
  ) {
    exists(SummaryInternalNodeState state |
      state.isReadState(c, input, inputContents, inputContents.length()) and
      result = internalNode(c, state)
    )
  }

  pragma[noinline]
  private Node internalNodeFirstStoreState(
    SummarizedCallable c, SummaryOutput output, ContentList outputContents
  ) {
    exists(SummaryInternalNodeState state |
      state.isStoreState(c, output, outputContents, outputContents.length()) and
      result = internalNode(c, state)
    )
  }

  /**
   * Holds if there is a local step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate localStep(Node pred, Node succ, boolean preservesValue) {
    exists(
      SummarizedCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents
    |
      summary(c, input, inputContents, output, outputContents, preservesValue)
    |
      pred = inputNode(c, input) and
      (
        // Simple flow summary without reads or stores
        inputContents = ContentList::empty() and
        outputContents = ContentList::empty() and
        succ = outputNode(c, output)
        or
        // Flow summary with stores but no reads
        inputContents = ContentList::empty() and
        succ = internalNodeFirstStoreState(c, output, outputContents)
      )
      or
      pred = internalNodeLastReadState(c, input, inputContents) and
      (
        // Exit step after last read (no stores)
        outputContents = ContentList::empty() and
        succ = outputNode(c, output)
        or
        // Internal step for complex flow summaries with both reads and writes
        succ = internalNodeFirstStoreState(c, output, outputContents)
      )
    )
  }

  /**
   * Holds if there is a read step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate readStep(Node pred, Content c, Node succ) {
    exists(
      SummarizedCallable sc, SummaryInput input, ContentList inputContents,
      SummaryInternalNodeState succState, int i
    |
      succState.isReadState(sc, input, inputContents, i) and
      succ = internalNode(sc, succState) and
      c = getContent(inputContents, i - 1)
    |
      // First read
      i = 1 and
      pred = inputNode(sc, input)
      or
      // Subsequent reads
      exists(SummaryInternalNodeState predState |
        predState.isReadState(sc, input, inputContents, i - 1) and
        pred = internalNode(sc, predState)
      )
    )
  }

  /**
   * Holds if there is a store step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate storeStep(Node pred, Content c, Node succ) {
    exists(
      SummarizedCallable sc, SummaryOutput output, ContentList outputContents,
      SummaryInternalNodeState predState, int i
    |
      predState.isStoreState(sc, output, outputContents, i) and
      pred = internalNode(sc, predState) and
      c = getContent(outputContents, i - 1)
    |
      // More stores needed
      exists(SummaryInternalNodeState succState |
        succState.isStoreState(sc, output, outputContents, i - 1) and
        succ = internalNode(sc, succState)
      )
      or
      // Last store
      i = 1 and
      succ = outputNode(sc, output)
    )
  }

  pragma[nomagic]
  private ParameterNode summaryArgParam(ArgumentNode arg, ReturnKind rk, OutNode out) {
    exists(DataFlowCall call, int pos, SummarizedCallable callable |
      arg.argumentOf(call, pos) and
      viableCallable(call) = callable and
      result.isParameterOf(callable, pos) and
      call = out.getCall(rk)
    )
  }

  /**
   * Holds if `arg` flows to `out` using a simple flow summary, that is, a flow
   * summary without reads and stores.
   *
   * NOTE: This step should not be used in global data-flow/taint-tracking, but may
   * be useful to include in the exposed local data-flow/taint-tracking relations.
   */
  predicate throughStep(ArgumentNode arg, OutNode out, boolean preservesValue) {
    exists(ReturnKind rk, ReturnNode ret |
      localStep(summaryArgParam(arg, rk, out), ret, preservesValue) and
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
  predicate getterStep(ArgumentNode arg, Content c, OutNode out) {
    exists(ReturnKind rk, Node mid, ReturnNode ret |
      readStep(summaryArgParam(arg, rk, out), c, mid) and
      localStep(mid, ret, _) and
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
  predicate setterStep(ArgumentNode arg, Content c, OutNode out) {
    exists(ReturnKind rk, Node mid, ReturnNode ret |
      localStep(summaryArgParam(arg, rk, out), mid, _) and
      storeStep(mid, c, ret) and
      ret.getKind() = rk
    )
  }

  /**
   * Holds if values stored inside content `c` are cleared when passed as
   * input of type `input` in `call`.
   */
  predicate clearsContent(SummaryInput input, DataFlowCall call, Content c) {
    viableCallable(call).(SummarizedCallable).clearsContent(input, c)
  }
}
