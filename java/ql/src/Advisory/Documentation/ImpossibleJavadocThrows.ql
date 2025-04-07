/**
 * @name Javadoc has impossible 'throws' tag
 * @description Javadoc that incorrectly claims a method or constructor can throw an exception
 *              is misleading.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/inconsistent-javadoc-throws
 * @suites security-and-quality
 * @tags maintainability
 */

import java

RefType getTaggedType(ThrowsTag tag) {
  result.hasName(tag.getExceptionName()) and
  exists(ImportType i | i.getFile() = tag.getFile() | i.getImportedType() = result)
}

// Uses ClassOrInterface as type for thrownType to also cover case where erroneously an interface
// type is declared as thrown exception
from ThrowsTag throwsTag, ClassOrInterface thrownType, Callable docMethod
where
  getTaggedType(throwsTag) = thrownType and
  docMethod.getDoc().getJavadoc().getAChild*() = throwsTag and
  not thrownType instanceof UncheckedThrowableType and
  not docMethod.getAnException().getType().getADescendant() = thrownType
select throwsTag,
  "Javadoc for " + docMethod + " claims to throw " + thrownType.getName() +
    " but this is impossible."
