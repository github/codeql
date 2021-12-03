/**
 * @name Formatted object is not a mapping
 * @description The formatted object must be a mapping when the format includes a named specifier; otherwise a TypeError will be raised."
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/percent-format/not-mapping
 */

import python
import semmle.python.strings

from Expr e, ClassValue t
where
  exists(BinaryExpr b |
    b.getOp() instanceof Mod and
    format_string(b.getLeft()) and
    e = b.getRight() and
    mapping_format(b.getLeft()) and
    e.pointsTo().getClass() = t and
    not t.isMapping()
  )
select e, "Right hand side of a % operator must be a mapping, not class $@.", t, t.getName()
