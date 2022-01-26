/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @id java/utils/model-generator/summary-models
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowNodes
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.InstanceAccess
import ModelGeneratorUtils

string captureFlow(TargetAPI api) {
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
string captureQualifierFlow(TargetAPI api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult().(ThisAccess).isOwnInstanceAccess()
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
}

class FieldToReturnConfig extends TaintTracking::Configuration {
  FieldToReturnConfig() { this = "FieldToReturnConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::InstanceParameterNode
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof ReturnNodeExt and
    not sink.(ReturnNode).asExpr().(ThisAccess).isOwnInstanceAccess() and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable()))
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    isRelevantTaintStep(node1, node2)
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
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
string captureFieldFlow(TargetAPI api) {
  exists(FieldToReturnConfig config, ReturnNodeExt returnNodeExt |
    config.hasFlow(_, returnNodeExt) and
    returnNodeExt.getEnclosingCallable() = api and
    not api.getDeclaringType() instanceof EnumType and
    isRelevantType(returnNodeExt.getType())
  |
    result = asTaintModel(api, "Argument[-1]", returnNodeAsOutput(api, returnNodeExt))
  )
}

class ParameterToFieldConfig extends TaintTracking::Configuration {
  ParameterToFieldConfig() { this = "ParameterToFieldConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    isRelevantType(source.getType())
  }

  override predicate isSink(DataFlow::Node sink) {
    thisAccess(sink.(DataFlow::PostUpdateNode).getPreUpdateNode())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    store(node1, _, node2, _)
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

private predicate thisAccess(DataFlow::Node n) {
  n.asExpr().(InstanceAccess).isOwnInstanceAccess()
  or
  n.(DataFlow::ImplicitInstanceAccess).getInstanceAccess() instanceof OwnInstanceAccess
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
string captureFieldFlowIn(TargetAPI api) {
  exists(DataFlow::Node source, ParameterToFieldConfig config |
    config.hasFlow(source, _) and
    source.asParameter().getCallable() = api
  |
    result =
      asTaintModel(api, "Argument[" + source.asParameter().getPosition() + "]", "Argument[-1]")
  )
}

class ParameterToReturnValueTaintConfig extends TaintTracking::Configuration {
  ParameterToReturnValueTaintConfig() { this = "ParameterToReturnValueTaintConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(TargetAPI api |
      api = source.asParameter().getCallable() and
      isRelevantType(api.getReturnType()) and
      isRelevantType(source.asParameter().getType())
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ReturnNode }

  // consider store steps to track taint across objects to model factory methods returning tainted objects
  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    store(node1, _, node2, _)
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

predicate paramFlowToReturnValueExists(Parameter p) {
  exists(ParameterToReturnValueTaintConfig config, ReturnStmt rtn |
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
string captureParameterFlowToReturnValue(TargetAPI api) {
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
string captureParameterToParameterFlow(TargetAPI api) {
  exists(DataFlow::ParameterNode source, DataFlow::PostUpdateNode sink |
    source.getEnclosingCallable() = api and
    sink.getPreUpdateNode().asExpr() = api.getAParameter().getAnAccess() and
    TaintTracking::localTaint(source, sink)
  |
    result =
      asTaintModel(api, parameterAccess(source.asParameter()),
        parameterAccess(sink.getPreUpdateNode().asExpr().(VarAccess).getVariable()))
  )
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
