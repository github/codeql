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
import semmle.code.cpp.models.implementations.Memset
import PotentiallyExposedSystemData::PathGraph
import SystemData

module PotentiallyExposedSystemDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(SystemData sd | sd.isSensitive()).getAnExpr()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(OutputWrite ow, Expr child | child = ow.getASource().getAChild*() |
      // Most sinks receive a pointer as an argument (for example `printf`),
      // and we use an indirect sink for those.
      // However, some sinks (for example `puts`) receive a single character
      // as an argument. For those we have to use a direct sink.
      if
        child.getUnspecifiedType() instanceof PointerType or
        child.getUnspecifiedType() instanceof ArrayType
      then child = sink.asIndirectExpr()
      else child = sink.asExpr()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asIndirectArgument() = any(MemsetFunction func).getACallToThisFunction().getAnArgument()
  }
}

module PotentiallyExposedSystemData = TaintTracking::Global<PotentiallyExposedSystemDataConfig>;

from PotentiallyExposedSystemData::PathNode source, PotentiallyExposedSystemData::PathNode sink
where PotentiallyExposedSystemData::flowPath(source, sink)
select sink, source, sink, "This operation potentially exposes sensitive system data from $@.",
  source, source.getNode().toString()
