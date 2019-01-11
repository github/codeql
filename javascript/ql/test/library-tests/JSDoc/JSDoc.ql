import semmle.javascript.JSDoc

from JSDoc jsdoc
select jsdoc, jsdoc.getDescription(), jsdoc.getComment()
