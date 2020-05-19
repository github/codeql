/**
 * @name Undocumented parameter
 * @description If some parameters of a function are documented by JSDoc 'param' tags while others
 *              are not, this may indicate badly maintained code.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jsdoc/missing-parameter
 * @tags maintainability
 *       readability
 *       documentation
 * @precision low
 */

import javascript

from Function f, Parameter parm, Variable v, JSDoc doc
where
  parm = f.getAParameter() and
  doc = f.getDocumentation() and
  v = parm.getAVariable() and
  // at least one parameter is documented
  exists(doc.getATag().(JSDocParamTag).getDocumentedParameter()) and
  // but v is not
  not doc.getATag().(JSDocParamTag).getDocumentedParameter() = v and
  // don't report an alert in ambiguous cases
  strictcount(JSDoc d | d = f.getDocumentation() and d.getATag() instanceof JSDocParamTag) = 1
select parm, "Parameter " + v.getName() + " is not documented."
