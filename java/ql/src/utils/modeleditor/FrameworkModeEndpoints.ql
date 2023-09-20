/**
 * @name Fetch endpoints for use in the model editor (framework mode)
 * @description A list of endpoints accessible (methods) for consumers of the library. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id java/utils/modeleditor/framework-mode-endpoints
 * @tags modeleditor endpoints framework-mode
 */

private import java
private import semmle.code.java.dataflow.internal.ModelExclusions
private import ModelEditor

class PublicMethodFromSource extends CallableMethod, ModelApi { }

from PublicMethodFromSource publicMethod, string apiName, boolean supported, string type
where
  apiName = publicMethod.getApiName() and
  supported = isSupported(publicMethod) and
  type = supportedType(publicMethod)
select publicMethod, apiName, supported.toString(), "supported",
  publicMethod.getCompilationUnit().getParentContainer().getBaseName(), "library", type, "type",
  "unknown", "classification"
