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
private import AutomodelVsCode

class PublicMethod extends CallableMethod {
  PublicMethod() { this.fromSource() and not this.getFile() instanceof TestFile }
}

from PublicMethod publicMethod, string apiName, boolean supported, string type
where
  apiName = publicMethod.getApiName() and
  supported = isSupported(publicMethod) and
  type = supportedType(publicMethod)
select publicMethod, apiName, supported.toString(), "supported",
  publicMethod.getFile().getBaseName(), "library", type, "type", "unknown", "classification"
