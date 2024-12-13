/**
 * Provides a flow state for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */

import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * Provides a flow state for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */
module TaintedUrlSuffix {
  private import DataFlow
  import CommonFlowState

  /**
   * The flow label representing a URL with a tainted query and fragment part.
   *
   * Can also be accessed using `TaintedUrlSuffix::label()`.
   */
  abstract deprecated class TaintedUrlSuffixLabel extends FlowLabel {
    TaintedUrlSuffixLabel() { this = "tainted-url-suffix" }
  }

  /**
   * Gets the flow label representing a URL with a tainted query and fragment part.
   */
  deprecated FlowLabel label() { result instanceof TaintedUrlSuffixLabel }

  /** Gets a remote flow source that is a tainted URL query or fragment part from `window.location`. */
  ClientSideRemoteFlowSource source() {
    result = DOM::locationRef().getAPropertyRead(["search", "hash"])
    or
    result = DOM::locationSource()
    or
    result.getKind().isUrl()
  }

  /**
   * DEPRECATED. Use `isStateBarrier(node, state)` instead.
   *
   * Holds if `node` should be a barrier for the given `label`.
   *
   * This should be used in the `isBarrier` predicate of a configuration that uses the tainted-url-suffix
   * label.
   */
  deprecated predicate isBarrier(Node node, FlowLabel label) {
    isStateBarrier(node, FlowState::fromFlowLabel(label))
  }

  /**
   * Holds if `node` should be blocked in `state`.
   */
  predicate isStateBarrier(Node node, FlowState state) {
    DataFlowPrivate::optionalBarrier(node, "split-url-suffix") and
    state.isTaintedUrlSuffix()
  }

  /**
   * DEPRECATED. Use `isAdditionalFlowStep` instead.
   */
  deprecated predicate step(Node src, Node dst, FlowLabel srclbl, FlowLabel dstlbl) {
    isAdditionalFlowStep(src, FlowState::fromFlowLabel(srclbl), dst,
      FlowState::fromFlowLabel(dstlbl))
  }

  /**
   * Holds if there is a flow step `node1 -> node2` involving the URL suffix flow state.
   *
   * This handles steps through string operations, promises, URL parsers, and URL accessors.
   */
  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    // Transition from tainted-url-suffix to general taint when entering the second array element
    // of a split('#') or split('?') array.
    //
    //   x [tainted-url-suffix] --> x.split('#') [array element 1] [taint]
    //
    // Technically we should also preverse tainted-url-suffix when entering the first array element of such
    // a split, but this mostly leads to FPs since we currently don't track if the taint has been through URI-decoding.
    // (The query/fragment parts are often URI-decoded in practice, but not the other URL parts are not)
    state1.isTaintedUrlSuffix() and
    state2.isTaint() and
    DataFlowPrivate::optionalStep(node1, "split-url-suffix-post", node2)
    or
    // Transition from URL suffix to full taint when extracting the query/fragment part.
    state1.isTaintedUrlSuffix() and
    state2.isTaint() and
    (
      exists(MethodCallNode call, string name |
        node1 = call.getReceiver() and
        node2 = call and
        name = call.getMethodName()
      |
        // Substring that is not a prefix
        name = StringOps::substringMethodName() and
        not call.getArgument(0).getIntValue() = 0
        or
        // Replace '#' and '?' with nothing
        name = "replace" and
        call.getArgument(0).getStringValue() = ["#", "?"] and
        call.getArgument(1).getStringValue() = ""
        or
        // The `get` call in `url.searchParams.get(x)` and `url.hashParams.get(x)`
        // The step should be safe since nothing else reachable by this flow label supports a method named 'get'.
        name = "get"
        or
        // Methods on URL objects from the Closure library
        name = "getDecodedQuery"
        or
        name = "getFragment"
        or
        name = "getParameterValue"
        or
        name = "getParameterValues"
        or
        name = "getQueryData"
      )
      or
      exists(PropRead read |
        node1 = read.getBase() and
        node2 = read and
        // Unlike the `search` property, the `query` property from `url.parse` does not include the `?`.
        read.getPropertyName() = "query"
      )
      or
      exists(MethodCallNode call, DataFlow::RegExpCreationNode re |
        (
          call = re.getAMethodCall("exec") and
          node1 = call.getArgument(0) and
          node2 = call
          or
          call.getMethodName() = ["match", "matchAll"] and
          re.flowsTo(call.getArgument(0)) and
          node1 = call.getReceiver() and
          node2 = call
        )
      |
        captureAfterSuffixIndicator(re.getRoot().getAChild*())
        or
        // If the regexp is unknown, assume it will extract the URL suffix
        not exists(re.getRoot())
      )
    )
  }

  /** Holds if the `n`th child of `seq` contains a character indicating that everything thereafter is part of the suffix */
  private predicate containsSuffixIndicator(RegExpSequence seq, int n) {
    // Also include '=' as it usually only appears in the URL suffix
    seq.getChild(n).getAChild*().(RegExpConstant).getValue().regexpMatch(".*[?#=].*")
  }

  /** Holds if the `n`th child of `seq` contains a capture group. */
  private predicate containsCaptureGroup(RegExpSequence seq, int n) {
    seq.getChild(n).getAChild*().(RegExpGroup).isCapture()
  }

  /**
   * Holds if `seq` contains a capture group that will likely match path of the URL suffix,
   * thereby extracting tainted data.
   *
   * For example, `/#(.*)/.exec(url)` will extract the tainted URL suffix from `url`.
   */
  private predicate captureAfterSuffixIndicator(RegExpSequence seq) {
    exists(int suffix, int capture |
      containsSuffixIndicator(seq, suffix) and
      containsCaptureGroup(seq, capture) and
      suffix < capture
    )
  }
}
