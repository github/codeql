/**
 * @name ifstmt05
 * @description Every if statement with an initialization has the initialization or one of the
 *              initialization's descendants as its unique successor. Every if statement without
 *              and initialization has its condition or one of the condition's descendants as
 *              its unique successor.
 */

import cpp

from IfStmt is
where
  not (
    (
      if exists(is.getInitialization())
      then is.getASuccessor() = is.getInitialization().getAChild*()
      else is.getASuccessor() = is.getCondition().getAChild*()
    ) and
    count(is.getASuccessor()) = 1
  )
select is
