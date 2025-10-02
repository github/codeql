/**
 * @name Typo in hashCode
 * @description A method named 'hashcode' may be intended to be named 'hashCode'.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/hashcode-typo
 * @tags quality
 *       reliability
 *       correctness
 *       readability
 */

import java

from Method m
where
  m.hasName("hashcode") and
  m.hasNoParameters() and
  m.fromSource()
select m, "Should this method be called 'hashCode' rather than 'hashcode'?"
