/**
 * @name Padding Consistency Check
 * @description Performs consistency checks for the padding library. This query should have no results.
 * @kind table
 * @id cpp/padding-consistency-check
 */

import Padding

/*
 * Consistency-check: Find discrepancies between computed and actual size on LP64.
 */

/*
 * from Type t, LP64 a, int padded, int bit, int real, MemberVariable v
 * where padded = a.paddedSize(t) and bit = a.bitSize(t)
 * and real = t.getSize() * 8 and padded != real and count(t.getSize()) = 1
 * select t, a.paddedSize(t) as Padded, real, v, t.(PaddedType).memberSize(v, a)
 */

/*
 * from PaddedType t, LP64 a, MemberVariable v
 * where t instanceof Union and v = t.getAMember() and not exists(t.memberSize(v, a))
 * select t, v, v.getType().explain()
 */

/*
 * from PaddedType t, LP64 a, MemberVariable v
 * where not exists(a.paddedSize(t))
 * select t, t.fieldIndex(v) as i, v, t.memberSize(v, a) order by t, i
 */

from PaddedType t, LP64 a
where a.wastedSpace(t) != 0
select t, a.paddedSize(t) as size, a.wastedSpace(t) as waste order by waste desc
