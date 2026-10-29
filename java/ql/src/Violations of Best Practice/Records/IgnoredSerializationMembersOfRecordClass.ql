/**
 * @id java/ignored-serialization-member-of-record-class
 * @name Ignored serialization member of record class
 * @description Using certain members of a record class during serialization will result in
 *              those members being ignored.
 * @previous-id java/useless-members-of-the-records-class
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
select m, "Ignored serialization member found in record class $@.", record, record.getName()
