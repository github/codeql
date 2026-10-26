/**
 * @name Magic strings
 * @description 'Magic constants' should be avoided: if a nontrivial constant is used repeatedly, it should be encapsulated into a const variable or macro definition.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/magic-string
 * @tags changeability
 *       maintainability
 */

import MagicConstants

predicate selection(Element e, string msg) { magicConstant(e, msg) }

from StringLiteral e, string msg
where selection(e, msg)
select e, msg
