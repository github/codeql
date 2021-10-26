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
import ModelGeneratorUtils

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
  exists(FieldAccess fa, ReturnNodeExt returnNode |
    not (fa.getField().isStatic() and fa.getField().isFinal()) and
    returnNode.getEnclosingCallable() = api and
    fa.getCompilationUnit() = api.getCompilationUnit() and
    isRelevantType(api.getReturnType()) and
    not api.getDeclaringType() instanceof EnumType and
    TaintTracking::localTaint(DataFlow::exprNode(fa), returnNode)
  |
    result = asTaintModel(api, "Argument[-1]", asOutput(api, returnNode))
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
    isRelevantType(source.getType())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FieldAssignment a |
      a.getSource() = sink.asExpr() and
      a.getDest().(VarAccess).getVariable().getCompilationUnit() =
        sink.getEnclosingCallable().getCompilationUnit()
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
    exists(Callable api |
      source instanceof DataFlow::ParameterNode and
      api = source.asParameter().getCallable() and
      isRelevantType(api.getReturnType()) and
      isRelevantType(source.asParameter().getType())
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

predicate isRelevantType(Type t) {
  not t instanceof TypeClass and
  not t instanceof EnumType and
  not t instanceof PrimitiveType and
  not t instanceof BoxedType and
  not t.(RefType).hasQualifiedName("java.math", "BigInteger") and
  not t.(Array).getElementType() instanceof PrimitiveType and
  not t.(Array).getElementType().(PrimitiveType).getName().regexpMatch("byte|char") and
  not t.(Array).getElementType() instanceof BoxedType and
  not t.(CollectionType).getElementType() instanceof BoxedType
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
