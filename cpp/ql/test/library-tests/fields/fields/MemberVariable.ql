/**
 * @name MemberVariable
 * @kind table
 */

import cpp

from MemberVariable m, string static
where if m.isStatic() then static = "static" else static = ""
select m, static, m.getASpecifier().toString()
