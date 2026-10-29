/**
 * @name Magic strings
 * @description 'Magic constants' should be avoided: if a nontrivial constant is used repeatedly, it should be encapsulated into a const variable or macro definition.
 * @kind problem
 * @id cpp/magic-string
 * @problem.severity recommendation
 * @precision medium
 * @tags maintainability
 *       statistical
 *       non-attributable
 */

import cpp
import MagicConstants

pragma[noopt]
predicate selection(Element e, string msg) { magicConstant(e, msg) and stringLiteral(e) }

from Literal e, string msg
where selection(e, msg)
select e, msg
