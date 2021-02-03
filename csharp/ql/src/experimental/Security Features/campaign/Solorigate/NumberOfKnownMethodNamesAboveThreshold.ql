/**
 * @name Number of Solorigate-related method names is above the threshold
 * @description The total number of Solorigate-related method names found in the code is above a threshold, which may indicate that the code may have been tampered by an external agent.
 *      It is recommended to review the code and verify that there is no unexpected code in this project.
 * @kind problem
 * @tags security
 *       solorigate
 * @problem.severity warning
 * @precision medium
 * @id cs/solorigate/number-of-known-method-names-above-threshold
 */

import csharp
import Solorigate

from Method m, int total, int threshold
where
  total = countSolorigateSuspiciousMethodNames() and
  threshold = 50 and // out of ~ 100 known names
  isSolorigateSuspiciousMethodName(m) and
  total > threshold
select m,
  "The method $@ may be related to Solorigate. Total count = " + total + " is above the threshold " +
    threshold + ".", m, m.getName()
