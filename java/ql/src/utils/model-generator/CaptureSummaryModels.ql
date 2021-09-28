/**
 * @name TBD
 * @description TBD
 * @id TBD
 */

import java
import ModelGeneratorUtils
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.internal.DataFlowImplCommon

string captureFlow(Callable api) {
  result = captureQualifierFlow(api) or
  result = captureParameterFlowToReturnValue(api) or
  result = captureFieldFlowIn(api) or
  result = captureParameterToParameterFlow(api) or
  // TODO: merge next two?
  result = captureFieldFlowOut(api) or
  result = captureFieldFlowIntoParam(api)
}

string captureQualifierFlow(Callable api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult() instanceof ThisAccess
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
}

string captureFieldFlowOut(Callable api) {
  exists(FieldAccess fa, ReturnStmt rtn |
    not (fa.getField().isStatic() and fa.getField().isFinal()) and
    rtn.getEnclosingCallable() = api and
    not api.getReturnType() instanceof PrimitiveType and
    not api.getDeclaringType() instanceof EnumType and
    TaintTracking::localTaint(DataFlow::exprNode(fa), DataFlow::exprNode(rtn.getResult()))
  |
    result = asTaintModel(api, "Argument[-1]", "ReturnValue")
  )
}

string captureFieldFlowIntoParam(Callable api) {
  exists(FieldAccess fa, DataFlow::PostUpdateNode pn |
    not (fa.getField().isStatic() and fa.getField().isFinal()) and
    pn.getPreUpdateNode().asExpr() = api.getAParameter().getAnAccess() and
    TaintTracking::localTaint(DataFlow::exprNode(fa), pn)
  |
    result =
      asTaintModel(api, "Argument[-1]",
        parameterAccess(pn.getPreUpdateNode().asExpr().(VarAccess).getVariable()))
  )
}

class FieldAssignment extends AssignExpr {
  FieldAssignment() { exists(Field f | f.getAnAccess() = this.getDest()) }
}

class ParameterToFieldConfig extends TaintTracking::Configuration {
  ParameterToFieldConfig() { this = "ParameterToFieldConfig" }

  override predicate isSource(DataFlow::Node source) {
    not source.asParameter().getType() instanceof PrimitiveType
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FieldAssignment a |
      a.getSource().getAChildExpr() = sink.asExpr() or a.getSource() = sink.asExpr()
    )
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
    exists(Parameter p, Callable api |
      p = source.asParameter() and
      api = p.getCallable() and
      (
        not api.getReturnType() instanceof PrimitiveType and
        not p.getType() instanceof PrimitiveType
      ) and
      (
        not api.getReturnType() instanceof TypeClass and
        not p.getType() instanceof TypeClass
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ReturnNodeExt }
}

// TODO: rtn -> Node as ReturnNodeExt is also PostUpdateNode, might be able to merge with p2p flow
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

// TODO: handle cases like Ticker
// TODO: "com.google.common.base;Converter;true;convertAll;(Iterable);;Element of Argument[0];Element of ReturnValue;taint",
// TODO: infer interface from multiple implementations? e.g. UriComponentsContributor
// TODO: distinguish between taint and value flows. If we find a value flow, omit the taint flow
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
