/**
 * @name Framework coverage
 * @description The number of API endpoints covered by CSV models sorted by
 *              package and source-, sink-, and summary-kind.
 * @kind table
 * @id js/meta/framework-coverage
 */

import javascript

from string namespace, int pkgs, string kind, string part, int n
where modelCoverage(namespace, pkgs, kind, part, n)
select namespace, pkgs, kind, part, n
