/**
 * @name Comparison of user-controlled data of different kinds
 * @description Comparing different kinds of HTTP request data may be a symptom of an insufficient security check.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id js/different-kinds-comparison-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import javascript
import semmle.javascript.security.dataflow.DifferentKindsComparisonBypass::DifferentKindsComparisonBypass

from DifferentKindsComparison cmp, DataFlow::Node lSource, DataFlow::Node rSource
where
  lSource = cmp.getLSource() and
  rSource = cmp.getRSource() and
  // Standard names for the double submit cookie pattern (CSRF protection)
  not exists(DataFlow::PropRead s | s = lSource or s = rSource |
    s.getPropertyName().regexpMatch("(?i).*(csrf|state|token).*")
  )
select cmp,
  "This comparison of $@ and $@ is a potential security risk since it is controlled by the user.",
  lSource, lSource.toString(), rSource, rSource.toString()
