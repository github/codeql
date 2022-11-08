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

private string getNameSplitter() { result = "(.*)\\.([^\\.]+)$" }

bindingset[name]
private predicate splitExceptionName(string name, string namespace, string type) {
  namespace = name.regexpCapture(getNameSplitter(), 1) and
  type = name.regexpCapture(getNameSplitter(), 2)
}

from SourceMethodOrConstructor m, ThrowElement throw, RefType throwType
where
  declarationHasXmlComment(m) and
  m = throw.getEnclosingCallable() and
  throwType = throw.getExpr().getType() and
  not exists(ExceptionXmlComment comment, int offset, string exceptionName, RefType throwBaseType |
    comment = getADeclarationXmlComment(m) and
    exceptionName = comment.getCref(offset) and
    throwType.getABaseType*() = throwBaseType and
    (
      throwBaseType.hasName(exceptionName)
      or
      exists(string namespace, string type |
        splitExceptionName(exceptionName, namespace, type) and
        throwBaseType.hasQualifiedName(namespace, type)
      )
      // and comment.hasBody(offset) // Too slow
    )
  ) and
  not getADeclarationXmlComment(m) instanceof InheritDocXmlComment
select m, "Exception $@ should be documented.", throw, throw.getExpr().getType().getName()
