/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * unvalidated URL redirection problems, as well as extension points
 * for adding your own.
 */

import go
import UrlConcatenation
import SafeUrlFlowCustomizations
import semmle.go.dataflow.barrierguardutil.RedirectCheckBarrierGuard
import semmle.go.dataflow.barrierguardutil.RegexpCheck
import semmle.go.dataflow.barrierguardutil.UrlCheck

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
   * An additional taint propagation step specific to this query.
   */
  bindingset[this]
  abstract class AdditionalStep extends string {
    /**
     * Holds if `pred` to `succ` is an additional taint-propagating step for this query.
     */
    abstract predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /**
   * A source of third-party user input, considered as a flow source for URL redirects.
   */
  private class ThreatModelFlowAsSource extends Source instanceof ActiveThreatModelSource {
    ThreatModelFlowAsSource() {
      // exclude some fields and methods of URLs that are generally not attacker-controllable for
      // open redirect exploits
      not this instanceof Http::Redirect::UnexploitableSource
    }
  }

  /**
   * An HTTP redirect, considered as a sink for `Configuration`.
   */
  class RedirectSink extends Sink, DataFlow::Node {
    RedirectSink() { this = any(Http::Redirect redir).getUrl() }
  }

  /**
   * A definition of the HTTP "Location" header, considered as a sink for
   * `Configuration`.
   */
  class LocationHeaderSink extends Sink, DataFlow::Node {
    LocationHeaderSink() {
      exists(Http::HeaderWrite hw | hw.getHeaderName() = "location" | this = hw.getValue())
    }
  }

  bindingset[var, w]
  pragma[inline_late]
  private predicate useIsDominated(SsaWithFields var, Write w, DataFlow::ReadNode sanitizedRead) {
    w.dominatesNode(sanitizedRead.asInstruction()) and
    sanitizedRead = var.getAUse()
  }

  /**
   * An access to a variable that is preceded by an assignment to its `Path` field.
   *
   * This is overapproximate; this will currently remove flow through all `Url.Path` assignments
   * which contain a substring that could sanitize data.
   */
  class PathAssignmentBarrier extends Barrier, Read {
    PathAssignmentBarrier() {
      exists(Write w, SsaWithFields var |
        hasHostnameSanitizingSubstring(w.getRhs()) and
        w.writesField(var.getAUse(), any(Field f | f.getName() = "Path"), _) and
        useIsDominated(var, w, this)
      )
    }
  }

  /**
   * A call to a function called `isLocalUrl`, `isValidRedirect`, or similar, which is
   * considered a barrier guard for sanitizing untrusted URLs.
   */
  class RedirectCheckBarrierGuardAsBarrierGuard extends RedirectCheckBarrier, Barrier { }

  /**
   * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
   *
   * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
   */
  class RegexpCheckAsBarrierGuard extends RegexpCheckBarrier, Barrier { }

  /**
   * A check against a constant value or the `Hostname` function,
   * considered a barrier guard for url flow.
   */
  class UrlCheckAsBarrierGuard extends UrlCheckBarrier, Barrier { }
}

/** A sink for an open redirect, considered as a sink for safe URL flow. */
private class SafeUrlSink extends SafeUrlFlow::Sink instanceof OpenUrlRedirect::Sink { }

/**
 * A read of a field considered unsafe to redirect to, considered as a sanitizer for a safe
 * URL.
 */
private class UnsafeFieldReadSanitizer extends SafeUrlFlow::SanitizerEdge {
  UnsafeFieldReadSanitizer() {
    exists(DataFlow::FieldReadNode frn, string name |
      name = ["User", "RawQuery", "Fragment"] and
      frn.getField().hasQualifiedName("net/url", "URL")
    |
      this = frn.getBase()
    )
  }
}

/**
 * Reinstate the usual field propagation rules for fields, which the OpenURLRedirect
 * query usually excludes, for fields of `Params` other than `Params.Fixed`.
 */
private class PropagateParamsFields extends OpenUrlRedirect::AdditionalStep {
  PropagateParamsFields() { this = "PropagateParamsFields" }

  override predicate hasTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Field f, string field |
      f.hasQualifiedName(Revel::packagePath(), "Params", field) and
      field != "Fixed"
    |
      succ.(Read).readsField(pred, f)
    )
  }
}
