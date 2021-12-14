/**
 * @name Missing documentation for type parameter
 * @description All type parameters should be documented using '<typeparam name="..."> </typeparam>' tags.
 *              Ensure that the 'name' attribute matches the name of the type parameter.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/xmldoc/missing-type-parameter
 * @tags maintainability
 */

import Documentation

from UnboundGeneric d, TypeParameter p
where
  p = d.getATypeParameter() and
  declarationHasXmlComment(d) and
  not exists(TypeparamXmlComment comment, int offset |
    comment = getADeclarationXmlComment(d) and
    comment.getName(offset) = p.getName() and
    comment.hasBody(offset)
  ) and
  not getADeclarationXmlComment(d) instanceof InheritDocXmlComment
select p, "Type parameter should be documented."
