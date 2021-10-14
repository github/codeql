/**
 * @name JSDoc tag for non-existent parameter
 * @description A JSDoc 'param' tag that refers to a non-existent parameter is confusing
 *              and may indicate badly maintained code.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jsdoc/unknown-parameter
 * @tags maintainability
 *       readability
 *       documentation
 * @precision low
 */

import javascript

from Function f, JSDoc doc, JSDocParamTag tag, string parmName
where
  doc = f.getDocumentation() and
  tag = doc.getATag() and
  parmName = tag.getName() and
  tag.documentsSimpleName() and
  not exists(f.getParameterByName(parmName)) and
  // don't report functions without declared parameters that use `arguments`
  not (f.getNumParameter() = 0 and f.usesArgumentsObject()) and
  // don't report a violation in ambiguous cases
  strictcount(JSDoc d | d = f.getDocumentation() and d.getATag() instanceof JSDocParamTag) = 1
select tag, "@param tag refers to non-existent parameter " + parmName + "."
