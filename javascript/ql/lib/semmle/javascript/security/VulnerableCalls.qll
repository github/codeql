/**
 * Provides predicates for finding calls that transitively make a call to a known-vulnerable function.
 */

private import javascript
private import semmle.javascript.security.dataflow.ExternalAPIUsedWithUntrustedDataCustomizations
private import semmle.javascript.frameworks.data.internal.ApiGraphModelsExtensions as Extensions
private import semmle.javascript.frameworks.data.internal.ApiGraphModels as Internal

/**
 * Gets a function in this codebase which reaches a vulnerable call.
 */
Function getAVulnerableFunction(string id) {
  result = ModelOutput::getAVulnerableCall(id).getContainer()
  or
  result = getAVulnerableFunction(id).getEnclosingContainer()
  or
  exists(DataFlow::InvokeNode call |
    getAVulnerableFunction(id) =
      [call.getACallee(), call.getCalleeNode().getABoundFunctionValue(_).getFunction()] and
    result = call.getContainer()
  )
  or
  exists(DataFlow::PartialInvokeNode call, DataFlow::Node callback |
    call.isPartialArgument(callback, _, _) and
    callback.getABoundFunctionValue(_).getFunction() = getAVulnerableFunction(id) and
    result = call.getContainer()
  )
  or
  exists(ReactComponent comp |
    [comp.getInstanceMethod(_), comp.getStaticMethod(_)] = getAVulnerableFunction(id) and
    result = comp.getAComponentCreatorReference().getALocalUse().getContainer()
  )
}

/**
 * Gets an API node corresponding to a function in this codebase which reaches a vulnerable call.
 */
API::Node getAVulnerableFunctionApiNode(string id) {
  exists(DataFlow::Node node, Function func |
    func = getAVulnerableFunction(id) and
    node = result.getAValueReachingSink()
  |
    node.(DataFlow::FunctionNode).getFunction() = func
    or
    node.(DataFlow::PartialInvokeNode).getACallbackNode().getABoundFunctionValue(_).getFunction() =
      func
  )
}

private module ApiGraphExportOptions implements Internal::ApiGraphExportSig {
  API::Node getADirectlyAccessibleNode(string type, string path) {
    result = API::moduleExport(type) and path = ""
  }

  predicate shouldContain(API::Node node) { node = getAVulnerableFunctionApiNode(_) }
}

/**
 * Provides a serialized API graph leading to exported vulnerable functions.
 */
module ExportedVulnerableCalls = Internal::ApiGraphExport<ApiGraphExportOptions>;
