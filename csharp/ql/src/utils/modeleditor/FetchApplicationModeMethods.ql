/**
 * @name Fetch model editor methods (application mode)
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id csharp/utils/modeleditor/fetch-application-mode-methods
 * @tags modeleditor fetch methods application-mode
 */

private import csharp
private import AutomodelVsCode

class ExternalApi extends CallableMethod {
  ExternalApi() {
    this.isUnboundDeclaration() and
    this.fromLibrary()
  }
}

private Call aUsage(ExternalApi api) { result.getTarget().getUnboundDeclaration() = api }

from
  ExternalApi api, string apiName, boolean supported, Call usage, string type, string classification
where
  apiName = api.getApiName() and
  supported = isSupported(api) and
  usage = aUsage(api) and
  type = supportedType(api) and
  classification = methodClassification(usage)
select usage, apiName, supported.toString(), "supported", api.dllName(), api.dllVersion(), type,
  "type", classification, "classification"
