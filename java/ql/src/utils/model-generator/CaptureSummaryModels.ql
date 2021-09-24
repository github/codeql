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
  result = captureParameterFlowToReturnValue(api)
}

string captureQualifierFlow(Callable api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult() instanceof ThisAccess
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
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

// TODO: handle cases like Ticker
// TODO: "com.google.common.base;Converter;true;convertAll;(Iterable);;Element of Argument[0];Element of ReturnValue;taint",
// TODO: infer interface from multiple implementations? e.g. UriComponentsContributor
// TODO: distinguish between taint and value flows. If we find a value flow, omit the taint flow
class TargetAPI extends Callable {
  TargetAPI() {
    this.isPublic() and
    this.fromSource() and
    this.getDeclaringType().isPublic() and
    not this.getCompilationUnit().getFile().getAbsolutePath().matches("%src/test/%") and
    not this.getCompilationUnit().getFile().getAbsolutePath().matches("%src/guava-tests/%")
  }
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
