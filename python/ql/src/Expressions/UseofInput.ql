/**
 * @name 'input' function used in Python 2
 * @description The built-in function 'input' is used which, in Python 2, can allow arbitrary code to be run.
 * @kind problem
 * @tags security
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/use-of-input
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

from DataFlow::CallCfgNode call
where
  major_version() = 2 and
  call = API::builtin("input").getACall() and
  call != API::builtin("raw_input").getACall()
select call, "The unsafe built-in function 'input' is used in Python 2."
