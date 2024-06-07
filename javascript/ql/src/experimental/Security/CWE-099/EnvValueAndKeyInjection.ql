/**
 * @name User controlled arbitrary environment variable injection
 * @description creating arbitrary environment variables from user controlled data is not secure
 * @kind path-problem
 * @id js/env-key-and-value-injection
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-089
 */

import javascript
import DataFlow::PathGraph

/** A taint tracking configuration for unsafe environment injection. */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "envInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = keyOfEnv() or
    sink = valueOfEnv()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::InvokeNode ikn |
      ikn = DataFlow::globalVarRef("Object").getAMemberInvocation("keys")
    |
      pred = ikn.getArgument(0) and
      (
        succ = ikn.getAChainedMethodCall(["filter", "map"]) or
        succ = ikn or
        succ = ikn.getAChainedMethodCall("forEach").getABoundCallbackParameter(0, 0)
      )
    )
  }
}

DataFlow::Node keyOfEnv() {
  result =
    NodeJSLib::process().getAPropertyRead("env").getAPropertyWrite().getPropertyNameExpr().flow()
}

DataFlow::Node valueOfEnv() {
  result = API::moduleImport("process").getMember("env").getAMember().asSink()
}

private predicate readToProcessEnv(DataFlow::Node envKey, DataFlow::Node envValue) {
  exists(DataFlow::PropWrite env |
    env = NodeJSLib::process().getAPropertyRead("env").getAPropertyWrite()
  |
    envKey = env.getPropertyNameExpr().flow() and
    envValue = env.getRhs()
  )
}

from
  Configuration cfgForValue, Configuration cfgForKey, DataFlow::PathNode source,
  DataFlow::PathNode envKey, DataFlow::PathNode envValue
where
  cfgForValue.hasFlowPath(source, envKey) and
  envKey.getNode() = keyOfEnv() and
  cfgForKey.hasFlowPath(source, envValue) and
  envValue.getNode() = valueOfEnv() and
  readToProcessEnv(envKey.getNode(), envValue.getNode())
select envKey.getNode(), source, envKey, "arbitrary environment variable assignment from this $@.",
  source.getNode(), "user controllable source"
