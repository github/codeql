/**
 * Provides a data-flow configuration for tracking a hard-coded credential in a call to a sensitive Java API which may compromise security.
 */

import java
import semmle.code.java.dataflow.DataFlow
import HardcodedCredentials

/**
 * A data-flow configuration that tracks flow from a hard-coded credential in a call to a sensitive Java API which may compromise security.
 */
class HardcodedCredentialApiCallConfiguration extends DataFlow::Configuration {
  HardcodedCredentialApiCallConfiguration() { this = "HardcodedCredentialApiCallConfiguration" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr() instanceof HardcodedExpr and
    not n.asExpr().getEnclosingCallable() instanceof ToStringMethod
  }

  override predicate isSink(DataFlow::Node n) { n.asExpr() instanceof CredentialsApiSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.asExpr().getType() instanceof TypeString and
    (
      exists(MethodAccess ma | ma.getMethod().hasName(["getBytes", "toCharArray"]) |
        node2.asExpr() = ma and
        ma.getQualifier() = node1.asExpr()
      )
      or
      // These base64 routines are usually taint propagators, and this is not a general
      // TaintTracking::Configuration, so we must specifically include them here
      // as a common transform applied to a constant before passing to a remote API.
      exists(MethodAccess ma |
        ma.getMethod()
            .hasQualifiedName([
                "java.util", "cn.hutool.core.codec", "org.apache.shiro.codec",
                "apache.commons.codec.binary", "org.springframework.util"
              ], ["Base64$Encoder", "Base64$Decoder", "Base64", "Base64Utils"],
              [
                "encode", "encodeToString", "decode", "decodeBase64", "encodeBase64",
                "encodeBase64Chunked", "encodeBase64String", "encodeBase64URLSafe",
                "encodeBase64URLSafeString"
              ])
      |
        node1.asExpr() = ma.getArgument(0) and
        node2.asExpr() = ma
      )
    )
  }

  override predicate isBarrier(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod() instanceof MethodSystemGetenv
  }
}
