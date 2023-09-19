/**
 * @name Fetch model editor methods (framework mode)
 * @description A list of APIs callable by consumers. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id csharp/utils/modeleditor/fetch-framework-mode-methods
 * @tags modeleditor fetch methods framework-mode
 */

private import csharp
private import dotnet
private import semmle.code.csharp.frameworks.Test
private import ModelEditor

class PublicEndpointFromSource extends Endpoint {
  PublicEndpointFromSource() { this.fromSource() and not this.getFile() instanceof TestFile }
}

from PublicEndpointFromSource endpoint, string apiName, boolean supported, string type
where
  apiName = endpoint.getApiName() and
  supported = isSupported(endpoint) and
  type = supportedType(endpoint)
select endpoint, apiName, supported.toString(), "supported", endpoint.getFile().getBaseName(),
  "library", type, "type", "unknown", "classification"
