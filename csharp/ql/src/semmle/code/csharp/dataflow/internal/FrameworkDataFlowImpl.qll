/**
 * Provides classes and predicates for definining data-flow through frameworks.
 *
 * The definitions in this file are language-independant, and language-specific
 * definitions are passed in via the `FrameworkDataFlowSpecific::Public` module.
 */

private import DataFlowPrivate
private import DataFlowPublic
import FrameworkDataFlowSpecific::Public

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

  /** Holds if `n` is a flow source of type `source. */
  pragma[nomagic]
  predicate hasSource(Node n, FlowSource source) { none() }

  /** Holds if `n` is a flow sink of type `sink. */
  pragma[nomagic]
  predicate hasSink(Node n, FlowSink sink) { none() }
}
