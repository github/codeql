/**
 * @name Use of assert detected
 * @description Use of assert detected. The enclosed code will be removed 
 * 				when compiling to optimised byte code.
 * 				https://bandit.readthedocs.io/en/latest/plugins/b101_assert_used.html
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity info	
 * @precision medium
 * @id py/bandit-assert
 */

import python

from Assert a
select a, "Use of assert detected. The enclosed code will be removed when compiling to optimised byte code."
