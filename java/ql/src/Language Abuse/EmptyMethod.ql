/**
 * @id java/empty-method
 * @name Empty method
 * @description An empty method serves no purpose and makes code less readable. An empty method may
 *              indicate an error on the part of the developer.
 * @kind problem
 * @precision medium
 * @problem.severity recommendation
 * @tags correctness
 *       maintainability
 *       readability
 *       quality
 *       external/cwe/cwe-1071
 */

import java

/**
 * A `Method` from source that is not abstract, and likely not a test method
 */
class NonAbstractSource extends Method {
  NonAbstractSource() {
    this.fromSource() and
    not this.isAbstract() and
    not this instanceof LikelyTestMethod
  }
}

from NonAbstractSource m
where
  //empty
  not exists(m.getBody().getAChild()) and
  //permit comment lines explaining why this is empty
  m.getNumberOfCommentLines() = 0 and
  //permit a javadoc above as well as sufficient reason to leave empty
  not exists(m.getDoc().getJavadoc()) and
  //annotated methods are considered compliant
  not exists(m.getAnAnnotation()) and
  //native methods have no body
  not m.isNative()
select m, "Empty method found."
