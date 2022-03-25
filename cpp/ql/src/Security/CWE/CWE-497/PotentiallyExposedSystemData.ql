/**
 * @name Potential exposure of sensitive system data to an unauthorized control sphere
 * @description Exposing sensitive system data helps
 *              a malicious user learn about the system and form an
 *              attack plan.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision medium
 * @id cpp/potential-system-data-exposure
 * @tags security
 *       external/cwe/cwe-497
 */

/*
 * These queries are closely related:
 *  - `cpp/system-data-exposure`, which flags exposure of system information
 *    to a remote sink (i.e. focusses on quality of the sink).
 *  - `cpp/potential-system-data-exposure`, which flags on exposure of the most
 *    sensitive information to a local sink (i.e. focusses on quality of the
 *    sensitive information).
 *
 * This used to be a single query with neither focus, which was too noisy and
 * gave the user less control.
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.security.OutputWrite
import DataFlow::PathGraph
import SystemData

class PotentiallyExposedSystemDataConfiguration extends TaintTracking::Configuration {
  PotentiallyExposedSystemDataConfiguration() { this = "PotentiallyExposedSystemDataConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(SystemData sd | sd.isSensitive()).getAnExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(OutputWrite ow | ow.getASource().getAChild*() = sink.asExpr())
  }
}

from
  PotentiallyExposedSystemDataConfiguration config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "This operation potentially exposes sensitive system data from $@.",
  source, source.getNode().toString()
