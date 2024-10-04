/**
 * @name Unused variable
 * @description Unused variables may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id rust/unused-variable
 * @tags maintainability
 */

import rust

from Variable v
where
  not exists(v.getAnAccess()) and
  not exists(v.getInitializer()) and
  not v.getName().charAt(0) = "_" and
  exists(File f | f.getBaseName() = "main.rs" | v.getLocation().getFile() = f) // temporarily severely limit results
select v, "Variable is not used."
