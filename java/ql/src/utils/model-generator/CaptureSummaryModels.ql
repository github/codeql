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
  result = captureThroughFlow(api)
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

class TaintRead extends DataFlow::FlowState {
  TaintRead() { this = "TaintRead" }
}

class TaintStore extends DataFlow::FlowState {
  TaintStore() { this = "TaintStore" }
}

class ThroughFlowConfig extends TaintTracking::Configuration {
  ThroughFlowConfig() { this = "ThroughFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof DataFlow::ParameterNode and
    source.getEnclosingCallable() instanceof TargetAPI and
    state instanceof TaintRead
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof ReturnNodeExt and
    not sink.(ReturnNode).asExpr().(ThisAccess).isOwnInstanceAccess() and
    not exists(captureQualifierFlow(sink.asExpr().getEnclosingCallable())) and
    (state instanceof TaintRead or state instanceof TaintStore)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(TypedContent tc |
      store(node1, tc, node2, _) and
      isRelevantContent(tc.getContent()) and
      (state1 instanceof TaintRead or state1 instanceof TaintStore) and
      state2 instanceof TaintStore
    )
    or
    exists(DataFlow::Content c |
      readStep(node1, c, node2) and
      isRelevantContent(c) and
      state1 instanceof TaintRead and
      state2 instanceof TaintRead
    )
  }

  override predicate isSanitizer(DataFlow::Node n) {
    exists(Type t | t = n.getType() and not isRelevantType(t))
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

/**
 * Capture APIs that transfer taint from an input parameter to an output return
 * value or parameter.
 * Allows a sequence of read steps followed by a sequence of store steps.
 *
 * Examples:
 *
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
 *
 * ```
 * public class Foo {
 *  private String tainted;
 *  public void doSomething(String input) {
 *    tainted = input;
 *  }
 * ```
 * Captured Model:
 * `p;Foo;true;doSomething;(String);Argument[0];Argument[-1];taint`
 *
 * ```
 * public class Foo {
 *   public String returnData(String tainted) {
 *     return tainted.substring(0,10)
 *   }
 * }
 * ```
 * Captured Model:
 * `p;Foo;true;returnData;;Argument[0];ReturnValue;taint`
 *
 * ```
 * public class Foo {
 *   public void addToList(String tainted, List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Model:
 * `p;Foo;true;addToList;;Argument[0];Argument[1];taint`
 */
string captureThroughFlow(TargetAPI api) {
  exists(
    ThroughFlowConfig config, DataFlow::ParameterNode p, ReturnNodeExt returnNodeExt, string input,
    string output
  |
    config.hasFlow(p, returnNodeExt) and
    returnNodeExt.getEnclosingCallable() = api and
    input = parameterNodeAsInput(p) and
    output = returnNodeAsOutput(returnNodeExt) and
    input != output and
    result = asTaintModel(api, input, output)
  )
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
