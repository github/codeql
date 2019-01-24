import semmle.javascript.NPM

from NPMPackage pkg
select pkg.getPackageName(), pkg.getAModule()
