private import ruby

// `SomeClass#initialize` methods are usually called indirectly via
// `SomeClass.new`, so we need to account for this when generating access paths
private string getNormalizedMethodName(DataFlow::MethodNode methodNode) {
  exists(string actualMethodName | actualMethodName = methodNode.getMethodName() |
    if actualMethodName = "initialize" then result = "new" else result = actualMethodName
  )
}

private string getAccessPathSuffix(Ast::MethodBase method) {
  if method instanceof Ast::SingletonMethod or method.getName() = "initialize"
  then result = "!"
  else result = ""
}

string getAnAccessPathPrefix(DataFlow::MethodNode methodNode) {
  exists(Ast::MethodBase method | method = methodNode.asExpr().getExpr() |
    result =
      method.getEnclosingModule().(Ast::ConstantWriteAccess).getAQualifiedName() +
        getAccessPathSuffix(method)
  )
}

class RelevantFile extends File {
  RelevantFile() { not this.getRelativePath().regexpMatch(".*/?test(case)?s?/.*") }
}

string getMethodPath(DataFlow::MethodNode methodNode) {
  result = "Method[" + getNormalizedMethodName(methodNode) + "]"
}

private string getParameterPath(DataFlow::ParameterNode paramNode) {
  exists(Ast::Parameter param, string paramSpec |
    param = paramNode.asParameter() and
    (
      paramSpec = param.getPosition().toString()
      or
      paramSpec = param.(Ast::KeywordParameter).getName() + ":"
      or
      param instanceof Ast::BlockParameter and
      paramSpec = "block"
    )
  |
    result = "Parameter[" + paramSpec + "]"
  )
}

string getMethodParameterPath(DataFlow::MethodNode methodNode, DataFlow::ParameterNode paramNode) {
  result = getMethodPath(methodNode) + "." + getParameterPath(paramNode)
}
