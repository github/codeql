/**
 * Provides classes to detect using a hard-coded credential in a sensitive call.
 */

import java
import semmle.code.java.dataflow.DataFlow
import HardcodedCredentials

/**
 * A data-flow configuration that tracks hardcoded expressions flowing to a parameter whose name suggests
 * it may be a credential, excluding those which flow on to other such insecure usage sites.
 */
module HardcodedCredentialSourceCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof HardcodedExpr }

  predicate isSink(DataFlow::Node n) { n.asExpr() instanceof FinalCredentialsSourceSink }
}

/**
 * Tracks hardcoded expressions flowing to a parameter whose name suggests
 * it may be a credential, excluding those which flow on to other such insecure usage sites.
 */
module HardcodedCredentialSourceCallFlow = DataFlow::Global<HardcodedCredentialSourceCallConfig>;

/**
 * A data-flow configuration that tracks flow from an argument whose corresponding parameter name suggests
 * a credential, to an argument to a sensitive call.
 */
module HardcodedCredentialParameterSourceCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof CredentialsSourceSink }

  predicate isSink(DataFlow::Node n) { n.asExpr() instanceof CredentialsSink }
}

/**
 * Tracks flow from an argument whose corresponding parameter name suggests
 * a credential, to an argument to a sensitive call.
 */
module HardcodedCredentialParameterSourceCallFlow =
  DataFlow::Global<HardcodedCredentialParameterSourceCallConfig>;

/**
 * An argument to a call, where the parameter name corresponding
 * to the argument indicates that it may contain credentials, and
 * where this expression does not flow on to another `CredentialsSink`.
 */
class FinalCredentialsSourceSink extends CredentialsSourceSink {
  FinalCredentialsSourceSink() {
    not exists(CredentialsSink other | this != other |
      HardcodedCredentialParameterSourceCallFlow::flow(DataFlow::exprNode(this),
        DataFlow::exprNode(other))
    )
  }
}
