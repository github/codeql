/**
 * @name Framework coverage
 * @description The number of API endpoints covered by CSV models sorted by
 *              package and source-, sink-, and summary-kind.
 * @kind metric
 * @id java/meta/framework-coverage
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from string package, string kind, string part, int n
where modelCoverage(package, kind, part, n)
select package, kind, part, n
