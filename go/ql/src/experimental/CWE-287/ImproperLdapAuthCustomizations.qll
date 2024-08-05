import go
import semmle.go.dataflow.barrierguardutil.RegexpCheck

module ImproperLdapAuth {
  /**
   * A sink that is vulnerable to improper LDAP Authentication vulnerabilities.
   */
  abstract class LdapAuthSink extends DataFlow::Node { }

  /**
   * A sanitizer function that prevents improper LDAP Authentication attacks.
   */
  abstract class LdapSanitizer extends DataFlow::Node { }

  /**
   * A vulnerable argument to `go-ldap` or `ldap`'s `bind` function (Only v2).
   */
  private class GoLdapBindSink extends LdapAuthSink {
    GoLdapBindSink() {
      exists(Method meth |
        meth.hasQualifiedName("gopkg.in/ldap.v2", "Conn", "Bind") and
        this = meth.getACall().getArgument(1)
      )
    }
  }

  /**
   * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
   *
   * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
   */
  class RegexpCheckAsBarrierGuard extends RegexpCheckBarrier, LdapSanitizer { }

  /**
   * An empty string.
   */
  class EmptyString extends DataFlow::Node {
    EmptyString() { this.asExpr().getStringValue() = "" }
  }

  private predicate equalityAsSanitizerGuard(DataFlow::Node g, Expr e, boolean outcome) {
    exists(DataFlow::Node nonConstNode, DataFlow::Node constNode, DataFlow::EqualityTestNode eq |
      g = eq and
      nonConstNode = eq.getAnOperand() and
      not nonConstNode.isConst() and
      constNode = eq.getAnOperand() and
      constNode.isConst() and
      e = nonConstNode.asExpr() and
      (
        // If `constNode` is not an empty string a comparison is considered a sanitizer
        not constNode instanceof EmptyString and outcome = eq.getPolarity()
        or
        // If `constNode` is an empty string a not comparison is considered a sanitizer
        constNode instanceof EmptyString and outcome = eq.getPolarity().booleanNot()
      )
    )
  }

  /**
   * An equality check comparing a data-flow node against a constant string, considered as
   * a barrier guard for sanitizing untrusted user input.
   */
  class EqualityAsSanitizerGuard extends LdapSanitizer {
    EqualityAsSanitizerGuard() {
      this = DataFlow::BarrierGuard<equalityAsSanitizerGuard/3>::getABarrierNode()
    }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof ThreatModelFlowSource or source instanceof EmptyString
    }

    predicate isSink(DataFlow::Node sink) { sink instanceof LdapAuthSink }

    predicate isBarrier(DataFlow::Node node) { node instanceof LdapSanitizer }
  }

  /**
   * Tracks taint flow for reasoning about improper ldap auth vulnerabilities
   * with sinks which are not sanitized by string comparisons.
   */
  module Flow = TaintTracking::Global<Config>;
}
