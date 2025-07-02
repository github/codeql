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

/** A taint tracking configuration for unsafe environment injection. */
module EnvValueAndKeyInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink = keyOfEnv() or
    sink = valueOfEnv()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::InvokeNode ikn |
      ikn = DataFlow::globalVarRef("Object").getAMemberInvocation("keys")
    |
      node1 = ikn.getArgument(0) and
      (
        node2 = ikn.getAChainedMethodCall(["filter", "map"]) or
        node2 = ikn or
        node2 = ikn.getAChainedMethodCall("forEach").getABoundCallbackParameter(0, 0)
      )
    )
  }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 66 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/Security/CWE-099/EnvValueAndKeyInjection.ql@69:8:69:23)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 66 (/Users/d10c/src/semmle-code/ql/javascript/ql/src/experimental/Security/CWE-099/EnvValueAndKeyInjection.ql@69:8:69:23)
  }
}

module EnvValueAndKeyInjectionFlow = TaintTracking::Global<EnvValueAndKeyInjectionConfig>;

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

import EnvValueAndKeyInjectionFlow::PathGraph

from
  EnvValueAndKeyInjectionFlow::PathNode source, EnvValueAndKeyInjectionFlow::PathNode envKey,
  EnvValueAndKeyInjectionFlow::PathNode envValue
where
  EnvValueAndKeyInjectionFlow::flowPath(source, envKey) and
  envKey.getNode() = keyOfEnv() and
  EnvValueAndKeyInjectionFlow::flowPath(source, envValue) and
  envValue.getNode() = valueOfEnv() and
  readToProcessEnv(envKey.getNode(), envValue.getNode())
select envKey.getNode(), source, envKey, "arbitrary environment variable assignment from this $@.",
  source.getNode(), "user controllable source"
