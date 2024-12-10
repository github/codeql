/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the server side.
 *
 * Note, for performance reasons: only import this file if
 * `OpenUrlRedirect::Configuration` is needed, otherwise
 * `OpenUrlRedirectCustomizations` should be imported instead.
 */

import go
import UrlConcatenation

/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated URL redirection problems on the server side.
 */
module OpenUrlRedirect {
  import OpenUrlRedirectCustomizations::OpenUrlRedirect

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      // taint steps that do not include flow through fields
      TaintTracking::defaultAdditionalTaintStep(pred, succ, _) and
      not TaintTracking::fieldReadStep(pred, succ)
      or
      // explicit extra taint steps for this query
      any(AdditionalStep s).hasTaintStep(pred, succ)
      or
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(v.getAUse(), f, pred) and succ = v.getAUse()
      )
      or
      // propagate out of most URL fields, but not `ForceQuery` and `Scheme`
      exists(Field f, string fn |
        f.hasQualifiedName("net/url", "URL", fn) and
        not fn in ["ForceQuery", "Scheme"]
      |
        succ.(Read).readsField(pred, f)
      )
    }

    predicate isBarrierOut(DataFlow::Node node) {
      // block propagation of this unsafe value when its host is overwritten
      exists(Write w, Field f | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(node.getASuccessor(), f, _)
      )
      or
      hostnameSanitizingPrefixEdge(node, _)
    }
  }

  /** Tracks taint flow from unvalidated, untrusted data to URL redirections. */
  module Flow = DataFlow::Global<Config>;
}
