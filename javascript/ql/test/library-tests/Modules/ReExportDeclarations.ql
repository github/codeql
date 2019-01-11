import semmle.javascript.ES2015Modules

from ReExportDeclaration red
select red, red.getImportedPath()
