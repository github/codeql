/**
 * @name Weak cryptography
 * @description Finds explicit uses of block cipher chaining mode algorithms that are not approved. (CAPI)
 * @kind problem
 * @id cpp/microsoft/public/weak-crypto/capi/banned-modes
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import CryptoDataflowCapi

module CapiSetBlockCipherConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().isConstant() and
    // KP_MODE
    // CRYPT_MODE_CBC   1  - Cipher block chaining    - Microsoft-Only: Only mode allowed by Crypto Board from this list (CBC-MAC)
    // CRYPT_MODE_ECB   2  - Electronic code book     - Generally not recommended for usage in cryptographic protocols at all
    // CRYPT_MODE_OFB   3  - Output feedback mode     - Microsoft-Only: Banned, usage requires Crypto Board review
    // CRYPT_MODE_CFB   4  - Cipher feedback mode     - Microsoft-Only: Banned, usage requires Crypto Board review
    // CRYPT_MODE_CTS   5  - Ciphertext stealing mode - Microsoft-Only: CTS is approved by Crypto Board, but should probably use CNG and not CAPI
    source.asExpr().getValue().toInt() != 1
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CapiCryptCryptSetKeyParamtoKPMODE call | sink.asIndirectExpr() = call.getArgument(2))
  }
}

module CapiSetBlockCipherTrace = DataFlow::Global<CapiSetBlockCipherConfiguration>;

from CapiCryptCryptSetKeyParamtoKPMODE call, DataFlow::Node src, DataFlow::Node sink
where
  sink.asIndirectExpr() = call.getArgument(2) and
  CapiSetBlockCipherTrace::flow(src, sink)
select call,
  "Call to 'CryptSetKeyParam' function with argument dwParam = KP_MODE is setting up a banned block cipher mode."
