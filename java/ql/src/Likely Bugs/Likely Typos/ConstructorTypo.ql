/**
 * @name Typo in constructor
 * @description A method that has the same name as its declaring type may have been intended to be
 *              a constructor.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/constructor-typo
 * @tags maintainability
 *       readability
 *       naming
 */

import java

from Method m
where
  m.hasName(m.getDeclaringType().getName()) and
  m.fromSource()
select m, "This method has the same name as its declaring class." + " Should it be a constructor?"
