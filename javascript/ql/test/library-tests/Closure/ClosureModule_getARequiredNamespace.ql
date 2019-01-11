import semmle.javascript.Closure

from ClosureModule cm
select cm, cm.getARequiredNamespace()
