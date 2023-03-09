/** Provides dataflow configurations to reason about insecure LDAP authentication. */

import java
import DataFlow
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.InsecureLdapAuth

/**
 * A taint-tracking configuration for `ldap://` URL in LDAP authentication.
 */
private module InsecureUrlFlowConfig implements DataFlow::ConfigSig {
  /** Source of `ldap://` connection string. */
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof InsecureLdapUrl }

  /** Sink of directory context creation. */
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

module InsecureUrlFlowConfiguration = TaintTracking::Make<InsecureUrlFlowConfig>;

/**
 * A taint-tracking configuration for `simple` basic-authentication in LDAP configuration.
 */
private module BasicAuthFlowConfig implements DataFlow::ConfigSig {
  /** Source of `simple` configuration. */
  predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isBasicAuthEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

module BasicAuthFlowConfiguration = DataFlow::Make<BasicAuthFlowConfig>;

/**
 * A taint-tracking configuration for `ssl` configuration in LDAP authentication.
 */
private module SslFlowConfig implements DataFlow::ConfigSig {
  /** Source of `ssl` configuration. */
  predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isSslEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

module SslFlowConfiguration = DataFlow::Make<SslFlowConfig>;
