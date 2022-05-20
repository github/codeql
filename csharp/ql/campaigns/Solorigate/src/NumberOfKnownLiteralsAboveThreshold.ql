/**
 * @name Number of Solorigate-related literals is above the threshold
 * @description The total number of Solorigate-related literals found in the code is above a threshold, which may indicate that an external agent has tampered with the code.
 *      It is recommended to review the code and verify that there is no unexpected code in this project.
 * @kind problem
 * @tags security
 *       solorigate
 * @problem.severity warning
 * @precision medium
 * @id cs/solorigate/number-of-known-literals-above-threshold
 */

import csharp
import Solorigate

/*
 * Returns the total number of Solorigate-related literals found in the project
 */

int countSolorigateSuspiciousLiterals() {
  result =
    count(string s | exists(Literal l | s = l.getValue() and s = solorigateSuspiciousLiterals()))
}

from Literal l, int total, int threshold
where
  total = countSolorigateSuspiciousLiterals() and
  threshold = 30 and // out of ~150 known literals
  isSolorigateLiteral(l) and
  total > threshold
select l,
  "The literal $@ may be related to the Solorigate campaign. Total count = " + total +
    " is above the threshold " + threshold + ".", l, l.getValue()
