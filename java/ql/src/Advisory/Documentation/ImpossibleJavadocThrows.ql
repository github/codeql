/**
 * @name Javadoc has impossible 'throws' tag
 * @description Javadoc that incorrectly claims a method or constructor can throw an exception
 *              is misleading.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/inconsistent-javadoc-throws
 * @tags maintainability
 */

import java

RefType getTaggedType(ThrowsTag tag) {
  result.hasName(tag.getExceptionName()) and
  exists(ImportType i | i.getFile() = tag.getFile() | i.getImportedType() = result)
}

predicate canThrow(Callable callable, RefType exception) {
  exists(string uncheckedException |
    uncheckedException = "RuntimeException" or uncheckedException = "Error"
  |
    exception.getAnAncestor().hasQualifiedName("java.lang", uncheckedException)
  )
  or
  callable.getAnException().getType().getADescendant() = exception
}

from ThrowsTag throwsTag, RefType thrownType, Callable docMethod
where
  getTaggedType(throwsTag) = thrownType and
  docMethod.getDoc().getJavadoc().getAChild*() = throwsTag and
  not canThrow(docMethod, thrownType)
select throwsTag,
  "Javadoc for " + docMethod + " claims to throw " + thrownType.getName() +
    " but this is impossible."
