/**
 * @name Hard-coded credential in API call
 * @description Using a hard-coded credential in a call to a sensitive Java API may compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id java/hardcoded-credential-api-call
 * @tags security
 *       external/cwe/cwe-798
 */

import java
import semmle.code.java.dataflow.DataFlow
import HardcodedCredentials
import DataFlow::PathGraph

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

from
  DataFlow::PathNode source, DataFlow::PathNode sink, HardcodedCredentialApiCallConfiguration conf
where conf.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Hard-coded value flows to $@.", sink.getNode(),
  "sensitive API call"
