/**
 * @name Fetch model editor methods (framework mode)
 * @description A list of APIs callable by consumers. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id java/utils/modeleditor/fetch-framework-mode-methods
 * @tags modeleditor fetch methods framework-mode
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
