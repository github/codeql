/**
 * @name Incorrect parameter name in documentation
 * @description The parameter name given in a '<param>' tag does not exist. Rename the parameter or
 *              change the name in the documentation to ensure that they are the same.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/xmldoc/unknown-parameter
 * @tags maintainability
 */

import Documentation

from SourceMethodOrConstructor m, ParamXmlComment comment, string paramName
where
  comment = getADeclarationXmlComment(m) and
  comment.getName(_) = paramName and
  not m.getAParameter().getName() = paramName
select m, "Documentation specifies an invalid parameter name $@.", comment, paramName
