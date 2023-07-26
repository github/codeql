private import ruby

// `SomeClass#initialize` methods are usually called indirectly via
// `SomeClass.new`, so we need to account for this when generating access paths
string getNormalizedMethodName(DataFlow::MethodNode methodNode) {
  exists(string actualMethodName | actualMethodName = methodNode.getMethodName() |
    if actualMethodName = "initialize" then result = "new" else result = actualMethodName
  )
}

private string getAccessPathSuffix(Ast::MethodBase method) {
  if method instanceof Ast::SingletonMethod or method.getName() = "initialize"
  then result = "!"
  else result = ""
}

string getAnAccessPathPrefix(Ast::MethodBase method) {
  result =
    method.getEnclosingModule().(Ast::ConstantWriteAccess).getAQualifiedName() +
      getAccessPathSuffix(method)
}
