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

/** Gets a reference to a truthy literal. */
private DataFlow::TypeTrackingNode truthyLiteral(DataFlow::TypeTracker t) {
  t.start() and
  result.asExpr().(ImmutableLiteral).booleanValue() = true
  or
  exists(DataFlow::TypeTracker t2 | result = truthyLiteral(t2).track(t2, t))
}

/** Gets a reference to a truthy literal. */
DataFlow::Node truthyLiteral() { truthyLiteral(DataFlow::TypeTracker::end()).flowsTo(result) }

from DataFlow::CallCfgNode call, DataFlow::Node debugArg
where
  call.getFunction() = Flask::FlaskApp::instance().getMember("run").getAUse() and
  debugArg in [call.getArg(2), call.getArgByName("debug")] and
  debugArg = truthyLiteral()
select call,
  "A Flask app appears to be run in debug mode. This may allow an attacker to run arbitrary code through the debugger."
