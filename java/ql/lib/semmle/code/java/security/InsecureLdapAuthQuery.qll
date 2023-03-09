/** Provides dataflow configurations to reason about insecure LDAP authentication. */

import java
import DataFlow
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.InsecureLdapAuth

/**
 * A taint-tracking configuration for `ldap://` URL in LDAP authentication.
 */
class InsecureUrlFlowConfig extends TaintTracking::Configuration {
  InsecureUrlFlowConfig() { this = "InsecureLdapAuth:InsecureUrlFlowConfig" }

  /** Source of `ldap://` connection string. */
  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof InsecureLdapUrl }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }

  /** Method call of `env.put()`. */
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      pred.asExpr() = ma.getArgument(1) and
      isProviderUrlSetter(ma) and
      succ.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * A taint-tracking configuration for `simple` basic-authentication in LDAP configuration.
 */
class BasicAuthFlowConfig extends DataFlow::Configuration {
  BasicAuthFlowConfig() { this = "InsecureLdapAuth:BasicAuthFlowConfig" }

  /** Source of `simple` configuration. */
  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isBasicAuthEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}

/**
 * A taint-tracking configuration for `ssl` configuration in LDAP authentication.
 */
class SslFlowConfig extends DataFlow::Configuration {
  SslFlowConfig() { this = "InsecureLdapAuth:SSLFlowConfig" }

  /** Source of `ssl` configuration. */
  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma |
      isSslEnv(ma) and ma.getQualifier() = src.(PostUpdateNode).getPreUpdateNode().asExpr()
    )
  }

  /** Sink of directory context creation. */
  override predicate isSink(DataFlow::Node sink) {
    exists(ConstructorCall cc |
      cc.getConstructedType().getAnAncestor() instanceof TypeDirContext and
      sink.asExpr() = cc.getArgument(0)
    )
  }
}
