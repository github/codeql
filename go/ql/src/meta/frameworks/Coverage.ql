/**
 * @name Framework coverage
 * @description The number of API endpoints covered by MaD models sorted by
 *              package and source-, sink-, and summary-kind.
 * @kind table
 * @id go/meta/framework-coverage
 */

import go
import semmle.go.dataflow.ExternalFlow

from string package, int pkgs, string kind, string part, int n
where modelCoverage(package, pkgs, kind, part, n)
select package, pkgs, kind, part, n
