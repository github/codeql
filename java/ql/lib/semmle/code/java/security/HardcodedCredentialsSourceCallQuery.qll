/**
 * Provides classes to detect using a hard-coded credential in a sensitive call.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import HardcodedCredentials

/**
 * A data-flow configuration that tracks hardcoded expressions flowing to a parameter whose name suggests
 * it may be a credential, excluding those which flow on to other such insecure usage sites.
 */
class HardcodedCredentialSourceCallConfiguration extends DataFlow::Configuration {
  HardcodedCredentialSourceCallConfiguration() {
    this = "HardcodedCredentialSourceCallConfiguration"
  }

  override predicate isSource(DataFlow::Node n) { n.asExpr() instanceof HardcodedExpr }

  override predicate isSink(DataFlow::Node n) { n.asExpr() instanceof FinalCredentialsSourceSink }
}

/**
 * A data-flow configuration that tracks flow from an argument whose corresponding parameter name suggests
 * a credential, to an argument to a sensitive call.
 */
class HardcodedCredentialSourceCallConfiguration2 extends DataFlow2::Configuration {
  HardcodedCredentialSourceCallConfiguration2() {
    this = "HardcodedCredentialSourceCallConfiguration2"
  }

  override predicate isSource(DataFlow::Node n) { n.asExpr() instanceof CredentialsSourceSink }

  override predicate isSink(DataFlow::Node n) { n.asExpr() instanceof CredentialsSink }
}

/**
 * An argument to a call, where the parameter name corresponding
 * to the argument indicates that it may contain credentials, and
 * where this expression does not flow on to another `CredentialsSink`.
 */
class FinalCredentialsSourceSink extends CredentialsSourceSink {
  FinalCredentialsSourceSink() {
    not exists(HardcodedCredentialSourceCallConfiguration2 conf, CredentialsSink other |
      this != other
    |
      conf.hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(other))
    )
  }
}
