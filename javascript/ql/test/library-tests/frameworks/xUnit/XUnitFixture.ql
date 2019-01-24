import semmle.javascript.frameworks.xUnit

from XUnitFixture f
select f, f.getAnAnnotation()
