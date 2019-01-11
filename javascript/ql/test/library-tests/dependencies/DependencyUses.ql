import semmle.javascript.dependencies.Dependencies
import DependencyCustomizations

from Dependency dep, string id, string v, string kind
where dep.info(id, v)
select id + "-" + v, kind, dep.getAUse(kind)
