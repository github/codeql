/**
 * Provides classes for working with [AWS Lambda](https://docs.aws.amazon.com/lambda/) functions.
 */

import javascript

module AwsLambda {
  /**
   * A typed AWS Lambda handler function.
   */
  class Handler extends DataFlow::FunctionNode {
    Handler() {
      this = any(Module m).getAnExportedValue(_).getAFunctionValue() and
      (
        this.getParameter(0) =
          ModelOutput::getATypeNode("aws-lambda.Event").getAValueReachableFromSource()
        or
        exists(VariableDeclarator decl |
          this = decl.getInit().flow() and
          DataFlow::valueNode(decl.getBindingPattern()) =
            ModelOutput::getATypeNode("aws-lambda.Handler").getAValueReachableFromSource()
        )
      )
    }
  }

  /** A source for the `event` parameter of an AWS Lambda handler. */
  private class HandlerEventSource extends RemoteFlowSource {
    HandlerEventSource() { this = any(Handler h).getParameter(0) }

    override string getSourceType() { result = "AWS Lambda event" }
  }
}
