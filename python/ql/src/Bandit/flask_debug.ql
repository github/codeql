/**
 * @name  A Flask app appears to be run with debug=True
 * @description A Flask app appears to be run with debug=True, which exposes the Werkzeug debugger and allows the execution of arbitrary code.
 *         https://bandit.readthedocs.io/en/latest/plugins/b201_flask_debug_true.html
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @id py/bandit/flask-debug
 */

import python

from  AssignStmt a, Call c
where a.getValue().toString() = "Flask()"
  and c.getFunc().(Attribute).getName() = "run" 
  and exists(Keyword k | k = c.getANamedArg() 
              and k.getArg() = "debug" 
              and k.getValue().toString() = "True"
        and a.getATarget().toString() = c.getFunc().(Attribute).getObject().toString()
        )     
select c, " A Flask app appears to be run with debug=True"
