/**
 * Provides classes and predicates for definining data-flow through frameworks.
 *
 * The definitions in this file are language-independant, and language-specific
 * definitions are passed in via the `FrameworkDataFlowSpecific::Public` module.
 */

import FrameworkDataFlowSpecific::Public
private import FrameworkDataFlowSpecific::Private

private newtype TContentList =
  TNilContentList() or
  TConsContentList(Content head, ContentList tail) {
    tail = TNilContentList()
    or
    exists(FrameworkDataFlow fdf |
      fdf.requiresContentList(head, tail) and
      tail.length() < accessPathLimit()
    )
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

private newtype TFlowSource = MkFlowSource(FlowSource::Range r)

/** A flow-source specification. */
class FlowSource extends MkFlowSource {
  private FlowSource::Range r;

  FlowSource() { this = MkFlowSource(r) }

  predicate isSubsetOf(FlowSource fs) { r.isSubsetOf(fs) }

  string toString() { result = r }
}

module FlowSource {
  abstract class Range extends string {
    bindingset[this]
    Range() { any() }

    predicate isSubsetOf(FlowSource fs) { none() }

    FlowSource toFlowSource() { result = MkFlowSource(this) }
  }
}

private newtype TFlowSink = MkFlowSink(FlowSink::Range r)

/** A flow-sink specification. */
class FlowSink extends MkFlowSink {
  private FlowSink::Range r;

  FlowSink() { this = MkFlowSink(r) }

  predicate isSubsetOf(FlowSink fs) { r.isSubsetOf(fs) }

  string toString() { result = r }
}

module FlowSink {
  abstract class Range extends string {
    bindingset[this]
    Range() { any() }

    predicate isSubsetOf(FlowSink fs) { none() }

    FlowSink toFlowSink() { result = MkFlowSink(this) }
  }
}

/** A data-flow model for a given framework. */
abstract class FrameworkDataFlow extends string {
  bindingset[this]
  FrameworkDataFlow() { any() }

  /**
   * Holds if data may flow from `input` to `output` when calling `c`.
   *
   * `preservesValue` indicates whether this is a value-preserving step
   * or a taint-step.
   */
  pragma[nomagic]
  predicate hasSummary(
    FrameworkCallable c, SummaryInput input, SummaryOutput output, boolean preservesValue
  ) {
    none()
  }

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
  predicate hasSummary(
    FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
    ContentList outputContents, boolean preservesValue
  ) {
    none()
  }

  /**
   * Holds if the content list obtained by consing `head` onto `tail` is needed
   * for a summary specified by `hasSummary()`.
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
   * arguments of type `input` to calls that target `c`.
   */
  pragma[nomagic]
  predicate clearsContent(FrameworkCallable c, SummaryInput input, Content content) { none() }

  /** Holds if output of type `output` from `c` is a flow source of type `source`. */
  pragma[nomagic]
  predicate hasSource(FrameworkCallable c, SummaryOutput output, FlowSource source) { none() }

  /** Holds if input of type `input` to `c` is a flow sink of type `sink`. */
  pragma[nomagic]
  predicate hasSink(FrameworkCallable c, SummaryInput input, FlowSink sink) { none() }
}

/**
 * Provides predicates for compiling flow summaries down to atomic local steps,
 * read steps, and store steps.
 */
module Compilation {
  private import DataFlowDispatch

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
    FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
    ContentList outputContents, boolean preservesValue
  ) {
    any(FrameworkDataFlow fdf).hasSummary(c, input, output, preservesValue) and
    inputContents = ContentList::empty() and
    outputContents = ContentList::empty()
    or
    any(FrameworkDataFlow fdf)
        .hasSummary(c, input, inputContents, output, outputContents, preservesValue)
  }

  private newtype TSummaryInternalNodeState =
    TSummaryInternalNodeAfterReadState(ContentList cl) { cl.length() > 0 } or
    TSummaryInternalNodeBeforeStoreState(ContentList cl) { cl.length() > 0 }

  /**
   * A state used to break up (complex) flow summaries into atomic flow steps.
   * For a flow summary with input contents `inputContents` and output contents
   * `outputContents`, the following states are used:
   *
   * - `TSummaryInternalNodeAfterReadState(ContentList cl)`: this state represents
   *   that the head of `cl` has been read from, where `cl` is a suffix of
   *   `inputContents`.
   * - `TSummaryInternalNodeBeforeStoreState(ContentList cl)`: this state represents
   *   that the head of `cl` is to be stored into next, where `cl` is a suffix of
   *   `outputContents`.
   *
   * The state machine for flow summaries has no branching, hence from the entry
   * state there is a unique path to the exit state.
   */
  class SummaryInternalNodeState extends TSummaryInternalNodeState {
    string toString() {
      exists(ContentList cl |
        this = TSummaryInternalNodeAfterReadState(cl) and
        result = "after read: " + cl
      )
      or
      exists(ContentList cl |
        this = TSummaryInternalNodeBeforeStoreState(cl) and
        result = "before store: " + cl
      )
    }

    /** Holds if this state represents the state after the last read. */
    predicate isLastReadState() {
      this = TSummaryInternalNodeAfterReadState(ContentList::singleton(_))
    }

    /** Holds if this state represents the state before the first store. */
    predicate isFirstStoreState() {
      this = TSummaryInternalNodeBeforeStoreState(ContentList::singleton(_))
    }
  }

  /** Holds if an internal summary node is needed for the given values. */
  predicate internalNodeRange(
    FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
    ContentList outputContents, boolean preservesValue, SummaryInternalNodeState state
  ) {
    summary(c, input, inputContents, output, outputContents, preservesValue) and
    (
      state = TSummaryInternalNodeAfterReadState(inputContents.drop(_))
      or
      state = TSummaryInternalNodeBeforeStoreState(outputContents.drop(_))
    )
  }

  /** Gets a type for an internal node with the given values. */
  bindingset[preservesValue]
  DataFlowType internalNodeType(
    FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
    ContentList outputContents, boolean preservesValue, SummaryInternalNodeState state
  ) {
    exists(ContentList cl |
      state = TSummaryInternalNodeAfterReadState(cl) and
      if outputContents.length() = 0 and state.isLastReadState() and preservesValue = true
      then result = getOutputNodeType(c, output)
      else result = getContentType(cl.head())
      or
      state = TSummaryInternalNodeBeforeStoreState(cl) and
      if inputContents.length() = 0 and state.isFirstStoreState() and preservesValue = true
      then result = getInputNodeType(c, input)
      else result = getContentType(cl.head())
    )
  }

  /**
   * Holds if there is a local step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate localStep(Node pred, Node succ, boolean preservesValue) {
    exists(
      FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput sink,
      ContentList outputContents
    |
      pred = inputNode(c, input)
    |
      // Simple flow summary without reads or stores
      inputContents = ContentList::empty() and
      outputContents = ContentList::empty() and
      summary(c, input, inputContents, sink, outputContents, preservesValue) and
      succ = outputNode(c, sink)
      or
      // Flow summary with stores but no reads
      exists(SummaryInternalNodeState succState |
        inputContents = ContentList::empty() and
        succState.isFirstStoreState() and
        succ =
          internalNode(c, input, inputContents, sink, outputContents, preservesValue, succState)
      )
    )
    or
    // Exit step after last read (no stores)
    exists(
      FrameworkCallable c, SummaryInternalNodeState predState, SummaryOutput output,
      ContentList outputContents
    |
      outputContents = ContentList::empty() and
      predState.isLastReadState() and
      pred = internalNode(c, _, _, output, outputContents, preservesValue, predState) and
      succ = outputNode(c, output)
    )
    or
    // Internal step for complex flow summaries with both reads and writes
    exists(
      FrameworkCallable c, SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, SummaryInternalNodeState predState,
      SummaryInternalNodeState succState
    |
      predState.isLastReadState() and
      pred =
        internalNode(c, input, inputContents, output, outputContents, preservesValue, predState) and
      succState.isFirstStoreState() and
      succ =
        internalNode(c, input, inputContents, output, outputContents, preservesValue, succState)
    )
  }

  /**
   * Holds if there is a read step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate readStep(Node pred, Content c, Node succ) {
    exists(
      FrameworkCallable sdc, SummaryInput source, ContentList inputContents, SummaryOutput sink,
      ContentList outputContents, boolean preservesValue, SummaryInternalNodeState succState,
      ContentList succContents
    |
      succState = TSummaryInternalNodeAfterReadState(succContents) and
      succ =
        internalNode(sdc, source, inputContents, sink, outputContents, preservesValue, succState) and
      c = succContents.head()
    |
      // First read
      succContents = inputContents and
      pred = inputNode(sdc, source)
      or
      // Subsequent reads
      exists(SummaryInternalNodeState predState, ContentList predContents |
        predState = TSummaryInternalNodeAfterReadState(predContents) and
        predContents.tail() = succContents and
        pred =
          internalNode(sdc, source, inputContents, sink, outputContents, preservesValue, predState)
      )
    )
  }

  /**
   * Holds if there is a store step from `pred` to `succ`, which is synthesized
   * from a flow summary.
   */
  predicate storeStep(Node pred, Content c, Node succ) {
    exists(
      FrameworkCallable sdc, SummaryInput source, ContentList inputContents, SummaryOutput sink,
      ContentList outputContents, boolean preservesValue, SummaryInternalNodeState predState,
      ContentList predContents
    |
      predState = TSummaryInternalNodeBeforeStoreState(predContents) and
      pred =
        internalNode(sdc, source, inputContents, sink, outputContents, preservesValue, predState) and
      c = predContents.head()
    |
      // More stores needed
      exists(SummaryInternalNodeState succState |
        succState =
          TSummaryInternalNodeBeforeStoreState(any(ContentList succContents |
              succContents.tail() = predContents
            )) and
        succ =
          internalNode(sdc, source, inputContents, sink, outputContents, preservesValue, succState)
      )
      or
      // Last store
      predContents = outputContents and
      succ = outputNode(sdc, sink)
    )
  }

  pragma[nomagic]
  private ParameterNode summaryArgParam(ArgumentNode arg, ReturnKind rk, OutNode out) {
    exists(DataFlowCall call, int pos, FrameworkCallable callable |
      arg.argumentOf(call, pos) and
      viableCallable(call) = callable and
      result.isParameterOf(callable, pos) and
      call = out.getCall(rk)
    )
  }

  /**
   * Holds if `arg` flows to `out` using a simple flow summary, that is, a flow
   * summary without reads and stores.
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
    any(FrameworkDataFlow fdf).clearsContent(viableCallable(call), input, c)
  }
}
