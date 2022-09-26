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

ClassOrInterface getTaggedType(ThrowsTag tag) {
  result.hasName(tag.getExceptionName()) and
  result = tag.getFile().(CompilationUnit).getATypeInScope()
}

predicate canThrow(Callable callable, Class exception) {
  exception instanceof UncheckedThrowableType
  or
  callable.getAnException().getType().getADescendant() = exception
}

// Uses ClassOrInterface as type for thrownType to also cover case where erroneously an interface
// type is declared as thrown exception
from ThrowsTag throwsTag, ClassOrInterface thrownType, Callable docMethod
where
  getTaggedType(throwsTag) = thrownType and
  docMethod.getDoc().getJavadoc().getAChild*() = throwsTag and
  not canThrow(docMethod, thrownType)
select throwsTag,
  "Javadoc for " + docMethod + " claims to throw " + thrownType.getName() +
    " but this is impossible."
