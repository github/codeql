/**
 * Provides default sources, sinks and sanitizers for detecting
 * "URL redirection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.data.ModelsAsData

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "URL redirection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module UrlRedirect {
  /**
   * A state value to track whether the untrusted data may contain backslashes.
   */
  abstract class FlowState extends string {
    bindingset[this]
    FlowState() { any() }
  }

  /**
   * A state value signifying that the untrusted data may contain backslashes.
   */
  class MayContainBackslashes extends UrlRedirect::FlowState {
    MayContainBackslashes() { this = "MayContainBackslashes" }
  }

  /**
   * A state value signifying that any backslashes in the untrusted data have
   * been eliminated, but no other sanitization has happened.
   */
  class NoBackslashes extends UrlRedirect::FlowState {
    NoBackslashes() { this = "NoBackslashes" }
  }

  /**
   * A data flow source for "URL redirection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "URL redirection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "URL redirection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node {
    /**
     * Holds if this sanitizer sanitizes flow in the given state.
     */
    abstract predicate sanitizes(FlowState state);
  }

  /**
   * An additional flow step for "URL redirection" vulnerabilities.
   */
  abstract class AdditionalFlowStep extends DataFlow::Node {
    /**
     * Holds if there should be an additional flow step from `nodeFrom` in `stateFrom`
     * to `nodeTo` in `stateTo`.
     *
     * For example, a call to `replace` that replaces backslashes with forward slashes
     * takes flow from `MayContainBackslashes` to `NoBackslashes`.
     */
    abstract predicate step(
      DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
    );
  }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A HTTP redirect response, considered as a flow sink.
   */
  class RedirectLocationAsSink extends Sink {
    RedirectLocationAsSink() {
      this = any(Http::Server::HttpRedirectResponse e).getRedirectLocation()
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("url-redirection").asSink() }
  }

  /**
   * The right side of a string-concat, considered as a sanitizer.
   */
  class StringConcatAsSanitizer extends Sanitizer {
    StringConcatAsSanitizer() {
      // Url redirection is a problem only if the user controls the prefix of the URL.
      // TODO: This is a copy of the taint-sanitizer from the old points-to query, which doesn't
      // cover formatting.
      exists(BinaryExprNode string_concat | string_concat.getOp() instanceof Add |
        string_concat.getRight() = this.asCfgNode()
      )
    }

    override predicate sanitizes(FlowState state) {
      // sanitize all flow states
      any()
    }
  }

  /**
   * A call that replaces backslashes with forward slashes or eliminates them
   * altogether, considered as a partial sanitizer, as well as an additional
   * flow step.
   */
  class ReplaceBackslashesSanitizer extends Sanitizer, AdditionalFlowStep, DataFlow::MethodCallNode {
    DataFlow::Node receiver;

    ReplaceBackslashesSanitizer() {
      this.calls(receiver, "replace") and
      this.getArg(0).asExpr().(StringLiteral).getText() = "\\" and
      this.getArg(1).asExpr().(StringLiteral).getText() in ["/", ""]
    }

    override predicate sanitizes(FlowState state) { state instanceof MayContainBackslashes }

    override predicate step(
      DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
    ) {
      nodeFrom = receiver and
      stateFrom instanceof MayContainBackslashes and
      nodeTo = this and
      stateTo instanceof NoBackslashes
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier {
    override predicate sanitizes(FlowState state) {
      // sanitize all flow states
      any()
    }
  }
}
