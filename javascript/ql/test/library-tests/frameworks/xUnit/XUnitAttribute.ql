import semmle.javascript.frameworks.xUnit

from XUnitAttribute attr
select attr, attr.getName(), attr.getNumParameter()
