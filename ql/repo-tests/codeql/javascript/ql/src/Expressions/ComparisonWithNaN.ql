/**
 * @name Comparison with NaN
 * @description Arithmetic comparisons with NaN are useless: nothing is considered to be equal to NaN, not even NaN itself,
 *              and similarly nothing is considered greater or less than NaN.
 * @kind problem
 * @problem.severity error
 * @id js/comparison-with-nan
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision very-high
 */

import javascript

from Comparison cmp
where cmp.getAnOperand().(GlobalVarAccess).getName() = "NaN"
select cmp, "Useless comparison with NaN."
