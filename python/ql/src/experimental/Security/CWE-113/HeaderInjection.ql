/**
 * @name HTTP Header Injection
 * @description User input should not be used in HTTP headers without first being escaped,
 *              otherwise a malicious user may be able to inject a value that could manipulate the response.
 * @kind path-problem
 * @problem.severity error
 * @id python/header-injection
 * @tags security
 *       external/cwe/cwe-113
 *       external/cwe/cwe-079
 */

// determine precision above
import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import DataFlow::PathGraph
import semmle.python.frameworks.Flask

class WerkzeugHeader extends DataFlow::Node {
  WerkzeugHeader() {
    exists(DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead addMethod |
      headerInstance =
        API::moduleImport("werkzeug").getMember("datastructures").getMember("Headers").getACall() and
      addMethod.getAttributeName() = "add" and
      addMethod.getObject().getALocalSource() = headerInstance and
      this = addMethod.(DataFlow::CallCfgNode).getArg(1)
    )
  }
}

class FlaskHeader extends DataFlow::Node {
  FlaskHeader() {
    exists(
      DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead responseMethod,
      AssignStmt sinkDeclaration
    |
      headerInstance = API::moduleImport("flask").getMember("Response").getACall() and
      responseMethod.getAttributeName() = "headers" and
      responseMethod.getObject().getALocalSource() = headerInstance and
      sinkDeclaration.getATarget() = responseMethod.asExpr().getParentNode() and
      this.asExpr() = sinkDeclaration.getValue()
    )
  }
}

class FlaskMakeResponse extends DataFlow::Node {
  FlaskMakeResponse() {
    exists(
      DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead responseMethod,
      AssignStmt sinkDeclaration
    |
      headerInstance = API::moduleImport("flask").getMember("make_response").getACall() and
      responseMethod.getAttributeName() = "headers" and
      responseMethod.getObject().getALocalSource() = headerInstance and
      (
        sinkDeclaration.getATarget() = responseMethod.asExpr().getParentNode() and
        this.asExpr() = sinkDeclaration.getValue()
      )
      //or
      //extendMethod.getAttributeName() = "extend" and
      //extendMethod.getObject().getALocalSource() = responseMethod and
      //this = extendMethod.(DataFlow::CallCfgNode).getArg(0)
    )
  }
}

class HeaderInjectionSink extends DataFlow::Node {
  HeaderInjectionSink() {
    this instanceof WerkzeugHeader or
    this instanceof FlaskHeader or
    this instanceof FlaskMakeResponse
  }
}

class HeaderInjectionFlowConfig extends TaintTracking::Configuration {
  HeaderInjectionFlowConfig() { this = "HeaderInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof HeaderInjectionSink }
}

from HeaderInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ header is constructed from a $@.", sink.getNode(), "This",
  source.getNode(), "user-provided value"
