/**
 * @name Multiple imports on one line
 * @description Defining multiple imports on one line makes code more difficult to read;
 *              PEP8 states that imports should usually be on separate lines.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @deprecated
 * @precision medium
 * @id py/multiple-imports-on-line
 */

/*
 * Look for imports of the form:
 * import modA, modB
 * (Imports should be one per line according PEP 8)
 */

import python

predicate multiple_import(Import imp) { count(imp.getAName()) > 1 and not imp.isFromImport() }

from Import i
where multiple_import(i)
select i, "Multiple imports on one line."
