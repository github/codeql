/**
 * @name Flask app is run in debug mode
 * @description Running a Flask app in debug mode may allow an attacker to run arbitrary code through the Werkzeug debugger.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/flask-debug
 * @tags security
 *       external/cwe/cwe-215
 *       external/cwe/cwe-489
 */

import python
import semmle.python.web.flask.General

from CallNode call, Value isTrue
where
  call = theFlaskClass().declaredAttribute("run").(FunctionValue).getACall() and
  call.getArgByName("debug").pointsTo(isTrue) and
  isTrue.getDefiniteBooleanValue() = true
select call,
  "A Flask app appears to be run in debug mode. This may allow an attacker to run arbitrary code through the debugger."
