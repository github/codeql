/**
 * @name Missing documentation for parameter
 * @description All parameters should be documented using '<param name="..."> </param>' tags.
 *              Ensure that the name attribute matches the name of the parameter.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/xmldoc/missing-parameter
 * @tags maintainability
 */

import Documentation

from SourceMethodOrConstructor m, SourceParameter p
where
  p = m.getAParameter() and
  declarationHasXmlComment(m) and
  not exists(ParamXmlComment c, int offset |
    c = getADeclarationXmlComment(m) and
    c.getName(offset) = p.getName() and
    c.hasBody(offset)
  ) and
  not getADeclarationXmlComment(m) instanceof InheritDocXmlComment
select p, "Parameter should be documented."
