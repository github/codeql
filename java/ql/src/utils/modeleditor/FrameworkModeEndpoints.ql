/**
 * @name Fetch endpoints for use in the model editor (framework mode)
 * @description A list of endpoints accessible (methods) for consumers of the library. Excludes test and generated code.
 * @kind table
 * @id java/utils/modeleditor/framework-mode-endpoints
 * @tags modeleditor endpoints framework-mode
 */

private import java
private import FrameworkModeEndpointsQuery
private import ModelEditor

from PublicEndpointFromSource endpoint, string apiName, boolean supported, string type
where
  apiName = endpoint.getApiName() and
  supported = isSupported(endpoint) and
  type = supportedType(endpoint)
select endpoint, apiName, supported,
  endpoint.getCompilationUnit().getParentContainer().getBaseName(), type
