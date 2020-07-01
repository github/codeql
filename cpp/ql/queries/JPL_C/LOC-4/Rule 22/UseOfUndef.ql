/**
 * @name Use of #undef
 * @description #undef shall not be used.
 * @kind problem
 * @id cpp/jpl-c/use-of-undef
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from PreprocessorUndef u
select u, "The #undef directive shall not be used."
