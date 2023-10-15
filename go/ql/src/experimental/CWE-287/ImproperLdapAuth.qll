import go
import DataFlow::PathGraph
import semmle.go.dataflow.barrierguardutil.RegexpCheck

/**
 * A LDAP connection node.
 */
abstract class LdapConn extends DataFlow::CallNode { }

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

private predicate equalityAsSanitizerGuard(DataFlow::Node g, Expr e, boolean outcome) {
  exists(DataFlow::Node passwd, DataFlow::EqualityTestNode eq |
    g = eq and
    passwd = eq.getAnOperand() and
    e = passwd.asExpr() and
    (
      eq.getAnOperand().getStringValue().length() > 0 and outcome = eq.getPolarity()
      or
      eq.getAnOperand().getStringValue().length() = 0 and
      outcome = eq.getPolarity().booleanNot()
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

/**
 */
class EmptyString extends DataFlow::Node {
  EmptyString() { this.asExpr().getStringValue() = "" }
}

/**
 * A taint-tracking configuration for reasoning about when an `UntrustedFlowSource`
 * flows into an argument or field that is vulnerable to Improper LDAP Authentication.
 */
class ImproperLdapAuthConfiguration extends TaintTracking::Configuration {
  ImproperLdapAuthConfiguration() { this = "Improper LDAP Auth" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource or source instanceof EmptyString
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LdapAuthSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof LdapSanitizer }
}
