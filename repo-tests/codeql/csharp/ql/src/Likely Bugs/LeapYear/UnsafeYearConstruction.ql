/**
 * @name Unsafe year argument for 'DateTime' constructor
 * @description Constructing a 'DateTime' struct by setting the year argument to an increment or decrement of the year of a different 'DateTime' struct.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id cs/unsafe-year-construction
 * @tags date-time
 *       reliability
 */

import csharp
import DataFlow::PathGraph
import semmle.code.csharp.dataflow.TaintTracking

class UnsafeYearCreationFromArithmeticConfiguration extends TaintTracking::Configuration {
  UnsafeYearCreationFromArithmeticConfiguration() {
    this = "UnsafeYearCreationFromArithmeticConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    exists(ArithmeticOperation ao, PropertyAccess pa | ao = source.asExpr() |
      pa = ao.getAChild*() and
      pa.getProperty().getQualifiedName().matches("System.DateTime.Year")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ObjectCreation oc |
      sink.asExpr() = oc.getArgumentForName("year") and
      oc.getObjectType().getABaseType*().hasQualifiedName("System.DateTime")
    )
  }
}

from
  UnsafeYearCreationFromArithmeticConfiguration config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "This $@ based on a 'System.DateTime.Year' property is used in a construction of a new 'System.DateTime' object, flowing to the 'year' argument.",
  source, "arithmetic operation"
