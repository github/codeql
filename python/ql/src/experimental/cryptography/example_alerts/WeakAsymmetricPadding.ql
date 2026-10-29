/**
 * @name Weak or unknown asymmetric padding
 * @description
 * @id py/weak-asymmetric-padding
 * @kind problem
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts

from AsymmetricPadding pad, string name
where
  name = pad.getPaddingName() and
  not name = ["OAEP", "KEM", "PSS"]
select pad, "Use of unapproved, weak, or unknown asymmetric padding algorithm or API: " + name
