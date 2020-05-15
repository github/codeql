/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * unvalidated URL redirection problems, as well as extension points
 * for adding your own.
 */

import go
import UrlConcatenation
import SafeUrlFlowCustomizations

/**
 * Provides extension points for customizing the taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the server side.
 */
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
   * A barrier for unvalidated URL redirect vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A barrier guard for unvalidated URL redirect vulnerabilities.
   */
  abstract class BarrierGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of third-party user input, considered as a flow source for URL redirects.
   */
  class UntrustedFlowAsSource extends Source, UntrustedFlowSource {
    UntrustedFlowAsSource() {
      // exclude some fields and methods of URLs that are generally not attacker-controllable for
      // open redirect exploits
      not exists(Field f, string fieldName |
        f.hasQualifiedName("net/http", "Request", fieldName) and
        this = f.getARead()
      |
        fieldName = "Body" or
        fieldName = "GetBody" or
        fieldName = "PostForm" or
        fieldName = "MultipartForm" or
        fieldName = "Header" or
        fieldName = "Trailer"
      ) and
      not exists(Method m, string methName |
        m.hasQualifiedName("net/http", "Request", methName) and
        this = m.getACall()
      |
        methName = "Cookie" or
        methName = "Cookies" or
        methName = "FormValue" or
        methName = "MultipartReader" or
        methName = "PostFormValues" or
        methName = "Referer" or
        methName = "UserAgent"
      )
    }
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
      e = url.asExpr() and outcome = this.getPolarity()
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

/** A sink for an open redirect, considered as a sink for safe URL flow. */
private class SafeUrlSink extends SafeUrlFlow::Sink {
  SafeUrlSink() { this instanceof OpenUrlRedirect::Sink }
}

/**
 * A read of a field considered unsafe to redirect to, considered as a sanitizer for a safe
 * URL.
 */
private class UnsafeFieldReadSanitizer extends SafeUrlFlow::SanitizerEdge {
  UnsafeFieldReadSanitizer() {
    exists(DataFlow::FieldReadNode frn, string name |
      (name = "User" or name = "RawQuery" or name = "Fragment" or name = "User") and
      frn.getField().hasQualifiedName("net/url", "URL")
    |
      this = frn.getBase()
    )
  }
}
