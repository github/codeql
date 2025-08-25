/**
 * @name Taint sinks
 * @description Sinks from TaintTracking queries.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/alerts/taint-sinks
 * @tags meta
 * @precision very-low
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import Sinks

from string kind
select taintSink(kind), kind + " sink"
