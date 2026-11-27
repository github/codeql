import go
private import semmle.go.dataflow.internal.DataFlowPrivate as Impl
private import semmle.go.dataflow.internal.DataFlowNodes::Private as Nodes
import utils.test.InlineExpectationsTest

module ArgumentNodesTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "closure-args", "callee-post", "closure-post", "argument-post", "syntactic-arg",
        "receiver-post", "closure-params", "receiver-node", "function-receiver", "input-receiver",
        "receiver-agreement"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::CallNode call |
      call.getEnclosingCallable().getName() = "closureArgumentNodes" and
      location = call.getLocation() and
      element = call.toString()
    |
      tag = "closure-args" and
      value =
        count(DataFlow::ArgumentNode argument | argument.argumentOf(call.asExpr(), -2)).toString()
      or
      tag = "callee-post" and
      value =
        count(DataFlow::PostUpdateNode post | post.getPreUpdateNode() = call.getCalleeNode())
            .toString()
      or
      tag = "closure-post" and
      value =
        count(DataFlow::PostUpdateNode post | post.getPreUpdateNode() = Impl::getArgument(call, -2))
            .toString()
      or
      tag = "argument-post" and
      call.getTarget().getName() = "callback" and
      value =
        count(DataFlow::PostUpdateNode post | post.getPreUpdateNode() = Impl::getArgument(call, 0))
            .toString()
      or
      tag = "syntactic-arg" and
      call.getTarget().getName() = "callback" and
      value =
        count(DataFlow::ArgumentNode argument |
          argument.argumentOf(call.asExpr(), 0) and
          argument.getACorrespondingSyntacticArgument() = call.getSyntacticArgument(0)
        ).toString()
      or
      tag = "receiver-post" and
      call instanceof DataFlow::MethodCallNode and
      value =
        count(DataFlow::PostUpdateNode post |
          post.getPreUpdateNode() = call.(DataFlow::MethodCallNode).getReceiver()
        ).toString()
    )
    or
    exists(FuncLit function |
      DataFlow::exprNode(function).getEnclosingCallable().getName() = "closureArgumentNodes" and
      location = function.getLocation() and
      element = function.toString() and
      tag = "closure-params" and
      value =
        count(Nodes::CapturedVariablesParameterNode parameter | parameter.getFunction() = function)
            .toString()
    )
    or
    exists(MethodDecl method, DataFlow::FunctionNode function |
      method.getName() = ["closure", "directReceiver", "unusedReceiver"] and
      function.getFunction() = method.getFunction() and
      location = method.getReceiver().getLocation() and
      element = method.getReceiver().toString()
    |
      tag = "receiver-node" and
      value = count(DataFlow::receiverNode(method.getReceiver())).toString()
      or
      tag = "function-receiver" and
      value = count(function.getReceiver()).toString()
      or
      tag = "input-receiver" and
      value = count(FunctionInput::receiver().getExitNode(method)).toString()
      or
      tag = "receiver-agreement" and
      value =
        count(DataFlow::ReceiverNode node |
          node = DataFlow::receiverNode(method.getReceiver()) and
          node = DataFlow::parameterNode(method.getReceiver()) and
          node = function.getReceiver() and
          node = FunctionInput::receiver().getExitNode(method) and
          node.isReceiverOf(method)
        ).toString()
    )
  }
}

import MakeTest<ArgumentNodesTest>
