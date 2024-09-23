/**
 * @name Unused value
 * @description Unused values may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id rust/unused-value
 * @tags maintainability
 */

import rust

from Locatable e
where none() // TODO: implement query
select e, "Variable is assigned a value that is never used."
