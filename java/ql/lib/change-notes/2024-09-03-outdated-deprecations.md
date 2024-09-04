---
category: breaking
---
* Deleted the deprecated `ProcessBuilderConstructor`, `MethodProcessBuilderCommand`, and `MethodRuntimeExec` from `JDK.qll`. 
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted the deprecated `getURI` predicate from `CamelJavaDslToDecl` and `SpringCamelXmlToElement`, use `getUri` instead.
* Deleted the deprecated `ExecCallable` class from `ExternalProcess.qll`.
* Deleted many deprecated dataflow configurations based on `DataFlow::Configuration`. 
* Deleted the deprecated `PathCreation.qll` file.
* Deleted the deprecated `WebviewDubuggingEnabledQuery.qll` file.
