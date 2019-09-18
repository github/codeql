/**
 * @name AV Rule 29
 * @description The #define pre-processor directive shall not be used to create inline macros. Inline functions shall be used instead.
 * @kind problem
 * @id cpp/jsf/av-rule-29
 * @problem.severity error
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Macro m
where m.getHead().matches("%(%") // Macro functions are simply macros with brackets in the head
select m, "The #define pre-processor directive shall not be used to create inline macros"
