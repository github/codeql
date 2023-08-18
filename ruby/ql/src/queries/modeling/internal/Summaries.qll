private import ruby
private import codeql.ruby.TaintTracking
private import Util as Util

module Summaries {
  //   predicate valueFlowRec(DataFlow::ParameterNode paramNode, DataFlow::Node returnNode) {
  //     paramNode.flowsTo(returnNode)
  //     or
  //     exists(
  //       DataFlow::Node argNode, DataFlow::CallNode callNode, DataFlow::ParameterNode paramNode2,
  //       DataFlow::MethodNode methodNode2
  //     |
  //       paramNode.flowsTo(argNode) and
  //       methodNode2 = callNode.getATarget() and
  //       exists(int i |
  //         argNode = callNode.getArgument(i) and
  //         paramNode2 = methodNode2.getParameter(i)
  //       )
  //       or
  //       exists(string argName |
  //         argNode = callNode.getKeywordArgument(argName) and
  //         paramNode2 = methodNode2.getKeywordParameter(argName)
  //       )
  //     |
  //       valueFlowRec(paramNode2, methodNode2.getAReturnNode()) and
  //       callNode.flowsTo(returnNode)
  //     )
  //   }
  //   predicate taintFlowRec(DataFlow::ParameterNode paramNode, DataFlow::Node returnNode) {
  //     TaintTracking::localTaint(paramNode, returnNode) and
  //     not valueFlowRec(paramNode, returnNode)
  //     or
  //     exists(
  //       DataFlow::Node argNode, DataFlow::CallNode callNode, DataFlow::ParameterNode paramNode2,
  //       DataFlow::MethodNode methodNode2, DataFlow::Node returnNode2
  //     |
  //       TaintTracking::localTaint(paramNode, argNode) and
  //       methodNode2 = callNode.getATarget() and
  //       returnNode2 = methodNode2.getAReturnNode() and
  //       exists(int i |
  //         argNode = callNode.getArgument(i) and
  //         paramNode2 = methodNode2.getParameter(i)
  //       )
  //       or
  //       exists(string argName |
  //         argNode = callNode.getKeywordArgument(argName) and
  //         paramNode2 = methodNode2.getKeywordParameter(argName)
  //       )
  //     |
  //       valueFlowRec(paramNode2, methodNode2.getAReturnNode()) and
  //       TaintTracking::localTaint(paramNode2, returnNode2)
  //   )
  // }
  // predicate summaryModelParamToReturnValue(
  //   string type, string path, string input, string output, string kind
  //   ) {
  //   exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
  //     methodNode.getLocation().getFile() instanceof Util::RelevantFile and
  //     valueFlowRec(paramNode, methodNode.getAReturnNode())
  //     |
  //     type = Util::getAnAccessPathPrefix(methodNode) and
  //     path = Util::getMethodPath(methodNode) and
  //     input = Util::getArgumentPath(paramNode) and
  //     output = "ReturnValue" and
  //     kind = "value"
  //   )
  // }
  // predicate summaryModelParamToReturnTaint(
  //   string type, string path, string input, string output, string kind
  //   ) {
  //   exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
  //     methodNode.getLocation().getFile() instanceof Util::RelevantFile and
  //     taintFlowRec(paramNode, methodNode.getAReturnNode())
  //     |
  //     type = Util::getAnAccessPathPrefix(methodNode) and
  //     path = Util::getMethodPath(methodNode) and
  //     input = Util::getArgumentPath(paramNode) and
  //     output = "ReturnValue" and
  //     kind = "taint"
  //   )
  // }
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof DataFlow::ParameterNode }

    predicate isSink(DataFlow::Node sink) { sink = any(DataFlow::MethodNode m).getAReturnNode() }
  }

  DataFlow::ParameterNode getAnyParameterNode(DataFlow::MethodNode methodNode) {
    result =
      [
        methodNode.getParameter(_), methodNode.getKeywordParameter(_),
        methodNode.getBlockParameter(), methodNode.getSelfParameter()
      ]
  }

  private module ValueFlow {
    import DataFlow::Global<Config>

    predicate summaryModel(string type, string path, string input, string output, string kind) {
      exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
        methodNode.getLocation().getFile() instanceof Util::RelevantFile and
        flow(paramNode, methodNode.getAReturnNode()) and
        paramNode = getAnyParameterNode(methodNode)
      |
        type = Util::getAnAccessPathPrefix(methodNode) and
        path = Util::getMethodPath(methodNode) and
        input = Util::getArgumentPath(paramNode) and
        output = "ReturnValue" and
        kind = "value"
      )
    }
  }

  private module TaintFlow {
    import TaintTracking::Global<Config>

    predicate summaryModel(string type, string path, string input, string output, string kind) {
      exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
        methodNode.getLocation().getFile() instanceof Util::RelevantFile and
        flow(paramNode, methodNode.getAReturnNode()) and
        paramNode = getAnyParameterNode(methodNode)
      |
        type = Util::getAnAccessPathPrefix(methodNode) and
        path = Util::getMethodPath(methodNode) and
        input = Util::getArgumentPath(paramNode) and
        output = "ReturnValue" and
        kind = "taint"
      )
    }
  }

  predicate summaryModel(string type, string path, string input, string output, string kind) {
    ValueFlow::summaryModel(type, path, input, output, kind)
    or
    TaintFlow::summaryModel(type, path, input, output, kind) and
    not ValueFlow::summaryModel(type, path, input, output, "value")
    // summaryModelParamToReturnValue(type, path, input, output, kind)
    // or
    // summaryModelParamToReturnTaint(type, path, input, output, kind)
  }
}
