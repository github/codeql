/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow

select any(Node n).asPartialDefinition()
