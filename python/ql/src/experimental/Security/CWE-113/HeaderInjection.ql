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

class WerkzeugHeaderCall extends DataFlow::CallCfgNode {
  WerkzeugHeaderCall() {
    exists(DataFlow::AttrRead addMethod |
      this.getFunction() = addMethod and
      addMethod.getObject().getALocalSource() =
        API::moduleImport("werkzeug").getMember("datastructures").getMember("Headers").getACall() and
      addMethod.getAttributeName() = "add"
    )
  }

  DataFlow::Node getHeaderInputNode() { result = this.getArg(1) }
}

class FlaskHeaderCall extends DataFlow::Node {
  DataFlow::Node headerInputNode;

  FlaskHeaderCall() {
    exists(
      DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead responseMethod,
      AssignStmt sinkDeclaration
    |
      headerInstance = API::moduleImport("flask").getMember("Response").getACall() and
      responseMethod.getAttributeName() = "headers" and
      responseMethod.getObject().getALocalSource() = headerInstance and
      sinkDeclaration.getATarget() = responseMethod.asExpr().getParentNode() and
      headerInputNode.asExpr() = sinkDeclaration.getValue() and
      this.asExpr() = sinkDeclaration.getATarget()
    )
  }

  DataFlow::Node getHeaderInputNode() { result = headerInputNode }
}

class FlaskMakeResponseCall extends DataFlow::Node {
  DataFlow::Node headerInputNode;

  FlaskMakeResponseCall() {
    exists(
      DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead responseMethod,
      AssignStmt sinkDeclaration
    |
      headerInstance = API::moduleImport("flask").getMember("make_response").getACall() and
      responseMethod.getAttributeName() = "headers" and
      responseMethod.getObject().getALocalSource() = headerInstance and
      sinkDeclaration.getATarget() = responseMethod.asExpr().getParentNode() and
      this.asExpr() = sinkDeclaration.getATarget() and
      headerInputNode.asExpr() = sinkDeclaration.getValue()
    )
  }

  DataFlow::Node getHeaderInputNode() { result = headerInputNode }
}

class FlaskMakeResponseExtendCall extends DataFlow::CallCfgNode {
  DataFlow::Node headerInputNode;

  FlaskMakeResponseExtendCall() {
    exists(
      DataFlow::CallCfgNode headerInstance, DataFlow::AttrRead responseMethod,
      DataFlow::AttrRead extendMethod
    |
      headerInstance = API::moduleImport("flask").getMember("make_response").getACall() and
      responseMethod.getAttributeName() = "headers" and
      responseMethod.getObject().getALocalSource() = headerInstance and
      extendMethod.getAttributeName() = "extend" and
      extendMethod.getObject().getALocalSource() = responseMethod and
      this.getFunction() = extendMethod and
      headerInputNode = this.getArg(0)
    )
  }

  DataFlow::Node getHeaderInputNode() { result = headerInputNode }
}

class FlaskResponseArg extends DataFlow::CallCfgNode {
  DataFlow::Node headerInputNode;

  FlaskResponseArg() {
    this = API::moduleImport("flask").getMember("Response").getACall() and
    headerInputNode = this.getArgByName("headers")
  }

  DataFlow::Node getHeaderInputNode() { result = headerInputNode }
}

class DjangoResponseSetItemCall extends DataFlow::CallCfgNode {
  DjangoResponseSetItemCall() {
    exists(DataFlow::AttrRead setItemMethod |
      this.getFunction() = setItemMethod and
      setItemMethod.getObject().getALocalSource() =
        API::moduleImport("django").getMember("http").getMember("HttpResponse").getACall() and
      setItemMethod.getAttributeName() = "__setitem__"
    )
  }

  DataFlow::Node getHeaderInputNode() { result = this.getArg(1) }
}

class DjangoResponseAssignCall extends DataFlow::Node {
  DataFlow::Node headerInputNode;

  DjangoResponseAssignCall() {
    exists(
      DataFlow::CallCfgNode headerInstance, Subscript responseMethod, DataFlow::Node responseToNode,
      AssignStmt sinkDeclaration
    |
      headerInstance =
        API::moduleImport("django").getMember("http").getMember("HttpResponse").getACall() and
      responseMethod.getValue() = responseToNode.asExpr() and
      responseToNode.getALocalSource().asExpr() = headerInstance.asExpr() and
      sinkDeclaration.getATarget() = responseMethod and
      this.asExpr() = sinkDeclaration.getATarget() and
      headerInputNode.asExpr() = sinkDeclaration.getValue()
    )
  }

  DataFlow::Node getHeaderInputNode() { result = headerInputNode }
}

class HeaderInjectionSink extends DataFlow::Node {
  HeaderInjectionSink() {
    this = any(WerkzeugHeaderCall a).getHeaderInputNode() or
    this = any(FlaskHeaderCall a).getHeaderInputNode() or
    this = any(FlaskMakeResponseCall a).getHeaderInputNode() or
    this = any(FlaskMakeResponseExtendCall a).getHeaderInputNode() or
    this = any(FlaskResponseArg a).getHeaderInputNode() or
    this = any(DjangoResponseSetItemCall a).getHeaderInputNode() or
    this = any(DjangoResponseAssignCall a).getHeaderInputNode()
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
