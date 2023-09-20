/**
 * @name Fetch endpoints for use in the model editor (application mode)
 * @description A list of 3rd party endpoints (methods) used in the codebase. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id java/utils/modeleditor/application-mode-endpoints
 * @tags modeleditor endpoints application-mode
 */

private import java
private import ModelEditor

class ExternalApi extends CallableMethod {
  ExternalApi() { not this.fromSource() }
}

private Call aUsage(ExternalApi api) { result.getCallee().getSourceDeclaration() = api }

from
  ExternalApi externalApi, string apiName, boolean supported, Call usage, string type,
  string classification
where
  apiName = externalApi.getApiName() and
  supported = isSupported(externalApi) and
  usage = aUsage(externalApi) and
  type = supportedType(externalApi) and
  classification = methodClassification(usage)
select usage, apiName, supported.toString(), "supported", externalApi.jarContainer(),
  externalApi.jarVersion(), type, "type", classification, "classification"
