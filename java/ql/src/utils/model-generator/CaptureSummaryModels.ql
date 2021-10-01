/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @id java/utils/model-generator/summary-models
 */

import java
import ModelGeneratorUtils
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowNodes

string captureFlow(Callable api) {
  result = captureQualifierFlow(api) or
  result = captureParameterFlowToReturnValue(api) or
  result = captureFieldFlowIn(api) or
  result = captureParameterToParameterFlow(api) or
  result = captureFieldFlow(api)
}

string captureQualifierFlow(Callable api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult() instanceof ThisAccess
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
}

string captureFieldFlow(Callable api) {
  exists(FieldAccess fa, ReturnNodeExt postUpdate |
    not (fa.getField().isStatic() and fa.getField().isFinal()) and
    postUpdate.getEnclosingCallable() = api and
    not api.getReturnType() instanceof PrimitiveType and
    not api.getDeclaringType() instanceof EnumType and
    TaintTracking::localTaint(DataFlow::exprNode(fa), postUpdate)
  |
    result = asTaintModel(api, "Argument[-1]", asOutput(api, postUpdate))
  )
}

string asOutput(Callable api, ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    result = parameterAccess(api.getParameter(node.getKind().(ParamUpdateReturnKind).getPosition()))
}

class FieldAssignment extends AssignExpr {
  FieldAssignment() { exists(Field f | f.getAnAccess() = this.getDest()) }
}

class ParameterToFieldConfig extends TaintTracking::Configuration {
  ParameterToFieldConfig() { this = "ParameterToFieldConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    not source.getType() instanceof PrimitiveType
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FieldAssignment a | a.getSource() = sink.asExpr())
  }
}

string captureFieldFlowIn(Callable api) {
  exists(DataFlow::ParameterNode source, DataFlow::ExprNode sink, ParameterToFieldConfig config |
    sink.asExpr().getEnclosingCallable().getDeclaringType() =
      source.asParameter().getCallable().getDeclaringType() and
    config.hasFlow(source, sink) and
    source.asParameter().getCallable() = api
  |
    result =
      asTaintModel(api, "Argument[" + source.asParameter().getPosition() + "]", "Argument[-1]")
  )
}

class ParameterToReturnValueTaintConfig extends TaintTracking::Configuration {
  ParameterToReturnValueTaintConfig() { this = "ParameterToReturnValueTaintConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(Callable api |
      source instanceof DataFlow::ParameterNode and
      api = source.asParameter().getCallable() and
      not api.getReturnType() instanceof PrimitiveType and
      not api.getReturnType() instanceof TypeClass and
      not source.asParameter().getType() instanceof PrimitiveType and
      not source.asParameter().getType() instanceof TypeClass
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ReturnNodeExt }
}

predicate paramFlowToReturnValueExists(Parameter p) {
  exists(ParameterToReturnValueTaintConfig config, ReturnStmt rtn |
    rtn.getEnclosingCallable() = p.getCallable() and
    config.hasFlow(DataFlow::parameterNode(p), DataFlow::exprNode(rtn.getResult()))
  )
}

string captureParameterFlowToReturnValue(Callable api) {
  exists(Parameter p |
    p = api.getAParameter() and
    paramFlowToReturnValueExists(p)
  |
    result = asTaintModel(api, parameterAccess(p), "ReturnValue")
  )
}

string captureParameterToParameterFlow(Callable api) {
  exists(DataFlow::ParameterNode source, DataFlow::PostUpdateNode sink |
    source.getEnclosingCallable() = api and
    sink.getPreUpdateNode().asExpr() = api.getAParameter().getAnAccess() and
    TaintTracking::localTaint(source, sink)
  |
    result =
      asTaintModel(api, parameterAccess(source.asParameter()),
        parameterAccess(sink.getPreUpdateNode().asExpr().(VarAccess).getVariable().(Parameter)))
  )
}

// TODO: "com.google.common.base;Converter;true;convertAll;(Iterable);;Element of Argument[0];Element of ReturnValue;taint",
// TODO: infer interface from multiple implementations? e.g. UriComponentsContributor
// TODO: distinguish between taint and value flows. If we find a value flow, omit the taint flow
// TODO: merge param->return value with param->parameter flow?
class TargetAPI extends Callable {
  TargetAPI() {
    this.isPublic() and
    this.fromSource() and
    this.getDeclaringType().isPublic() and
    not isInTestFile(this)
  }
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
