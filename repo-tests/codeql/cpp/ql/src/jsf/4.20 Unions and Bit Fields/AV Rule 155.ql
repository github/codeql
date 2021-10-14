/**
 * @name AV Rule 155
 * @description Bit fields will not be used to pack data into a word for the
 *              sole purpose of saving space.
 * @kind problem
 * @id cpp/jsf/av-rule-155
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

from BitField bf
where
  not bf.getUnderlyingType() instanceof Enum and
  not bf.getDeclaredNumBits() = 0
select bf, "AV Rule 155: Bit fields will not be used purely to save space."
