/**
 * @name Fetch endpoints for use in the model editor (framework mode)
 * @description A list of endpoints accessible (methods and attributes) for consumers of the library. Excludes test and generated code.
 * @kind table
 * @id csharp/utils/modeleditor/framework-mode-endpoints
 * @tags modeleditor endpoints framework-mode
 */

import csharp
import FrameworkModeEndpointsQuery
import ModelEditor

from PublicEndpointFromSource endpoint, boolean supported, string type
where
  supported = isSupported(endpoint) and
  type = supportedType(endpoint)
select endpoint, endpoint.getNamespace(), endpoint.getTypeName(), endpoint.getEndpointName(),
  endpoint.getParameterTypes(), supported, endpoint.getFile().getBaseName(), type
