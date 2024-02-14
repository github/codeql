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
private import ModelEditor

predicate simpleParameters(string type, string path, string value, DataFlow::Node node) {
  exists(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    (
      // Check that this parameter belongs to this method
      // Block parameter explicitly excluded because it's already included
      // as part of the blockArguments predicate
      paramNode = Util::getAnyParameter(methodNode) and
      paramNode != methodNode.getBlockParameter() and
      // The self parameter of a constructor is not a parameter that can be used in any models
      (not isConstructor(methodNode) or paramNode != methodNode.getSelfParameter())
    )
  |
    Util::pathToMethod(methodNode, type, path) and
    value = Util::getArgumentPath(paramNode) and
    node = paramNode
  )
}

predicate blockArguments(string type, string path, string value, DataFlow::Node node) {
  exists(DataFlow::MethodNode methodNode, DataFlow::CallNode callNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    callNode = methodNode.getABlockCall()
  |
    (
      exists(DataFlow::VariableAccessNode argNode, int i |
        argNode = callNode.getPositionalArgument(i)
      |
        value = "Argument[block].Parameter[" + i + "]" and
        node = argNode
      )
      or
      exists(DataFlow::ExprNode argNode, string keyword |
        argNode = callNode.getKeywordArgument(keyword)
      |
        value = "Argument[block].Parameter[" + keyword + ":]" and
        node = argNode
      )
      or
      value = "Argument[block]" and
      node = callNode
    ) and
    Util::pathToMethod(methodNode, type, path)
  )
}

predicate returnValue(string type, string path, string value, DataFlow::Node node) {
  exists(DataFlow::MethodNode methodNode, DataFlow::Node returnNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    returnNode = methodNode.getAReturnNode() and
    not isConstructor(methodNode)
  |
    Util::pathToMethod(methodNode, type, path) and
    value = "ReturnValue" and
    node = returnNode
  )
  or
  // A constructor has a return node for every statement, but we always want
  // to return 1 node for the ReturnValue, so we return the self parameter
  // instead.
  exists(DataFlow::MethodNode methodNode |
    methodNode.getLocation().getFile() instanceof Util::RelevantFile and
    isConstructor(methodNode)
  |
    Util::pathToMethod(methodNode, type, path) and
    value = "ReturnValue" and
    node = methodNode.getSelfParameter()
  )
}

predicate inputAccessPaths(
  string type, string path, string value, DataFlow::Node node, string defType
) {
  simpleParameters(type, path, value, node) and defType = "parameter"
  or
  blockArguments(type, path, value, node) and defType = "parameter"
}

predicate outputAccessPaths(
  string type, string path, string value, DataFlow::Node node, string defType
) {
  simpleParameters(type, path, value, node) and defType = "parameter"
  or
  blockArguments(type, path, value, node) and defType = "parameter"
  or
  returnValue(type, path, value, node) and defType = "return"
}

query predicate input = inputAccessPaths/5;

query predicate output = outputAccessPaths/5;
