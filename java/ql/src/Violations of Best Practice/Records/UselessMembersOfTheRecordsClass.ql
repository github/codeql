/**
 * @id java/useless-members-of-the-records-class
 * @name Useless serialization members of `Records`
 * @description Using certain members of the `Records` class during serialization will result in
 *              those members being ignored.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags quality
 *       reliability
 *       correctness
 */

import java

from Record record, Member m
where
  record.getAMember() = m and
  m.hasName([
      "writeObject", "readObject", "readObjectNoData", "writeExternal", "readExternal",
      "serialPersistentFields"
    ])
select record, "Declaration of useless member $@ found.", m, m.getName()
