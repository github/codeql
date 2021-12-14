/**
 * @name Don't use getAQlClass.
 * @description Any use of getAQlClass causes both compile-time and runtime to be significantly slower.
 * @kind problem
 * @problem.severity warning
 * @id ql/dont-use-getaqlclass
 * @tags performance
 * @precision very-high
 */

import ql

from Call call
where
  (
    call.(PredicateCall).getPredicateName() = "getAQlClass" or
    call.(MemberCall).getMemberName() = "getAQlClass"
  ) and
  not call.getLocation().getFile().getAbsolutePath().matches("%/" + ["meta", "test"] + "/%") and
  not call.getLocation().getFile().getBaseName().toLowerCase() =
    ["consistency.ql", "test.ql", "tst.ql", "tests.ql"]
select call, "Don't use .getAQlClass"
