/**
 * @name Deprecated method or constructor invocation
 * @description Using a method or constructor that has been marked as deprecated may be dangerous or
 *              fail to take advantage of a better method or constructor.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/deprecated-call
 * @tags maintainability
 *       non-attributable
 *       external/cwe/cwe-477
 */

import java

private predicate isDeprecatedCallable(Callable c) {
  c.getAnAnnotation() instanceof DeprecatedAnnotation or
  exists(c.getDoc().getJavadoc().getATag("@deprecated"))
}

from Call ca, Callable c
where
  ca.getCallee() = c and
  isDeprecatedCallable(c) and
  // Exclude deprecated calls from within deprecated code.
  not isDeprecatedCallable(ca.getCaller())
select ca, "Invoking $@ should be avoided because it has been deprecated.", c,
  c.getDeclaringType() + "." + c.getName()
