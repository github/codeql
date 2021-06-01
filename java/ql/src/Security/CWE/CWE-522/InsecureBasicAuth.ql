/**
 * @name Insecure basic authentication
 * @description Basic authentication only obfuscates username/password in
 *              Base64 encoding, which can be easily recognized and reversed.
 *              Transmission of sensitive information not over HTTPS is
 *              vulnerable to packet sniffing.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/insecure-basic-auth
 * @tags security
 *       external/cwe/cwe-522
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.InsecureBasicAuth
import DataFlow::PathGraph

class BasicAuthFlowConfig extends TaintTracking::Configuration {
  BasicAuthFlowConfig() { this = "InsecureBasicAuth::BasicAuthFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof InsecureBasicAuthSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureBasicAuthSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(InsecureBasicAuthAdditionalTaintStep c).step(node1, node2)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BasicAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from $@.", source.getNode(),
  "HTTP URL"
