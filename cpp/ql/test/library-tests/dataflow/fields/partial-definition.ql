/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow::DataFlow

select any(Node n).asPartialDefinition()
