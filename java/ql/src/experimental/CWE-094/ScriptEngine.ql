/**
 * @name ScriptEngine evaluation
 * @description Malicious Javascript code could cause arbitrary command execution at the OS level
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-eval
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class ScriptEngineMethod extends Method {
  ScriptEngineMethod() {
    this.getDeclaringType().hasQualifiedName("javax.script", "ScriptEngine") and
    this.hasName("eval")
  }
}

predicate scriptEngine(MethodAccess ma, Expr sink) {
  exists(Method m | m = ma.getMethod() |
    m instanceof ScriptEngineMethod and
    sink = ma.getArgument(0)
  )
}

class ScriptEngineSink extends DataFlow::ExprNode {
  ScriptEngineSink() { scriptEngine(_, this.getExpr()) }

  MethodAccess getMethodAccess() { scriptEngine(result, this.getExpr()) }
}

class ScriptEngineConfiguration extends TaintTracking::Configuration {
  ScriptEngineConfiguration() { this = "ScriptEngineConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ScriptEngineSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ScriptEngineConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(ScriptEngineSink).getMethodAccess(), source, sink, "ScriptEngine eval $@.",
  source.getNode(), "user input"
