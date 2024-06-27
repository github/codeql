/**
 * Provides default sources, sinks and sanitizers for detecting "URL
 * redirection" vulnerabilities, as well as extension points for adding your
 * own.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.Sanitizers
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.data.internal.ApiGraphModels

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "URL redirection" vulnerabilities, as well as extension points for
 * adding your own.
 */
module UrlRedirect {
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
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Additional taint steps for "URL redirection" vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    taintStepViaMethodCallReturnValue(node1, node2)
  }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class HttpRequestInputAccessAsSource extends Source, Http::Server::RequestInputAccess {
    HttpRequestInputAccessAsSource() { this.isThirdPartyControllable() }
  }

  /**
   * A HTTP redirect response, considered as a flow sink.
   */
  class RedirectLocationAsSink extends Sink {
    RedirectLocationAsSink() {
      exists(Http::Server::HttpRedirectResponse e, MethodBase method |
        this = e.getRedirectLocation() and
        // We only want handlers for GET requests.
        // Handlers for other HTTP methods are not as vulnerable to URL
        // redirection as browsers will not initiate them from clicking a link.
        method = this.asExpr().getExpr().getEnclosingMethod() and
        (
          // If there's a Rails GET route to this handler, we can be certain that it is a candidate.
          method.(ActionControllerActionMethod).getARoute().getHttpMethod() = "get"
          or
          // Otherwise, we have to rely on a heuristic to filter out invulnerable handlers.
          // We exclude any handlers with names containing create/update/destroy, as these are not likely to handle GET requests.
          not exists(method.(ActionControllerActionMethod).getARoute()) and
          not method.getName().regexpMatch(".*(create|update|destroy).*")
        ) and
        // If this redirect is an ActionController method call, it is only vulnerable if it allows external redirects.
        forall(RedirectToCall c | c = e.asExpr().getExpr() | c.allowsExternalRedirect())
      )
    }
  }

  private class ExternalUrlRedirectSink extends Sink {
    ExternalUrlRedirectSink() { this = ModelOutput::getASinkNode("url-redirection").asSink() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizer extends Sanitizer, StringConstCompareBarrier { }

  /**
   * A string concatenation against a constant list, considered as a sanitizer-guard.
   */
  class StringConstArrayInclusionAsSanitizer extends Sanitizer, StringConstArrayInclusionCallBarrier
  { }

  /**
   * Some methods will propagate taint to their return values.
   * Here we cover a few common ones related to `ActionController::Parameters`.
   * TODO: use ApiGraphs or something to restrict these method calls to the correct receiver, rather
   * than matching on method name alone.
   */
  predicate taintStepViaMethodCallReturnValue(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall m | m = node2.asExpr().getExpr() |
      m.getReceiver() = node1.asExpr().getExpr() and
      (actionControllerTaintedMethod(m) or hashTaintedMethod(m))
    )
  }

  /**
   * A string interpolation, seen as a sanitizer for "URL redirection" vulnerabilities.
   *
   * String interpolation is considered safe, provided the string is prefixed by a non-tainted value.
   * In most cases this will prevent the tainted value from controlling e.g. the host of the URL.
   *
   * For example:
   *
   * ```ruby
   * redirect_to "/users/#{params[:key]}" # safe
   * redirect_to "#{params[:key]}/users"  # unsafe
   * ```
   *
   * There are prefixed interpolations that are not safe, e.g.
   *
   * ```ruby
   * redirect_to "foo#{params[:key]}/users" # => "foo-malicious-site.com/users"
   * ```
   *
   * We currently don't catch these cases.
   */
  class StringInterpolationAsSanitizer extends PrefixedStringInterpolation, Sanitizer { }

  /**
   * These methods return a new `ActionController::Parameters` or a `Hash` containing a subset of
   * the original values. This may still contain user input, so the results are tainted.
   * TODO: flesh this out to cover the whole API.
   */
  predicate actionControllerTaintedMethod(MethodCall m) {
    m.getMethodName() in ["to_unsafe_hash", "to_unsafe_h", "permit", "require"]
  }

  /**
   * These `Hash` methods preserve taint because they return a new hash which may still contain keys
   * with user input.
   * TODO: flesh this out to cover the whole API.
   */
  predicate hashTaintedMethod(MethodCall m) { m.getMethodName() in ["merge", "fetch"] }
}
