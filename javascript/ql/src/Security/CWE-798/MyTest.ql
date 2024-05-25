/**
 * @name test
 * @description test
 * @kind path-problem
 * @precision medium
 * @problem.severity error
 * @security-severity 5
 * @id js/test
 * @tags security
 *       experimental
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class Source extends DataFlow::Node {
  Source() { exists(StringLiteral name | name.toString() = "'secret'" | this.asExpr() = name) }
}

class MyTestConfig extends TaintTracking::Configuration {
  MyTestConfig() { this = "TestConfig" }

  override predicate isSource(DataFlow::Node source) {
    // source instanceof Source
    source.getFile().getBaseName() != "[context]userTokenVerify.js"
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(1).asSink() and
    sink.getFile().getBaseName() = "[context]userTokenVerify.js"
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MyTestConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@", source.getNode(),
  source.getNode().getFile().getBaseName()
