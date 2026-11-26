/**
 * Provides classes for working with [AWS Lambda](https://docs.aws.amazon.com/lambda/) functions.
 */

import javascript
private import semmle.javascript.security.TaintedObject

module AwsLambda {
  /**
   * A parameter whose type is an AWS Lambda event type.
   */
  bindingset[eventType, handlerType]
  private DataFlow::ParameterNode eventParameterOfType(string eventType, string handlerType) {
    result = ModelOutput::getATypeNode(eventType).asSource()
    or
    exists(VariableDeclarator decl |
      DataFlow::valueNode(decl.getBindingPattern()) =
        ModelOutput::getATypeNode(handlerType).asSource() and
      result = decl.getInit().flow().getAFunctionValue().getParameter(0)
    )
  }

  /**
   * A typed AWS Lambda handler function.
   */
  class EventFunctionHandler extends DataFlow::FunctionNode {
    EventFunctionHandler() {
      exists(Module mod | this = mod.getAnExportedValue(_).getAFunctionValue()) and
      this.getParameter(0) =
        eventParameterOfType("aws-lambda.Event", "aws-lambda.EventFunctionHandler")
    }
  }

  /**
   * A source for the `event` parameter of an AWS Lambda handler.
   */
  private class EventParameterSource extends RemoteFlowSource {
    EventParameterSource() { this = any(EventFunctionHandler h).getParameter(0) }

    override string getSourceType() { result = "AWS Lambda event" }
  }

  /**
   * The `detail` property of an AWS EventBridge event, which contains the raw, user-controlled
   * event payload as a deeply nested object.
   */
  private class EventBridgeEventSource extends TaintedObject::Source {
    EventBridgeEventSource() {
      this =
        eventParameterOfType("aws-lambda.EventBridgeEvent", "aws-lambda.EventBridgeHandler")
            .getAPropertyRead("detail")
    }
  }

  /**
   * The `arguments` property of an AWS AppSync resolver event, which contains the raw,
   * user-controlled GraphQL arguments as a deeply nested object.
   */
  private class AppSyncResolverEventSource extends TaintedObject::Source {
    AppSyncResolverEventSource() {
      this =
        eventParameterOfType("aws-lambda.AppSyncResolverEvent", "aws-lambda.AppSyncResolverHandler")
            .getAPropertyRead("arguments")
    }
  }
}
