/**
 * @name Ratio of jump-to-definitions computed
 */

import python
import DefinitionTracking

predicate want_to_have_definition(Expr e) {
  /* not builtin object like len, tuple, etc. */
  not exists(Value builtin | e.pointsTo(builtin) and builtin.isBuiltin()) and
  (
    e instanceof Name and e.(Name).getCtx() instanceof Load
    or
    e instanceof Attribute and e.(Attribute).getCtx() instanceof Load
    or
    e instanceof ImportMember
    or
    e instanceof ImportExpr
  )
}

from int yes, int no
where
  yes = count(Expr e | want_to_have_definition(e) and exists(getUniqueDefinition(e))) and
  no = count(Expr e | want_to_have_definition(e) and not exists(getUniqueDefinition(e)))
select yes, no, yes * 100 / (yes + no) + "%"
