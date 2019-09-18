/**
 * @name Missing documentation for return value
 * @description The method returns a value, but the return value is not documented using
 *              a '<returns>' tag.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/xmldoc/missing-return
 * @tags maintainability
 */

import Documentation

from SourceMethod m
where
  declarationHasXmlComment(m) and
  forall(ReturnsXmlComment c | c = getADeclarationXmlComment(m) |
    forall(int offset | c.isOpenTag(offset) | c.isEmptyTag(offset))
  ) and
  not m.getReturnType() instanceof VoidType and
  not getADeclarationXmlComment(m) instanceof InheritDocXmlComment
select m, "Return value should be documented."
