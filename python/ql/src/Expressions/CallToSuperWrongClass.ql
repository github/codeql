/**
 * @name First argument to super() is not enclosing class
 * @description Calling super with something other than the enclosing class may cause incorrect object initialization.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-687
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/super-not-enclosing-class
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call_to_super, string name
where
  call_to_super = API::builtin("super").getACall() and
  name = call_to_super.getScope().getScope().(Class).getName() and
  exists(DataFlow::Node arg |
    arg = call_to_super.getArg(0) and
    arg.getALocalSource().asExpr().(Name).getId() != name
  )
select call_to_super.getNode(), "First argument to super() should be " + name + "."
