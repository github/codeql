/** Provides dataflow configurations to reason about insecure LDAP authentication. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Jndi
import semmle.code.java.security.InsecureLdapAuth

/**
 * A taint-tracking configuration for `ldap://` URL in LDAP authentication.
 */
module InsecureLdapUrlConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof InsecureLdapUrl }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureLdapUrlSink }

  /** Method call of `env.put()`. */
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall ma |
      pred.asExpr() = ma.getArgument(1) and
      isProviderUrlSetter(ma) and
      succ.asExpr() = ma.getQualifier()
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module InsecureLdapUrlFlow = TaintTracking::Global<InsecureLdapUrlConfig>;

/**
 * A taint-tracking configuration for `simple` basic-authentication in LDAP configuration.
 */
private module BasicAuthConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodCall ma |
      isBasicAuthEnv(ma) and
      ma.getQualifier() = src.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureLdapUrlSink }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 5 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-522/InsecureLdapAuth.ql@23:79:23:94)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 5 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-522/InsecureLdapAuth.ql@23:79:23:94)
  }
}

module BasicAuthFlow = DataFlow::Global<BasicAuthConfig>;

/**
 * A taint-tracking configuration for `ssl` configuration in LDAP authentication.
 */
private module RequiresSslConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodCall ma |
      isSslEnv(ma) and
      ma.getQualifier() = src.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureLdapUrlSink }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 5 does not select a source or sink originating from the flow call on line 22 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-522/InsecureLdapAuth.ql@23:79:23:94)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 5 does not select a source or sink originating from the flow call on line 22 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-522/InsecureLdapAuth.ql@23:79:23:94)
  }
}

module RequiresSslFlow = DataFlow::Global<RequiresSslConfig>;
