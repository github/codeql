import semmle.javascript.ES2015Modules

from ImportDeclaration id
select id, id.getImportedPath(), count(id.getASpecifier())
