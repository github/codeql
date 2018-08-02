/**
 * @name Number of tests
 * @description The number of test methods defined in a file.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg sum max
 * @precision medium
 * @id cpp/tests-in-files
 * @tags maintainability
 */
import cpp

Expr getTest() {
    // cppunit tests; https://freedesktop.org/wiki/Software/cppunit/
    exists(Function f | result.(FunctionCall).getTarget() = f
                    and f.getNamespace().getName() = "CppUnit"
                    and f.getName() = "addTest")
    or
    // boost tests; http://www.boost.org/
    exists(Function f | result.(FunctionCall).getTarget() = f
                    and f.getQualifiedName() = "boost::unit_test::make_test_case")
}

from File f, int n
where n = strictcount(Expr e | e = getTest() and e.getFile() = f)
select f, n
order by n desc
