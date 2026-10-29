/**
 * @name Bad param tag
 * @description A 'param' tag that does not include a name is confusing since it is unclear which
 *              parameter it is meant to document. A 'param' tag that does not include a
 *              description is useless and should be removed.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jsdoc/malformed-param-tag
 * @tags maintainability
 *       readability
 *       documentation
 * @precision low
 */

import javascript

from JSDocParamTag parm, string missing
where
  // JSDoc comments in externs files are not necessarily meant for human readers, so don't complain
  not parm.getFile().getATopLevel().isExterns() and
  (
    not exists(parm.getName()) and missing = "name"
    or
    (not exists(parm.getDescription()) or parm.getDescription().regexpMatch("\\s*")) and
    missing = "description"
  )
select parm, "@param tag is missing " + missing + "."
