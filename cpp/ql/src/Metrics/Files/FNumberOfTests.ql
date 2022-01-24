/**
 * @name Number of tests
 * @description The number of test methods defined in a file.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id cpp/tests-in-files
 * @tags maintainability
 */

import cpp

Expr getTest() {
  // cppunit tests; https://freedesktop.org/wiki/Software/cppunit/
  result.(FunctionCall).getTarget().hasQualifiedName("CppUnit", _, "addTest")
  or
  // boost tests; http://www.boost.org/
  result.(FunctionCall).getTarget().hasQualifiedName("boost::unit_test", "make_test_case")
  or
  // googletest tests; https://github.com/google/googletest/
  result.(FunctionCall).getTarget().hasQualifiedName("testing::internal", "MakeAndRegisterTestInfo")
}

from File f, int n
where n = strictcount(Expr e | e = getTest() and e.getFile() = f)
select f, n order by n desc
