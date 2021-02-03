/**
 * @name Number of Solorigate-related command names in enum is above the threshold
 * @description The enum contains several values that look similar to command and control command names, which may indicate that the code may have been tampered by an external agent.
 *      It is recommended to review the code and verify that there is no unexpected code in this project.
 * @kind problem
 * @tags security
 *       solorigate
 * @problem.severity warning
 * @precision medium
 * @id cs/solorigate/number-of-known-commands-in-enum-above-threshold
 */

import csharp
import Solorigate

from Enum e, int total
where
  total = countSolorigateCommandInEnum(e) and
  total > 10
select e,
  "The enum $@ may be related to Solorigate. It matches " + total +
    " of the values used for commands in the enum.", e, e.getName()
