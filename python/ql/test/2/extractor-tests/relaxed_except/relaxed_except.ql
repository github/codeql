/**
 * The types of each `except` clause, and the name it binds. In Python 2 the
 * comma form binds a name and has a single type; reading it as a PEP 758 tuple
 * instead would give two types and no name.
 */

import python

from ExceptStmt handler, string types, string name
where
  types =
    concat(Expr type |
      type = handler.getType()
    |
      type.toString(), ", " order by type.getLocation().getStartColumn()
    ) and
  (
    exists(Name bound | bound = handler.getName() |
      bound.isDefinition() and name = bound.getId() + " (definition)"
      or
      not bound.isDefinition() and name = bound.getId() + " (use)"
    )
    or
    not exists(handler.getName()) and name = "none"
  )
select handler.getLocation().getStartLine(), types, name
