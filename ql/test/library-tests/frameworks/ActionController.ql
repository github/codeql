import codeql_ruby.controlflow.CfgNodes
import codeql_ruby.frameworks.ActionController

query predicate actionControllerControllerClasses(ActionControllerControllerClass cls) { any() }

query predicate actionControllerParamsCalls(ActionControllerParamsCall call) { any() }

query predicate actionControllerParamsSources(ActionControllerParamsSource source) { any() }
