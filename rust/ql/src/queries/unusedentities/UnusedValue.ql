/**
 * @name Unused value
 * @description Unused values may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id rust/unused-value
 * @tags maintainability
 */

select 1, "Variable is assigned a value that is never used."
