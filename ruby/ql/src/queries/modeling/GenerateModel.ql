// TODO: metadata
import ruby
import codeql.ruby.ApiGraphs

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

private string getAnAccessPathPrefix(Ast::MethodBase method) {
  result =
    method.getEnclosingModule().(Ast::ConstantWriteAccess).getAQualifiedName() +
      getAccessPathSuffix(method)
}

// TODO: can we use DataFlow::Node#backtrack and API::Node#getInstance
private predicate methodReturnsTypeBase(
  DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode
) {
  // ignore cases of initializing instance of self
  not methodNode.getMethodName() = "initialize" and
  exists(DataFlow::CallNode returnedValue |
    // TODO: construction of type values not using a "new" call
    returnedValue.flowsTo(methodNode.getAReturnNode()) and
    returnedValue.getMethodName() = "new" and
    classNode.getAnImmediateReference().getAMethodCall() = returnedValue
  )
}

private predicate methodReturnsType(DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode) {
  // return of a Foo instance created with Foo.new
  methodReturnsTypeBase(methodNode, classNode)
  or
  // indirect return of a Foo instance
  exists(DataFlow::CallNode returnedValue, DataFlow::MethodNode otherMethod |
    returnedValue.flowsTo(methodNode.getAReturnNode()) and
    returnedValue.getATarget() = otherMethod and
    methodReturnsType(otherMethod, classNode)
  )
}

// `exprNode` is an instance of `classNode`
private predicate exprHasType(DataFlow::ExprNode exprNode, DataFlow::ClassNode classNode) {
  exists(DataFlow::MethodNode methodNode, DataFlow::CallNode callNode |
    methodReturnsType(methodNode, classNode) and
    callNode.getATarget() = methodNode
  |
    exprNode.getALocalSource() = callNode
  )
  or
  exists(DataFlow::MethodNode containingMethod |
    classNode.getInstanceMethod(containingMethod.getMethodName()) = containingMethod
  |
    exprNode.getALocalSource() = containingMethod.getSelfParameter()
  )
}

// extensible predicate typeModel(string type1, string type2, string path);
// the method node in type2 constructs an instance of classNode
private predicate typeModelReturns(string type1, string type2, string path) {
  exists(DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode |
    methodReturnsType(methodNode, classNode)
  |
    type1 = classNode.getQualifiedName() and
    type2 = getAnAccessPathPrefix(methodNode.asExpr().getExpr()) and
    path = "Method[" + getNormalizedMethodName(methodNode) + "].ReturnValue"
  )
}

private predicate methodTakesParameterOfType(
  DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode,
  DataFlow::ParameterNode parameterNode
) {
  exists(DataFlow::CallNode callToMethodNode, DataFlow::LocalSourceNode argumentNode |
    callToMethodNode.getATarget() = methodNode and
    // positional parameter
    exists(int paramIndex |
      argumentNode.flowsTo(callToMethodNode.getArgument(paramIndex)) and
      parameterNode = methodNode.getParameter(paramIndex)
    )
    or
    // keyword parameter
    exists(string kwName |
      argumentNode.flowsTo(callToMethodNode.getKeywordArgument(kwName)) and
      parameterNode = methodNode.getKeywordParameter(kwName)
    )
    or
    // block parameter
    argumentNode.flowsTo(callToMethodNode.getBlock()) and
    parameterNode = methodNode.getBlockParameter()
  |
    // parameter directly from new call
    argumentNode.(DataFlow::CallNode).getMethodName() = "new" and
    classNode.getAnImmediateReference().getAMethodCall() = argumentNode
    or
    // parameter from indirect new call
    exists(DataFlow::ExprNode argExpr |
      exprHasType(argExpr, classNode) and
      argumentNode.(DataFlow::CallNode).getATarget() = argExpr
    )
  )
}

private predicate typeModelParameters(string type1, string type2, string path) {
  exists(
    DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode,
    DataFlow::ParameterNode parameterNode
  |
    methodTakesParameterOfType(methodNode, classNode, parameterNode)
  |
    type1 = classNode.getQualifiedName() and
    type2 = getAnAccessPathPrefix(methodNode.asExpr().getExpr()) and
    (
      exists(int paramIdx | paramIdx = parameterNode.getParameter().getPosition() |
        path = "Method[" + getNormalizedMethodName(methodNode) + "].Parameter[" + paramIdx + "]"
      )
      or
      // TODO: verify that this works
      exists(string kwName |
        kwName = parameterNode.getParameter().(Ast::KeywordParameter).getName()
      |
        path = "Method[" + getNormalizedMethodName(methodNode) + "].Parameter[" + kwName + ":]"
      )
      or
      // TODO: verify that this works
      parameterNode.getParameter() instanceof Ast::BlockParameter and
      path = "Method[" + getNormalizedMethodName(methodNode) + "].Parameter[block]"
    )
  )
}

// TODO: non-positional params for block arg parameters
private predicate methodYieldsType(
  DataFlow::CallableNode callableNode, int argIdx, DataFlow::ClassNode classNode
) {
  exprHasType(callableNode.getABlockCall().getArgument(argIdx), classNode)
}

/*
 * e.g. for
 * ```rb
 * class Foo
 *  def initialize
 *    // do some stuff...
 *    if block_given?
 *      yield self
 *    end
 *  end
 *
 *  def do_something
 *    // do something else
 *  end
 * end
 *
 * Foo.new do |foo| foo.do_something end
 * ```
 *
 * the parameter foo to the block is an instance of Foo.
 */

private predicate typeModelBlockArgumentParameters(string type1, string type2, string path) {
  exists(DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode, int argIdx |
    methodYieldsType(methodNode, argIdx, classNode)
  |
    type1 = classNode.getQualifiedName() and
    type2 = getAnAccessPathPrefix(methodNode.asExpr().getExpr()) and
    path =
      "Method[" + getNormalizedMethodName(methodNode) + "].Argument[block].Parameter[" + argIdx +
        "]"
  )
}

query predicate typeModel(string type1, string type2, string path) {
  typeModelReturns(type1, type2, path)
  or
  typeModelParameters(type1, type2, path)
  or
  typeModelBlockArgumentParameters(type1, type2, path)
}
// TODO: path-problem versions of these queries to track how types flow to a particular return node or argument


query predicate sinkModel(string type1, string type2, string path) {
  none()
}

query predicate summaryModel(string type1, string type2, string path) {
  none()
}
