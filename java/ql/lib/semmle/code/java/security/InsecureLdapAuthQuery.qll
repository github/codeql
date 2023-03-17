/** Provides dataflow configurations to reason about insecure LDAP authentication. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Jndi
import semmle.code.java.security.InsecureLdapAuth

/**
 * A taint-tracking configuration for `ldap://` URL in LDAP authentication.
 */
private module InsecureLdapUrlConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof InsecureLdapUrl }

  predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }

  /** Method call of `env.put()`. */
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      pred.asExpr() = ma.getArgument(1) and
      isProviderUrlSetter(ma) and
      succ.asExpr() = ma.getQualifier()
    )
  }
}

module InsecureLdapUrlFlow = TaintTracking::Make<InsecureLdapUrlConfig>;

/**
 * A taint-tracking configuration for `simple` basic-authentication in LDAP configuration.
 */
private module BasicAuthConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isBasicAuthEnv(ma) and ma.getQualifier() = src.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

module BasicAuthFlow = DataFlow::Make<BasicAuthConfig>;

/**
 * A taint-tracking configuration for `ssl` configuration in LDAP authentication.
 */
private module RequiresSslConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isSslEnv(ma) and ma.getQualifier() = src.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

module RequiresSslFlow = DataFlow::Make<RequiresSslConfig>;
