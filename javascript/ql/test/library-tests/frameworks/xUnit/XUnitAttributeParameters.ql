import semmle.javascript.frameworks.xUnit

from XUnitAttribute attr, int i
select attr, i, attr.getParameter(i)
