/**
 * @name Missing documentation for exception
 * @description Exceptions thrown by the method should be documented using `<exception cref="..."> </exception>` tags.
 *              Ensure that the correct type of the exception is given in the 'cref' attribute.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/xmldoc/missing-exception
 * @tags maintainability
 */

import Documentation
import semmle.code.csharp.commons.QualifiedName

from SourceMethodOrConstructor m, ThrowElement throw, RefType throwType
where
  declarationHasXmlComment(m) and
  m = throw.getEnclosingCallable() and
  throwType = throw.getExpr().getType() and
  not exists(ExceptionXmlComment comment, string exceptionName, RefType throwBaseType |
    comment = getADeclarationXmlComment(m) and
    exceptionName = comment.getCref(_) and
    throwType.getABaseType*() = throwBaseType and
    (
      throwBaseType.hasName(exceptionName)
      or
      exists(string qualifier, string type |
        splitQualifiedName(exceptionName, qualifier, type) and
        throwBaseType.hasFullyQualifiedName(qualifier, type)
      )
      // and comment.hasBody(offset) // Too slow
    )
  ) and
  not getADeclarationXmlComment(m) instanceof InheritDocXmlComment
select m, "Exception $@ should be documented.", throw, throw.getExpr().getType().getName()
