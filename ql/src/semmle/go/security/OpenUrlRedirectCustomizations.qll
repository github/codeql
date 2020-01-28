/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * unvalidated URL redirection problems, as well as extension points
 * for adding your own.
 */

import go
import UrlConcatenation

module OpenUrlRedirect {
  /**
   * A data flow source for unvalidated URL redirect vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unvalidated URL redirect vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow node that should not be considered a sink for unvalidated URL redirect
   * vulnerabilities.
   *
   * This takes precedence over `Sink`, and so can be used to remove sinks that are safe.
   */
  abstract class NotSink extends DataFlow::Node { }

  /**
   * A barrier for unvalidated URL redirect vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A barrier guard for unvalidated URL redirect vulnerabilities.
   */
  abstract class BarrierGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of third-party user input, considered as a flow source for URL redirects.
   *
   * Excludes the URL field, as it is handled more precisely in `UntrustedUrlField`.
   */
  class UntrustedFlowAsSource extends Source, UntrustedFlowSource { }

  class SafeUrlMethod extends TaintTracking::FunctionModel, Method {
    SafeUrlMethod() {
      this instanceof StringMethod
      or
      this instanceof URL::UrlGetter and
      exists(string m | this.hasQualifiedName("net/url", "URL", m) | m = "Hostname" or m = "Port")
    }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class SafeUrlConfiguration extends DataFlow2::Configuration {
    SafeUrlConfiguration() { this = "FullUrlFlow" }

    override predicate isSource(DataFlow::Node source) {
      exists(Type req | req.hasQualifiedName("net/http", "Request") |
        source.(DataFlow::FieldReadNode).getField() = req.getField("URL")
      )
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      TaintTracking::functionModelStep(any(SafeUrlMethod m), pred, succ)
      or
      exists(DataFlow::FieldReadNode frn | succ = frn |
        frn.getBase() = pred and frn.getFieldName() = "Host"
      )
    }
  }

  /**
   * A safe part of a request URL to redirect to. This includes values such as the hostname and port
   * which should not be considered as unsafe when redirected to.
   */
  class SafeUrl extends NotSink, DataFlow::Node {
    SafeUrl() { exists(SafeUrlConfiguration conf | conf.hasFlow(_, this)) }
  }

  /**
   * An HTTP redirect, considered as a sink for `Configuration`.
   */
  class RedirectSink extends Sink, DataFlow::Node {
    RedirectSink() { this = any(HTTP::Redirect redir).getUrl() }
  }

  /**
   * A definition of the HTTP "Location" header, considered as a sink for
   * `Configuration`.
   */
  class LocationHeaderSink extends Sink, DataFlow::Node {
    LocationHeaderSink() {
      exists(HTTP::HeaderWrite hw | hw.getHeaderName() = "location" | this = hw.getValue())
    }
  }

  /**
   * An access to a variable that is preceded by an assignment to its `Path` field.
   *
   * This is overapproximate; this will currently remove flow through all `Url.Path` assignments
   * which contain a substring that could sanitize data.
   */
  class PathAssignmentBarrier extends Barrier, Read {
    PathAssignmentBarrier() {
      exists(Write w, Field f, SsaWithFields var |
        f.getName() = "Path" and
        hasHostnameSanitizingSubstring(w.getRhs()) and
        this = var.getAUse()
      |
        w.writesField(var.getAUse(), f, _) and
        w.dominatesNode(insn)
      )
    }
  }

  /**
   * A call to a function called `isLocalUrl`, `isValidRedirect`, or similar, which is
   * considered a barrier for purposes of URL redirection.
   */
  class RedirectCheckBarrierGuard extends BarrierGuard, DataFlow::CallNode {
    RedirectCheckBarrierGuard() {
      this.getCalleeName().regexpMatch("(?i)(is_?)?(local_?url|valid_?redir(ect)?)")
    }

    override predicate checks(Expr e, boolean outcome) {
      // `isLocalUrl(e)` is a barrier for `e` if it evaluates to `true`
      getAnArgument().asExpr() = e and
      outcome = true
    }
  }

  /**
   * A check against a constant value, considered a barrier for redirection.
   */
  class EqualityTestGuard extends BarrierGuard, DataFlow::EqualityTestNode {
    DataFlow::Node url;

    EqualityTestGuard() {
      exists(this.getAnOperand().getStringValue()) and
      (
        url = this.getAnOperand()
        or
        exists(DataFlow::MethodCallNode mc | mc = this.getAnOperand() |
          mc.getTarget().getName() = "Hostname" and
          url = mc.getReceiver()
        )
      )
    }

    override predicate checks(Expr e, boolean outcome) {
      e = url.asExpr() and this.eq(outcome, _, _)
    }
  }

  /**
   * A call to a regexp match function, considered as a barrier guard for unvalidated URLs.
   *
   * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
   */
  class RegexpCheck extends BarrierGuard {
    RegexpMatchFunction matchfn;
    DataFlow::CallNode call;

    RegexpCheck() {
      matchfn.getACall() = call and
      this = matchfn.getResult().getNode(call).getASuccessor*()
    }

    override predicate checks(Expr e, boolean branch) {
      e = matchfn.getValue().getNode(call).asExpr() and
      (branch = false or branch = true)
    }
  }
}
