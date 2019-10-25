/**
 * @name AV Rule 215
 * @description Pointer arithmetic will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-215
 * @problem.severity warning
 * @tags correctness
 *       language-features
 *       external/jsf
 */

import cpp

from PointerArithmeticOperation pao
where pao.fromSource()
select pao, "AV Rule 215: Pointer arithmetic will not be used."
