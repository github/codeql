private import ruby
private import codeql.ruby.TaintTracking
private import Util as Util

module Summaries {
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

    predicate summaryModel(string type, string path, string input, string output) {
      exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
        methodNode.getLocation().getFile() instanceof Util::RelevantFile and
        flow(paramNode, methodNode.getAReturnNode()) and
        paramNode = getAnyParameterNode(methodNode)
      |
        type = Util::getAnAccessPathPrefix(methodNode) and
        path = Util::getMethodPath(methodNode) and
        input = Util::getArgumentPath(paramNode) and
        output = "ReturnValue"
      )
    }
  }

  private module TaintFlow {
    import TaintTracking::Global<Config>

    predicate summaryModel(string type, string path, string input, string output) {
      not ValueFlow::summaryModel(type, path, input, output) and
      exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
        methodNode.getLocation().getFile() instanceof Util::RelevantFile and
        flow(paramNode, methodNode.getAReturnNode()) and
        paramNode = getAnyParameterNode(methodNode)
      |
        type = Util::getAnAccessPathPrefix(methodNode) and
        path = Util::getMethodPath(methodNode) and
        input = Util::getArgumentPath(paramNode) and
        output = "ReturnValue"
      )
    }
  }

  predicate summaryModel(string type, string path, string input, string output, string kind) {
    ValueFlow::summaryModel(type, path, input, output) and kind = "value"
    or
    TaintFlow::summaryModel(type, path, input, output) and kind = "taint"
  }
}
