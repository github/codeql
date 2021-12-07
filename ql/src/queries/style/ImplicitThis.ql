/**
 * @name Using implicit `this`
 * @description Writing member predicate calls with an implicit `this` can be confusing
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ql/implicit-this
 * @tags maintainability
 */

import ql
import codeql_ql.style.ImplicitThisQuery

from PredicateCall c
where c = confusingImplicitThisCall(_)
select c, "Use of implicit `this`."
