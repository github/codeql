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
   * The first parameter of an exported function, whose type is an AWS Lambda event type.
   */
  bindingset[eventType, handlerType]
  private DataFlow::ParameterNode exportedEventParameterOfType(string eventType, string handlerType) {
    exists(Module mod, DataFlow::FunctionNode fn |
      fn = mod.getAnExportedValue(_).getAFunctionValue() and
      result = fn.getParameter(0) and
      result = eventParameterOfType(eventType, handlerType)
    )
  }

  /**
   * A typed AWS Lambda handler function.
   */
  class EventFunctionHandler extends DataFlow::FunctionNode {
    EventFunctionHandler() {
      this.getParameter(0) =
        exportedEventParameterOfType("aws-lambda.Event", "aws-lambda.EventFunctionHandler")
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
        exportedEventParameterOfType("aws-lambda.EventBridgeEvent", "aws-lambda.EventBridgeHandler")
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
        exportedEventParameterOfType("aws-lambda.AppSyncResolverEvent",
          "aws-lambda.AppSyncResolverHandler").getAPropertyRead("arguments")
    }
  }
}
