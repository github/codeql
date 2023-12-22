/**
 * @name Fetch endpoints for use in the model editor (framework mode)
 * @description A list of endpoints accessible (methods and attributes) for consumers of the library. Excludes test and generated code.
 * @kind table
 * @id rb/utils/modeleditor/framework-mode-endpoints
 * @tags modeleditor endpoints framework-mode
 */

import ruby
import ModelEditor

from PublicEndpointFromSource endpoint
select endpoint, endpoint.getNamespace(), endpoint.getTypeName(), endpoint.getName(),
  endpoint.getParameterTypes(), endpoint.getSupportedStatus(), endpoint.getFile().getBaseName(),
  endpoint.getSupportedType()
