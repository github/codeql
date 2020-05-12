/**
 * @name An uncertain SSA update without a prior definition
 * @description An uncertain SSA update may retain its previous value
 *              and should therefore have a prior definition.
 * @kind problem
 * @problem.severity error
 * @id java/consistency/uncertain-ssa-update-without-prior-def
 * @tags consistency
 */

import java
import semmle.code.java.dataflow.SSA

predicate live(SsaVariable v) {
  exists(v.getAUse())
  or
  exists(SsaPhiNode phi | live(phi) and phi.getAPhiInput() = v)
  or
  exists(SsaUncertainImplicitUpdate upd | live(upd) and upd.getPriorDef() = v)
}

from SsaUncertainImplicitUpdate upd
where
  live(upd) and
  not exists(upd.getPriorDef())
select upd, "No prior definition of " + upd
