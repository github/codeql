/**
 * @name General statistics
 * @description Shows general statistics about the application.
 * @kind table
 * @id cpp/architecture/general-statistics
 * @tags maintainability
 */

import cpp

from string l, string n
where
  l = "Number of Namespaces" and
  n = count(Namespace p | p.fromSource()).toString()
  or
  l = "Number of Files" and
  n = count(File f | f.fromSource()).toString()
  or
  l = "Number of Header Files" and
  n = count(HeaderFile f | f.fromSource()).toString()
  or
  l = "Number of C Files" and
  n = count(CFile f | f.fromSource()).toString()
  or
  l = "Number of C++ Files" and
  n = count(CppFile f | f.fromSource()).toString()
  or
  l = "Number of Classes" and
  n = count(Class c | c.fromSource() and not c instanceof Struct).toString()
  or
  l = "Number of Structs" and
  n = count(Struct s | s.fromSource() and not s instanceof Union).toString()
  or
  l = "Number of Unions" and
  n = count(Union u | u.fromSource()).toString()
  or
  l = "Number of Functions" and
  n = count(Function f | f.fromSource()).toString()
  or
  l = "Number of Lines Of Code" and
  n =
    sum(File f, int toSum |
      f.fromSource() and toSum = f.getMetrics().getNumberOfLinesOfCode()
    |
      toSum
    ).toString()
  or
  l = "Self-Containedness" and
  n =
    (
        100 * sum(Class c | c.fromSource() | c.getMetrics().getEfferentSourceCoupling()) /
          sum(Class c | c.fromSource() | c.getMetrics().getEfferentCoupling())
      ).toString() + "%"
select l as Title, n as Value
