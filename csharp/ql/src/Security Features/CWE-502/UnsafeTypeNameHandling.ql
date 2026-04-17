/**
 * @name Unsafe TypeNameHandling value
 * @description Checks for when JsonSerializer that also uses an unsafe TypeNameHandling setting
 * @id cs/unsafe-type-name-handling
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.TypeNameHandlingQuery

from
  JsonSerializerSettingsCreation oc, TypeNameHandlingPropertyWrite pw, DataFlow::Node source,
  DataFlow::Node sink
where
  pw = oc.getTypeNameHandlingPropertyWrite() and
  sink = DataFlow::exprNode(pw.getAssignedValue()) and
  UnsafeTypeNameHandlingFlow::flow(source, sink)
select oc.getAssignedBinderType().getAMethod("BindToType"),
  "This is the BindToType() implementation used in $@ with $@. Ensure that it checks the TypeName against an allow or deny list, and returns null or throws an exception when passed an unexpected type", oc, "JsonSerializerSettings",
  pw.getAssignedValue(), "an unsafe TypeNameHandling value"
