/**
 * @name Use of a broken or weak cryptographic hashing algorithm on sensitive data
 * @description Using broken or weak cryptographic hashing algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id py/weak-sensitive-data-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

class WeakHashingConfig extends TaintTracking::Configuration {
  WeakHashingConfig() { this = "WeakHashingConfig" }

  override predicate isSource(DataFlow::Node node) {
    exists(SensitiveExpr e |
      node.asExpr() = e and
      not e.isProbablySafe()
    )
  }

  override predicate isSink(DataFlow::Node node) { node instanceof WeakHashingConfig::Sink }
}

module WeakHashingConfig {
  class Sink extends DataFlow::Node {
    string algorithm;

    Sink() {
      exists(ApplyExpr call, FuncDecl func |
        call.getAnArgument().getExpr() = this.asExpr() and
        call.getStaticTarget() = func and
        func.getName().matches(["hash(%", "update(%"]) and
        algorithm = func.getEnclosingDecl().(StructDecl).getName() and
        algorithm = ["MD5", "SHA1"]
      )
    }

    string getAlgorithm() { result = algorithm }
  }
}

from WeakHashingConfig config, DataFlow::PathNode source, DataFlow::PathNode sink, string algorithm
where
  config.hasFlowPath(source, sink) and
  algorithm = sink.getNode().(WeakHashingConfig::Sink).getAlgorithm()
select sink.getNode(), source, sink,
  "Insecure hashing algorithm (" + algorithm + ") depends on $@.", source.getNode(),
  "sensitive data"
