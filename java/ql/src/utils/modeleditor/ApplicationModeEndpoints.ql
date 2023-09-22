/**
 * @name Fetch endpoints for use in the model editor (application mode)
 * @description A list of 3rd party endpoints (methods) used in the codebase. Excludes test and generated code.
 * @kind table
 * @id java/utils/modeleditor/application-mode-endpoints
 * @tags modeleditor endpoints application-mode
 */

private import java
private import ApplicationModeEndpointsQuery
private import ModelEditor

private Call aUsage(ExternalEndpoint endpoint) {
  result.getCallee().getSourceDeclaration() = endpoint
}

from
  ExternalEndpoint endpoint, string apiName, boolean supported, Call usage, string type,
  string classification
where
  apiName = endpoint.getApiName() and
  supported = isSupported(endpoint) and
  usage = aUsage(endpoint) and
  type = supportedType(endpoint) and
  classification = usageClassification(usage)
select usage, apiName, supported, endpoint.jarContainer(), endpoint.jarVersion(), type,
  classification
