/**
 * @name Unsafe TypeNameHandling in Startup
 * @description Using an unsafe TypeNameHandling constant is a security vulnerability.
 * @kind problem
 * @id cs/unsafe-type-name-handling-in-startup
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.TypeNameHandlingQuery

class AddJsonOptionsCall extends MethodCall {
  AddJsonOptionsCall() {
    this.getTarget()
        .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection.NewtonsoftJsonMvcBuilderExtensions",
          "AddNewtonsoftJson") or
    this.getTarget()
        .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection.MvcJsonMvcBuilderExtensions",
          "AddJsonOptions")
  }
}

from
  TypeNameHandlingPropertyWrite pw, AddJsonOptionsCall addJsonOptions,
  DataFlow::Node badTypeNameHandling, DataFlow::Node typeNameHandlingPropertyWrite
where
  addJsonOptions.getEnclosingCallable().hasName("ConfigureServices") and
  addJsonOptions.getAChild*() = pw and
  typeNameHandlingPropertyWrite = DataFlow::exprNode(pw.getAssignedValue()) and
  UnsafeTypeNameHandlingFlow::flow(badTypeNameHandling, typeNameHandlingPropertyWrite) and
  UserInputToDeserializeObjectCallFlow::flow(_, _)
select badTypeNameHandling, "Use of this TypeNameHandling constant in Startup.cs is unsafe"
