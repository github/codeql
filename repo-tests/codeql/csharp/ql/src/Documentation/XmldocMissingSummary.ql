/**
 * @name Missing a summary in documentation comment
 * @description The documentation comment does not contain a '<summary>' tag.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/xmldoc/missing-summary
 * @tags maintainability
 */

import Documentation

from Declaration decl
where
  declarationHasXmlComment(decl) and
  isDocumentationNeeded(decl) and
  forall(SummaryXmlComment c | c = getADeclarationXmlComment(decl) |
    forall(int offset | c.isOpenTag(offset) | c.isEmptyTag(offset))
  ) and
  not getADeclarationXmlComment(decl) instanceof InheritDocXmlComment
select decl, "Documentation should have a summary."
