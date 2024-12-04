/**
 * Provides a flow label for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */

import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * Provides a flow label for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */
module TaintedUrlSuffix {
  private import DataFlow

  /**
   * The flow label representing a URL with a tainted query and fragment part.
   *
   * Can also be accessed using `TaintedUrlSuffix::label()`.
   */
  class TaintedUrlSuffixLabel extends FlowLabel {
    TaintedUrlSuffixLabel() { this = "tainted-url-suffix" }
  }

  /**
   * Gets the flow label representing a URL with a tainted query and fragment part.
   */
  FlowLabel label() { result instanceof TaintedUrlSuffixLabel }

  /** Gets a remote flow source that is a tainted URL query or fragment part from `window.location`. */
  ClientSideRemoteFlowSource source() {
    result = DOM::locationRef().getAPropertyRead(["search", "hash"])
    or
    result = DOM::locationSource()
    or
    result.getKind().isUrl()
  }

  /**
   * Holds if `node` should be a barrier for the given `label`.
   *
   * This should be used in the `isBarrier` predicate of a configuration that uses the tainted-url-suffix
   * label.
   */
  predicate isBarrier(Node node, FlowLabel label) {
    label = label() and
    DataFlowPrivate::optionalBarrier(node, "split-url-suffix")
  }

  /**
   * Holds if there is a flow step `src -> dst` involving the URL suffix taint label.
   *
   * This handles steps through string operations, promises, URL parsers, and URL accessors.
   */
  predicate step(Node src, Node dst, FlowLabel srclbl, FlowLabel dstlbl) {
    // Transition from tainted-url-suffix to general taint when entering the second array element
    // of a split('#') or split('?') array.
    //
    //   x [tainted-url-suffix] --> x.split('#') [array element 1] [taint]
    //
    // Technically we should also preverse tainted-url-suffix when entering the first array element of such
    // a split, but this mostly leads to FPs since we currently don't track if the taint has been through URI-decoding.
    // (The query/fragment parts are often URI-decoded in practice, but not the other URL parts are not)
    srclbl = label() and
    dstlbl.isTaint() and
    DataFlowPrivate::optionalStep(src, "split-url-suffix-post", dst)
    or
    // Transition from URL suffix to full taint when extracting the query/fragment part.
    srclbl = label() and
    dstlbl.isTaint() and
    (
      exists(MethodCallNode call, string name |
        src = call.getReceiver() and
        dst = call and
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
        src = read.getBase() and
        dst = read and
        // Unlike the `search` property, the `query` property from `url.parse` does not include the `?`.
        read.getPropertyName() = "query"
      )
      or
      // Assume calls to regexp.exec always extract query/fragment parameters.
      exists(MethodCallNode call |
        call = any(DataFlow::RegExpCreationNode re).getAMethodCall("exec") and
        src = call.getArgument(0) and
        dst = call
      )
    )
  }
}
