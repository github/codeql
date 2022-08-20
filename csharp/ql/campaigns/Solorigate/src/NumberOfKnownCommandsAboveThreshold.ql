/**
 * @name Number of Solorigate-related command names in enum is above the threshold
 * @description The enum contains several values that look similar to command and control command names, which may indicate that the code may have been tampered with by an external agent.
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

/*
 * Returns the total number of Solorigate-related commands in the given enum
 *
 * This command list is described at https://www.fireeye.com/blog/products-and-services/2020/12/global-intrusion-campaign-leverages-software-supply-chain-compromise.html
 * and the enum names are based from https://github.com/ITAYC0HEN/SUNBURST-Cracked/tree/a01f358965525bee34ad026acd9dfda3d488fdd8
 */

int countSolorigateCommandInEnum(Enum e) {
  result =
    count(string s, EnumConstant ec |
      e.getAnEnumConstant() = ec and
      s = ec.getName() and
      s = solorigateSuspiciousCommandsInEnum()
    )
}

from Enum e, int total
where
  total = countSolorigateCommandInEnum(e) and
  total > 10
select e,
  "The enum $@ may be related to Solorigate. It matches " + total +
    " of the values used for commands in the enum.", e, e.getName()
