/**
 * @name Fetch endpoints for use in the model editor (application mode)
 * @description A list of 3rd party endpoints (methods and attributes) used in the codebase. Excludes test and generated code.
 * @kind table
 * @id csharp/utils/modeleditor/application-mode-endpoints
 * @tags modeleditor endpoints application-mode
 */

import csharp
import ApplicationModeEndpointsQuery
import ModelEditor

private Call aUsage(ExternalEndpoint api) { result.getTarget().getUnboundDeclaration() = api }

from ExternalEndpoint endpoint, boolean supported, Call usage, string type, string classification
where
  supported = isSupported(endpoint) and
  usage = aUsage(endpoint) and
  type = supportedType(endpoint) and
  classification = methodClassification(usage)
select usage, endpoint.getNamespace(), endpoint.getTypeName(), endpoint.getEndpointName(),
  endpoint.getParameterTypes(), supported, endpoint.dllName(), endpoint.dllVersion(), type,
  classification
