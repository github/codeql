import semmle.javascript.frameworks.xUnit

from XUnitAnnotation ann
select ann, ann.getTarget()
