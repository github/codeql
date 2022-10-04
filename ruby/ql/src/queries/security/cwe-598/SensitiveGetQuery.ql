/**
 * @name Sensitive data read from GET request
 * @description Placing sensitive data in a GET request increases the risk of
 *              the data being exposed to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id rb/sensitive-get-query
 * @tags security
 *       external/cwe/cwe-598
 */

import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.security.SensitiveActions
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.core.Array

class Source extends Http::Server::RequestInputAccess {
  private Http::Server::RequestHandler handler;

  Source() {
    handler = this.asExpr().getExpr().getEnclosingMethod() and
    handler.getAnHttpMethod() = "get"
  }

  Http::Server::RequestHandler getHandler() { result = handler }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SensitiveGetQuery" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SensitiveNode }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Configuration config
where
  config.hasFlowPath(source, sink) and
  not sink.getNode().(SensitiveNode).getClassification() = SensitiveDataClassification::id()
select source.getNode(), source, sink,
  "$@ for GET requests uses query parameter as sensitive data.",
  source.getNode().(Source).getHandler(), "Route handler"
