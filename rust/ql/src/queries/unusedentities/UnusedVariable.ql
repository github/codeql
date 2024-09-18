/**
 * @name Unused variable
 * @description Unused variables may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id rust/unused-variable
 * @tags maintainability
 */

import rust

from Locatable e
where none() // TODO: implement query
select e, "Variable is not used."
