/**
 * @name Use of database type outside the language core
 * @description Database types should only be used in the language core, abstractions should be used elsewhere.
 * @kind problem
 * @problem.severity warning
 * @id ql/db-type-outside-core
 * @tags maintainability
 * @precision very-high
 */

import ql

/** Gets a folder that may contain raw DB types. */
string folderWithDbTypes() { result = ["lib", "downgrades", "upgrades"] }

from TypeExpr te
where
  te.isDBType() and
  not te.getLocation().getFile().getAbsolutePath().matches("%/" + folderWithDbTypes() + "/%") and
  exists(File f | f.getAbsolutePath().matches("%/lib/%")) and
  // it is needed in one case.
  not te = any(Class c | c.getName() = "SuppressionScope").getASuperType() and
  // QL-for-QL only has a src/ folder.
  not te.getLocation().getFile().getAbsolutePath().matches("%/ql/ql/%") and
  // tests are allowed to use DB types.
  not te.getLocation().getFile().getAbsolutePath().matches("%/test/%")
select te, "Database type used outside the language lib/ folder."
