/**
 * @name Invocation of alert
 * @description 'alert' should not be used in production code.
 * @kind problem
 * @problem.severity recommendation
 * @id js/alert-call
 * @tags maintainability
 *       external/cwe/cwe-489
 * @precision medium
 */

import javascript

select DataFlow::globalVarRef("alert").getACall(), "Avoid calling alert."
