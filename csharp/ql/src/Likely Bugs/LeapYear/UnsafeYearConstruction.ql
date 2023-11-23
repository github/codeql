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
import UnsafeYearCreationFromArithmetic::PathGraph

module UnsafeYearCreationFromArithmeticConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ArithmeticOperation ao, PropertyAccess pa | ao = source.asExpr() |
      pa = ao.getAChild*() and
      pa.getProperty().hasFullyQualifiedName("System.DateTime", "Year")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ObjectCreation oc |
      sink.asExpr() = oc.getArgumentForName("year") and
      oc.getObjectType().getABaseType*().hasFullyQualifiedName("System", "DateTime")
    )
  }
}

module UnsafeYearCreationFromArithmetic =
  TaintTracking::Global<UnsafeYearCreationFromArithmeticConfig>;

from
  UnsafeYearCreationFromArithmetic::PathNode source, UnsafeYearCreationFromArithmetic::PathNode sink
where UnsafeYearCreationFromArithmetic::flowPath(source, sink)
select sink, source, sink,
  "This $@ based on a 'System.DateTime.Year' property is used in a construction of a new 'System.DateTime' object, flowing to the 'year' argument.",
  source, "arithmetic operation"
