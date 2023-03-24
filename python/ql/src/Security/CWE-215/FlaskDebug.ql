/**
 * @name Flask app is run in debug mode
 * @description Running a Flask app in debug mode may allow an attacker to run arbitrary code through the Werkzeug debugger.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/flask-debug
 * @tags security
 *       external/cwe/cwe-215
 *       external/cwe/cwe-489
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.frameworks.Flask

from API::CallNode call
where
  call = Flask::FlaskApp::instance().getMember("run").getACall() and
  call.getParameter(2, "debug").getAValueReachingSink().asExpr().(ImmutableLiteral).booleanValue() =
    true
select call,
  "A Flask app appears to be run in debug mode. This may allow an attacker to run arbitrary code through the debugger."
