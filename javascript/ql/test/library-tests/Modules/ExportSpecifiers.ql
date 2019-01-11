import semmle.javascript.ES2015Modules

from ExportSpecifier es
select es, es.getLocal(), es.getExported()
