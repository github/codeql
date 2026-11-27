/**
 * Provides classes for working with [AWS Lambda](https://docs.aws.amazon.com/lambda/) functions.
 */

import javascript

module AwsLambda {
  /**
   * Gets a function assigned to the variable of the typed declaration `typed`, either in its
   * initializer or in a later assignment.
   */
  private DataFlow::FunctionNode functionAssignedToVariable(DataFlow::Node typed) {
    result = typed.asExpr().(VarDecl).getVariable().getAnAssignedExpr().flow().getAFunctionValue()
  }

  /**
   * A typed AWS Lambda handler function.
   */
  class EventFunctionHandler extends DataFlow::FunctionNode {
    EventFunctionHandler() {
      exists(Module mod | this = mod.getAnExportedValue(_).getAFunctionValue()) and
      (
        this.getParameter(0) = ModelOutput::getATypeNode("aws-lambda.Event").asSource()
        or
        exists(DataFlow::Node handlerType |
          handlerType = ModelOutput::getATypeNode("aws-lambda.EventFunctionHandler").asSource()
        |
          this = functionAssignedToVariable(handlerType) or this.flowsTo(handlerType)
        )
      )
    }
  }

  /**
   * A source for the `event` parameter of an AWS Lambda handler.
   */
  private class EventParameterSource extends RemoteFlowSource {
    EventParameterSource() { this = any(EventFunctionHandler h).getParameter(0) }

    override string getSourceType() { result = "AWS Lambda event" }
  }
}
