/**
 * @name User-controlled data may not be null terminated
 * @description String operations on user-controlled strings can result in
 *              buffer overflow or buffer over-read.
 * @kind problem
 * @id cpp/user-controlled-null-termination-tainted
 * @problem.severity warning
 * @security-severity 10.0
 * @tags security
 *       external/cwe/cwe-170
 */

import cpp
import semmle.code.cpp.commons.NullTermination
import semmle.code.cpp.ir.dataflow.internal.DefaultTaintTrackingImpl

/** A user-controlled expression that may not be null terminated. */
class TaintSource extends VariableAccess {
  TaintSource() {
    exists(SecurityOptions x, string cause |
      this.getTarget() instanceof SemanticStackVariable and
      x.isUserInput(this, cause)
    |
      cause = ["read", "fread", "recv", "recvfrom", "recvmsg"]
    )
  }

  /**
   * Holds if `sink` is a tainted variable access that must be null
   * terminated.
   */
  private predicate isSink(VariableAccess sink) {
    tainted(this, sink) and
    variableMustBeNullTerminated(sink)
  }

  /**
   * Holds if this source can reach `va`, possibly using intermediate
   * reassignments.
   */
  private predicate sourceReaches(VariableAccess va) {
    definitionUsePair(_, this, va)
    or
    exists(VariableAccess mid, Expr def |
      this.sourceReaches(mid) and
      exprDefinition(_, def, mid) and
      definitionUsePair(_, def, va)
    )
  }

  /**
   * Holds if the sink `sink` is reachable both from this source and
   * from `va`, possibly using intermediate reassignments.
   */
  private predicate reachesSink(VariableAccess va, VariableAccess sink) {
    this.isSink(sink) and
    va = sink
    or
    exists(VariableAccess mid, Expr def |
      this.reachesSink(mid, sink) and
      exprDefinition(_, def, va) and
      definitionUsePair(_, def, mid)
    )
  }

  /**
   * Holds if `sink` is a tainted variable access that must be null
   * terminated, and no access which null terminates its contents can
   * either reach the sink or be reached from the source. (Ideally,
   * we should instead look for such accesses only on the path from
   * this source to `sink` found via `tainted(source, sink)`.)
   */
  predicate reaches(VariableAccess sink) {
    this.isSink(sink) and
    not exists(VariableAccess va |
      va != this and
      va != sink and
      mayAddNullTerminator(_, va)
    |
      this.sourceReaches(va)
      or
      this.reachesSink(va, sink)
    )
  }
}

from TaintSource source, VariableAccess sink
where source.reaches(sink)
select sink, "String operation depends on a $@ that may not be null terminated.", source,
  "user-provided value"
