/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.dataflow.old.DataFlow::DataFlow

select any(Node n).asPartialDefinition()
