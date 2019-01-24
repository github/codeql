import semmle.javascript.NPM

from PackageJSON pkg
select pkg, pkg.getPackageName(), pkg.getVersion()
