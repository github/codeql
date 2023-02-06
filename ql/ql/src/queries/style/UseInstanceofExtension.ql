/**
 * @name Suggest using non-extending subtype relationships.
 * @description Non-extending subtypes ("instanceof extensions") are generally preferable to instanceof expressions in characteristic predicates.
 * @kind problem
 * @problem.severity warning
 * @id ql/suggest-instanceof-extension
 * @tags maintainability
 * @precision medium
 */

import ql
import codeql_ql.style.UseInstanceofExtensionQuery

from Class c, Type type, string message
where
  (
    instanceofThisInCharPred(c, type) or
    usesFieldBasedInstanceof(c, type, _, _)
  ) and
  message = "Consider defining this class as non-extending subtype of $@."
select c, message, type.getDeclaration(), type.getName()
