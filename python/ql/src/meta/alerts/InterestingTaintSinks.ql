/**
 * @name Interesting taint sinks
 * @description Interesting sinks from TaintTracking queries.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/alerts/interesting-taint-sinks
 * @tags meta
 * @precision very-low
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import Sinks

from string kind
where not kind in ["CleartextLogging", "LogInjection"]
select taintSink(kind), kind + " sink"
