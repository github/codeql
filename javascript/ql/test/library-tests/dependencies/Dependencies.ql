import semmle.javascript.dependencies.Dependencies
import DependencyCustomizations

from Dependency dep, string id, string version
where dep.info(id, version)
select dep, id, version
