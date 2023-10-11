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

from PublicEndpointFromSource endpoint, boolean supported, string type
where
  supported = isSupported(endpoint) and
  type = supportedType(endpoint)
select endpoint, endpoint.getPackageName(), endpoint.getTypeName(), endpoint.getName(),
  endpoint.getParameterTypes(), supported,
  endpoint.getCompilationUnit().getParentContainer().getBaseName(), type
