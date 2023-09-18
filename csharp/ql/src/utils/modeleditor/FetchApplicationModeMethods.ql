/**
 * @name Fetch model editor methods (application mode)
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id csharp/utils/modeleditor/fetch-application-mode-methods
 * @tags modeleditor fetch methods application-mode
 */

private import csharp
private import ModelEditor

class ExternalEndpoint extends Endpoint {
  ExternalEndpoint() {
    this.isUnboundDeclaration() and
    this.fromLibrary()
  }
}

private Call aUsage(ExternalEndpoint api) { result.getTarget().getUnboundDeclaration() = api }

from
  ExternalEndpoint endpoint, string apiName, boolean supported, Call usage, string type,
  string classification
where
  apiName = endpoint.getApiName() and
  supported = isSupported(endpoint) and
  usage = aUsage(endpoint) and
  type = supportedType(endpoint) and
  classification = methodClassification(usage)
select usage, apiName, supported.toString(), "supported", endpoint.dllName(), endpoint.dllVersion(),
  type, "type", classification, "classification"
