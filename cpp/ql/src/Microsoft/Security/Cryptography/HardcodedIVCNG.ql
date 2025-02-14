/**
 * @name Weak cryptography
 * @description Finds usage of a static (hardcoded) IV. (CNG)
 * @kind problem
 * @id cpp/microsoft/public/weak-crypto/cng/hardcoded-iv
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Gets const element of `ArrayAggregateLiteral`.
 */
Expr getConstElement(ArrayAggregateLiteral lit) {
  exists(int n |
    result = lit.getElementExpr(n, _) and
    result.isConstant()
  )
}

/**
 * Gets the last element in an `ArrayAggregateLiteral`.
 */
Expr getLastElement(ArrayAggregateLiteral lit) {
  exists(int n |
    result = lit.getElementExpr(n, _) and
    not exists(lit.getElementExpr(n + 1, _))
  )
}

module CngBCryptEncryptHardcodedIVConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(AggregateLiteral lit |
      getLastElement(lit) = source.asDefinition() and
      exists(getConstElement(lit))
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // BCryptEncrypt 5h argument specifies the IV
      sink.asIndirectExpr() = call.getArgument(4) and
      call.getTarget().hasGlobalName("BCryptEncrypt")
    )
  }
}

module Flow = DataFlow::Global<CngBCryptEncryptHardcodedIVConfiguration>;

from DataFlow::Node sl, DataFlow::Node fc, AggregateLiteral lit
where
  Flow::flow(sl, fc) and
  getLastElement(lit) = sl.asDefinition()
select lit, "Calling BCryptEncrypt with a hard-coded IV on function "
