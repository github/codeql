/**
 * @name Magic numbers
 * @description 'Magic constants' should be avoided: if a nontrivial constant is used repeatedly, it should be encapsulated into a const variable or macro definition.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/magic-number
 * @tags changeability
 *       maintainability
 */

import csharp
import MagicConstants

predicate selection(Element e, string msg) { magicConstant(e, msg) }

from Literal e, string msg
where
  selection(e, msg) and
  isNumber(e) and
  not exists(Field f | f.getInitializer() = e)
select e, msg
