private import ruby
private import Util as Util

module Summaries {
  predicate summaryModelParamToReturnValue(
    string type, string path, string input, string output, string kind
  ) {
    exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
      methodNode.getLocation().getFile() instanceof Util::RelevantFile and
      paramNode.flowsTo(methodNode.getAReturnNode())
    |
      type = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodPath(methodNode) and
      input = Util::getArgumentPath(paramNode) and
      output = "ReturnValue" and
      kind = "value"
    )
  }

  predicate summaryModel(string type, string path, string input, string output, string kind) {
    summaryModelParamToReturnValue(type, path, input, output, kind)
  }
}
