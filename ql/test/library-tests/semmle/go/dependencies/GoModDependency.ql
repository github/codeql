import semmle.go.dependencies.Dependencies

from GoModDependency dep, string origpath, string origver, string path, string ver
where dep.info(path, ver) and dep.originalInfo(origpath, origver)
select dep, origpath, origver, path, ver
