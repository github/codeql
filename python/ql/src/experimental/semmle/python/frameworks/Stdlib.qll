/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Headers {
  private module Werkzeug {
    class WerkzeugHeaderCall extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
      WerkzeugHeaderCall() {
        exists(DataFlow::AttrRead addMethod |
          this.getFunction() = addMethod and
          addMethod.getObject().getALocalSource() =
            API::moduleImport("werkzeug")
                .getMember("datastructures")
                .getMember("Headers")
                .getACall() and
          addMethod.getAttributeName() = "add"
        )
      }

      override DataFlow::Node getHeaderInputNode() { result = this.getArg(1) }
    }
  }

  private module Flask {
    class FlaskHeaderCall extends DataFlow::Node, HeaderDeclaration::Range {
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

      override DataFlow::Node getHeaderInputNode() { result = headerInputNode }
    }

    class FlaskMakeResponseCall extends DataFlow::Node, HeaderDeclaration::Range {
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

      override DataFlow::Node getHeaderInputNode() { result = headerInputNode }
    }

    class FlaskMakeResponseExtendCall extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
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

      override DataFlow::Node getHeaderInputNode() { result = headerInputNode }
    }

    class FlaskResponseArg extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
      DataFlow::Node headerInputNode;

      FlaskResponseArg() {
        this = API::moduleImport("flask").getMember("Response").getACall() and
        headerInputNode = this.getArgByName("headers")
      }

      override DataFlow::Node getHeaderInputNode() { result = headerInputNode }
    }

    class DjangoResponseSetItemCall extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
      DjangoResponseSetItemCall() {
        exists(DataFlow::AttrRead setItemMethod |
          this.getFunction() = setItemMethod and
          setItemMethod.getObject().getALocalSource() =
            API::moduleImport("django").getMember("http").getMember("HttpResponse").getACall() and
          setItemMethod.getAttributeName() = "__setitem__"
        )
      }

      override DataFlow::Node getHeaderInputNode() { result = this.getArg(1) }
    }
  }

  private module Django {
    class DjangoResponseAssignCall extends DataFlow::Node, HeaderDeclaration::Range {
      DataFlow::Node headerInputNode;

      DjangoResponseAssignCall() {
        exists(
          DataFlow::CallCfgNode headerInstance, Subscript responseMethod,
          DataFlow::Node responseToNode, AssignStmt sinkDeclaration
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

      override DataFlow::Node getHeaderInputNode() { result = headerInputNode }
    }
  }
}
