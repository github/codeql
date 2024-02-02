/**
 * @name Fetch a subset of valid access paths of input and output parameters of a method (framework mode).
 * @description A list of access paths for input and output parameters of a method. Excludes test and generated code.
 * @kind table
 * @id ruby/utils/modeleditor/framework-mode-access-paths
 * @tags modeleditor access-paths framework-mode
 */

private import ruby
private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import queries.modeling.internal.Util as Util

string parameterDetails(DataFlow::ParameterNode paramNode) {
  exists(DataFlow::MethodNode methodNode | methodNode.getParameter(_) = paramNode |
    result = paramNode.getName()
  )
  or
  exists(DataFlow::MethodNode methodNode, string name |
    methodNode.getKeywordParameter(name) = paramNode
  |
    result = name + ":"
  )
  or
  exists(DataFlow::MethodNode methodNode | methodNode.getBlockParameter() = paramNode |
    result = "&" + paramNode.getName()
    or
    not exists(paramNode.getName()) and result = "&"
  )
  or
  exists(DataFlow::MethodNode methodNode | methodNode.getSelfParameter() = paramNode |
    result = "self"
  )
  or
  exists(DataFlow::MethodNode methodNode | methodNode.getHashSplatParameter() = paramNode |
    result = "**" + paramNode.getName()
    or
    not exists(paramNode.getName()) and result = "**"
  )
}

predicate simpleParameters(string type, string path, string value, string details) {
  exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    (
      // Check that this parameter belongs to this method
      // Block parameter explicitly excluded because it's already included
      // as part of the blockArguments predicate
      paramNode = Util::getAnyParameter(methodNode) and
      paramNode != methodNode.getBlockParameter()
    )
  |
    Util::pathToMethod(methodNode, type, path) and
    value = Util::getArgumentPath(paramNode) and
    details = parameterDetails(paramNode)
  )
}

predicate blockArguments(string type, string path, string value, string details) {
  exists(DataFlow::MethodNode methodNode, DataFlow::CallNode callNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    callNode = methodNode.getABlockCall()
  |
    (
      exists(DataFlow::VariableAccessNode argNode, int i |
        argNode = callNode.getPositionalArgument(i)
      |
        value = "Argument[block].Parameter[" + i + "]" and
        details = argNode.asVariableAccessAstNode().getVariable().getName()
      )
      or
      exists(DataFlow::ExprNode argNode, string keyword |
        argNode = callNode.getKeywordArgument(keyword)
      |
        value = "Argument[block].Parameter[" + keyword + ":]" and
        details = ":" + keyword
      )
      or
      value = "Argument[block]" and
      (
        details = callNode.getMethodName()
        or
        not exists(callNode.getMethodName()) and
        callNode.getExprNode().getExpr() instanceof YieldCall and
        details = "yield ..."
      )
    ) and
    Util::pathToMethod(methodNode, type, path)
  )
}

predicate returnValue(string type, string path, string value, string details) {
  exists(DataFlow::MethodNode methodNode, DataFlow::Node returnNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    returnNode = methodNode.getAReturnNode()
  |
    Util::pathToMethod(methodNode, type, path) and
    value = "ReturnValue" and
    details = returnNode.toString()
  )
}

predicate inputAccessPaths(string type, string path, string value, string details, string defType) {
  simpleParameters(type, path, value, details) and defType = "parameter"
  or
  blockArguments(type, path, value, details) and defType = "parameter"
}

predicate outputAccessPaths(string type, string path, string value, string details, string defType) {
  simpleParameters(type, path, value, details) and defType = "parameter"
  or
  blockArguments(type, path, value, details) and defType = "parameter"
  or
  returnValue(type, path, value, details) and defType = "return"
}

query predicate input = inputAccessPaths/5;

query predicate output = outputAccessPaths/5;
