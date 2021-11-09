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

/**
 * Capture fluent APIs that return `this`.
 * Example of a fluent API:
 * ```
 * public class Foo {
 *   public Foo someAPI() {
 *    // some side-effect
 *    return this;
 *  }
 * }
 * ```
 */
string captureQualifierFlow(Callable api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult().(ThisAccess).isOwnInstanceAccess()
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
}

/**
 * Capture APIs that return tainted instance data.
 * Example of an API that returns tainted instance data:
 * ```
 * public class Foo {
 *   private String tainted;
 *
 *   public String returnsTainted() {
 *     return tainted;
 *   }
 *
 *   public void putsTaintIntoParameter(List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Model:
 * ```
 * p;Foo;true;returnsTainted;;Argument[-1];ReturnValue;taint
 * p;Foo;true;putsTaintIntoParameter;(List);Argument[-1];Argument[0];taint
 * ```
 */
string captureFieldFlow(Callable api) {
  exists(FieldAccess fa, ReturnNodeExt returnNode |
    not (fa.getField().isStatic() and fa.getField().isFinal()) and
    fa.getField().getDeclaringType() = api.getDeclaringType() and
    returnNode.getEnclosingCallable() = api and
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
      a.getDest().(FieldAccess).getField().getDeclaringType() =
        sink.getEnclosingCallable().getDeclaringType()
    )
  }
}

/**
 * Captures APIs that accept input and store them in a field.
 * Example:
 * ```
 * public class Foo {
 *  private String tainted;
 *  public void doSomething(String input) {
 *    tainted = input;
 *  }
 * ```
 * Captured Model:
 * `p;Foo;true;doSomething;(String);Argument[0];Argument[-1];taint`
 */
string captureFieldFlowIn(Callable api) {
  exists(DataFlow::PathNode source, DataFlow::PathNode sink |
    not api.isStatic() and
    restrictedFlow(source, sink) and
    source.getNode().asParameter().getCallable() = api
  |
    result =
      asTaintModel(api, "Argument[" + source.getNode().asParameter().getPosition() + "]",
        "Argument[-1]")
  )
}

predicate restrictedEdge(DataFlow::PathNode n1, DataFlow::PathNode n2) {
  n1.getASuccessor() = n2 and
  n1.getNode().getEnclosingCallable().getDeclaringType() =
    n2.getNode().getEnclosingCallable().getDeclaringType()
}

predicate restrictedFlow(DataFlow::PathNode src, DataFlow::PathNode sink) {
  src.getConfiguration() instanceof ParameterToFieldConfig and
  src.isSource() and
  src.getConfiguration().isSink(sink.getNode()) and
  restrictedEdge*(src, sink)
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

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr().(ConstructorCall).getAnArgument() = node1.asExpr() and
    node1.asExpr().(Argument).getCall().getCallee().fromSource()
  }
}

predicate paramFlowToReturnValueExists(Parameter p) {
  exists(ParameterToReturnValueTaintConfig config, ReturnStmt rtn |
    rtn.getEnclosingCallable() = p.getCallable() and
    config.hasFlow(DataFlow::parameterNode(p), DataFlow::exprNode(rtn.getResult()))
  )
}

/**
 * Capture APIs that return (parts of) data passed in as a parameter.
 * Example:
 * ```
 * public class Foo {
 *
 *   public String returnData(String tainted) {
 *     return tainted.substring(0,10)
 *   }
 * }
 * ```
 * Captured Model:
 * ```
 * p;Foo;true;returnData;;Argument[0];ReturnValue;taint
 * ```
 */
string captureParameterFlowToReturnValue(Callable api) {
  exists(Parameter p |
    p = api.getAParameter() and
    paramFlowToReturnValueExists(p)
  |
    result = asTaintModel(api, parameterAccess(p), "ReturnValue")
  )
}

/**
 * Capture APIs that pass tainted data from a parameter to a parameter.
 * Example:
 * ```
 * public class Foo {
 *
 *   public void addToList(String tainted, List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Model:
 * ```
 * p;Foo;true;addToList;;Argument[0];Argument[1];taint
 * ```
 */
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
  (
    not t.(Array).getElementType() instanceof PrimitiveType or
    isPrimitiveTypeUsedForBulkData(t.(Array).getElementType())
  ) and
  (
    not t.(Array).getElementType() instanceof BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(Array).getElementType())
  ) and
  (
    not t.(CollectionType).getElementType() instanceof BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(CollectionType).getElementType())
  )
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
