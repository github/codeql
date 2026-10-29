/**
 * @name ifelsestmt05
 * @description Every if statement has its condition or one of the condition's descendants as its unique successor.
 */

import cpp

from IfStmt is
where
  not (
    is.getASuccessor() = is.getCondition().getAChild*() and
    count(is.getASuccessor()) = 1
  )
select is
