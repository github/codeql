/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import codeql.util.Unit
private import python as P
// DataFlow
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowImpl
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.dataflow.new.internal.DataFlowImplSpecific
private import semmle.python.dataflow.new.internal.TaintTrackingImplSpecific
// ApiGraph
private import semmle.python.frameworks.data.internal.ApiGraphModels as ExternalFlow
private import semmle.python.dataflow.new.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl
private import modeling.ModelEditor

module ModelGeneratorInput implements ModelGeneratorInputSig<P::Location, PythonDataFlow> {
  class Type = Unit; // P::Type ?

  class Parameter = DataFlow::ParameterNode;

  // class Callable = Callable;
  class Callable instanceof DataFlowCallable {
    string toString() { result = super.toString() }
  }

  class NodeExtended extends DataFlow::Node {
    Callable getAsExprEnclosingCallable() { result = this.getEnclosingCallable() }

    Type getType() { any() }

    override Callable getEnclosingCallable() { result = super.getEnclosingCallable() }

    // override Callable getEnclosingCallable() {
    //   result = this.(DataFlow::Node).getEnclosingCallable().(DataFlowFunction).getScope()
    //   // result = this.(DataFlow::Node).getEnclosingCallable().(DataFlowFunction).getScope()
    //   // exists(P::Function func |
    //   //   func.getScope() = this.(DataFlow::Node).getEnclosingCallable().getScope()
    //   // | 
    //   //   result = func
    //   // )
    // }

    Parameter asParameter() { result = this }
  }

  private predicate relevant(Callable api) { any() }

  predicate isUninterestingForDataFlowModels(Callable api) { none() }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) { none() }

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi { }

  class SourceTargetApi extends SourceOrSinkTargetApi { }

  class SummaryTargetApi extends Callable {
    private Callable lift;

    SummaryTargetApi() {
      lift = this and
      relevant(this)
    }

    Callable lift() { result = lift }

    predicate isRelevant() { relevant(this) }
  }

  // /**
  //  * `
  //  */
  // private predicate qualifiedName(Callable c, string package, string type) {
  //   result = c.
  // }

  predicate isRelevantType(Type t) { any() }

  Type getUnderlyingContentType(DataFlow::ContentSet c) { result = any(Type t) and exists(c) }

  string qualifierString() { result = "Argument[this]" }

  string parameterAccess(Parameter p) {
    // TODO: Implement this to support named parameters
    result = "Argument[" + p.getPosition().toString() + "]"
    // result = "param[]"
  }

  string parameterContentAccess(Parameter p) { result = "Argument[]" }

  class InstanceParameterNode extends DataFlow::ParameterNode {
    InstanceParameterNode() { this.getParameter().isSelf() }
  }

  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, ParameterPosition pos) {
    result = parameterAccess(c.(DataFlowCallable).getParameter(pos))
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
    result = parameterContentAccess(c.(DataFlowCallable).getParameter(pos))
    or
    pos.isSelf() and result = qualifierString()
  }

  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    // TODO
    result = DataFlowImplCommon::getNodeEnclosingCallable(ret)
  }

  predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) { none() }

  predicate sinkModelSanitizer(DataFlow::Node node) { none() }

  predicate apiSource(DataFlow::Node source) { none() }

  predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

  string getInputArgument(DataFlow::Node source) { result = "getInputArgument(" + source + ")" }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) {
    not kind = "log-injection" and
    not kind.matches("regex-use%") and
    not kind = "file-content-store"
  }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  predicate containerContent(DataFlow::ContentSet c) {
    // TODO
    any()
  }

  predicate isAdditionalContentFlowStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  predicate isField(DataFlow::ContentSet c) { any() }

  predicate isCallback(DataFlow::ContentSet c) { none() }

  string getSyntheticName(DataFlow::ContentSet c) { none() }

  string printContent(DataFlow::ContentSet c) {
    // TODO
    result = "Memeber[]"
    // exists(Parameter param |
    //   param = c.(Public::ParameterNode).getParameter()
    //   |
    //   result = "Member[" + param.getName() + "]"
    //   )
    // exists(string name, string arg |
    //   name = "Member" and
    //   if arg = "" then result = name else result = "Memeber[" + arg + "]"
    // )
  }

  /**
   * - ["argparse.ArgumentParser", "Member[_parse_known_args,_read_args_from_files]", "Argument[0,arg_strings:]", "ReturnValue", "taint"]
   */
  string partialModelRow(Callable api, int i) {
    exists(Endpoint e | e = api.(DataFlowFunction).getScope() | 
      i = 0 and result = e.getNamespace()
      or
      i = 1 and result = e.getClass()
      or
      i = 2 and result = e.getFunctionName()
      or
      i = 3 and result = e.getParameters()
    
    )
    //  and
    // // i = 0 and qualifiedName(api, result, _) // package[.Class]
    // i = 0 and result = api.(DataFlowCallable)
    // or
    // i = 1 and result = "1" // name
    // or
    // i = 2 and
    // result = "2"
    // TODO
    // exists(Parameter p | p = api.getArg(_) | result = "Member[" + p.getName() + "]") // parameters
  }

  string partialNeutralModelRow(Callable api, int i) { result = partialModelRow(api, i) }

  // TODO: Implement this when we want to generate sources.
  predicate sourceNode(DataFlow::Node node, string kind) { none() }

  // TODO: Implement this when we want to generate sinks.
  predicate sinkNode(DataFlow::Node node, string kind) { none() }
}

import MakeModelGenerator<P::Location, PythonDataFlow, PythonTaintTracking, ModelGeneratorInput>
