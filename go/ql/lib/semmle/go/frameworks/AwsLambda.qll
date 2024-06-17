/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the `github.com/aws/aws-lambda-go/lambda` package.
 */

import go

/** A source of input data in an AWS Lambda. */
private class LambdaInput extends RemoteFlowSource::Range {
  LambdaInput() {
    exists(Parameter p | p = this.asParameter() |
      p = any(HandlerFunction hf).getAParameter() and
      not p.getType().hasQualifiedName("context", "Context") and
      not p instanceof ReceiverVariable
    )
  }
}

private class HandlerFunction extends FuncDef {
  HandlerFunction() {
    exists(StartOrNewHandlerFunction f, DataFlow::Node handlerArg |
      f.getACall().getArgument(f.getHandlerArgPos()) = handlerArg
    |
      handlerArg = this.(FuncDecl).getFunction().getARead() or
      handlerArg = DataFlow::exprNode(this.(FuncLit))
    )
    or
    this = any(Method m | m.implements(awsLambdaPkg(), "Handler", "Invoke")).getFuncDecl()
    or
    exists(DataFlow::TypeCastNode typeCast |
      typeCast.getResultType() instanceof HandlerImpl and
      this.(FuncDecl).getFunction().getARead() = typeCast.getOperand()
    )
  }
}

private class StartOrNewHandlerFunction extends Function {
  int handlerArgPos;

  StartOrNewHandlerFunction() {
    this.hasQualifiedName(awsLambdaPkg(),
      [
        "Start", "StartHandler", "StartHandlerFunc", "StartWithOptions", "NewHandler",
        "NewHandlerWithOptions"
      ]) and
    handlerArgPos = 0
    or
    this.hasQualifiedName(awsLambdaPkg(), ["StartHandlerWithContext", "StartWithContext"]) and
    handlerArgPos = 1
  }

  int getHandlerArgPos() { result = handlerArgPos }
}

private class HandlerImpl extends Type {
  HandlerImpl() { this.implements(awsLambdaPkg(), "Handler") }
}

private string awsLambdaPkg() { result = "github.com/aws/aws-lambda-go/lambda" }
