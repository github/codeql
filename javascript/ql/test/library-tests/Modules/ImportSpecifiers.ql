import semmle.javascript.ES2015Modules

from ImportSpecifier is
select is, is.getLocal()
