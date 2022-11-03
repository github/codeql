/**
 * @name Incorrect type parameter name in documentation
 * @description The type parameter name given in a '<typeparam>' tag does not exist. Rename the parameter or
 *              change the name in the documentation to ensure that they are the same.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/xmldoc/unknown-type-parameter
 * @tags maintainability
 */

import Documentation

from UnboundGeneric d, TypeparamXmlComment comment, string paramName
where
  comment = getADeclarationXmlComment(d) and
  comment.getName(_) = paramName and
  not d.getATypeParameter().getName() = paramName
select d, "Documentation specifies an invalid type parameter name $@.", comment, paramName
