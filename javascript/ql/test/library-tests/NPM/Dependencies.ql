import semmle.javascript.NPM

from PackageJSON pkgjson, string pkg, string version
where pkgjson.declaresDependency(pkg, version)
select pkgjson, pkg, version
