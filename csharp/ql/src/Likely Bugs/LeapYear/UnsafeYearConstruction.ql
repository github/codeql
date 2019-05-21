/**
 * @name Unsafe year argument for DateTime constructor
 * @description Constructing a DateTime object by setting the year argument by manipulating the year of a different DateTime object
 * @kind problem
 * @problem.severity error
 * @id cs/leap-year/unsafe-year-contruction
 * @precision high
 * @tags security
 *       leap-year
 */

import csharp
import semmle.code.csharp.dataflow.TaintTracking

class UnsafeYearCreationFromArithmeticConfiguration extends TaintTracking::Configuration  {
  UnsafeYearCreationFromArithmeticConfiguration() { this = "UnsafeYearCreationFromArithmeticConfiguration" }

  override predicate isSource(DataFlow::Node source) { 
    exists( ArithmeticOperation ao, PropertyAccess pa |
      ao = source.asExpr() | 
      pa = ao.getAChild*()
      and pa.getProperty().getQualifiedName().matches("%DateTime.Year")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists( ObjectCreation oc |
      sink.asExpr() = oc.getArgumentForName("year")
      and oc.getObjectType().getABaseType*().hasQualifiedName("System.DateTime"))
  }
}

from UnsafeYearCreationFromArithmeticConfiguration config, Expr sink, Expr source
where config.hasFlow(DataFlow::exprNode(source), DataFlow::exprNode(sink))
select sink, "This $@ based on a System.DateTime.Year property is used in a construction of a new System.DateTime object, flowing to the 'year' argument.", source, "arithmetic operation" 
