/**
 * @name Sizeof with side effects
 * @description The sizeof operator should not be used on expressions that contain side effects. It is subtle whether the side effects will occur or not.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/sizeof-side-effect
 * @tags reliability
 *       correctness
 *       external/jsf
 */

import cpp
import jsf.lib.section_4_21_Operators.AV_Rule_166

from SizeofImpureExprOperator sz
select sz,
  "A sizeof operator should not be used on expressions that contain side effects as the effect is confusing."
