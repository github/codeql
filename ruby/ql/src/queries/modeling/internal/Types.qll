private import ruby
private import codeql.ruby.ApiGraphs
private import Util as Util

module Types {
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      // TODO: construction of type values not using a "new" call
      source.(DataFlow::CallNode).getMethodName() = "new"
    }

    predicate isSink(DataFlow::Node sink) { sink = any(DataFlow::MethodNode m).getAReturnNode() }
  }

  private import DataFlow::Global<Config>

  private predicate methodReturnsType(DataFlow::MethodNode methodNode, DataFlow::ClassNode classNode) {
    // ignore cases of initializing instance of self
    not methodNode.getMethodName() = "initialize" and
    exists(DataFlow::CallNode initCall |
      flow(initCall, methodNode.getAReturnNode()) and
      classNode.getAnImmediateReference().getAMethodCall() = initCall and
      // constructed object does not have a type declared in test code
      /*
       * TODO: this may be too restrictive, e.g.
       * - if a type is declared in both production and test code
       * - if a built-in type is extended in test code
       */

      forall(Ast::ModuleBase classDecl | classDecl = classNode.getADeclaration() |
        classDecl.getLocation().getFile() instanceof Util::RelevantFile
      )
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
      methodNode.getLocation().getFile() instanceof Util::RelevantFile and
      methodReturnsType(methodNode, classNode)
    |
      type1 = classNode.getQualifiedName() and
      type2 = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodPath(methodNode) + ".ReturnValue"
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
      methodNode.getLocation().getFile() instanceof Util::RelevantFile and
      methodTakesParameterOfType(methodNode, classNode, parameterNode)
    |
      type1 = classNode.getQualifiedName() and
      type2 = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodParameterPath(methodNode, parameterNode)
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
      methodNode.getLocation().getFile() instanceof Util::RelevantFile and
      methodYieldsType(methodNode, argIdx, classNode)
    |
      type1 = classNode.getQualifiedName() and
      type2 = Util::getAnAccessPathPrefix(methodNode) and
      path = Util::getMethodPath(methodNode) + ".Argument[block].Parameter[" + argIdx + "]"
    )
  }

  predicate typeModel(string type1, string type2, string path) {
    typeModelReturns(type1, type2, path)
    or
    typeModelParameters(type1, type2, path)
    or
    typeModelBlockArgumentParameters(type1, type2, path)
  }
}
