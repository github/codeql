/**
 * @name Number of Solorigate-related hashes as literals is above the threshold
 * @description The total number of Solorigate-related hash literals found in the code is above a threshold, which may indicate that an external agent has tampered with the code.
 *      It is recommended to review the code and verify that there is no unexpected code in this project, however it is highly unlikely the hash values would be present coincidentally.
 * @kind problem
 * @tags security
 *       solorigate
 * @problem.severity warning
 * @precision medium
 * @id cs/solorigate/number-of-known-hashes-above-threshold
 */

import csharp
import Solorigate

/*
 * Returns the total number of Solorigate-related hashes found in the project
 */

int countSolorigateSuspiciousHash() {
  result =
    count(string s | exists(Literal l | s = l.getValue() and s = solorigateSuspiciousHashes()))
}

from Literal l, int total, int threshold
where
  total = countSolorigateSuspiciousHash() and
  threshold = 5 and // out of ~200 known literals
  isSolorigateHash(l) and
  total > threshold
select l,
  "The Hash literal $@ may be related to the Solorigate campaign. Total count = " + total +
    " is above the threshold " + threshold + ".", l, l.getValue()
