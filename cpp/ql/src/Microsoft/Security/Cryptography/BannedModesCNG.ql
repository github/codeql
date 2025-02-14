/**
 * @name Weak cryptography
 * @description Finds explicit uses of block cipher chaining mode algorithms that are not approved. (CNG)
 * @kind problem
 * @id cpp/microsoft/public/weak-crypto/cng/banned-modes
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import CryptoDataflowCng

from CngBCryptSetPropertyParamtoKChainingMode call, DataFlow::Node src, DataFlow::Node sink
where
  sink.asIndirectArgument() = call.getArgument(2) and
  CngBCryptSetPropertyChainingBannedModeIndirectParameter::flow(src, sink)
  or
  sink.asExpr() = call.getArgument(2) and CngBCryptSetPropertyChainingBannedMode::flow(src, sink)
select call,
  "Call to 'BCryptSetProperty' function with argument pszProperty = \"ChainingMode\" is setting up a banned block cipher mode."
