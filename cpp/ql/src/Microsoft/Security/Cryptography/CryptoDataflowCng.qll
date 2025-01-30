/**
 * Provides classes and predicates for identifying expressions that are use crypto API Next Generation (CNG).
 */

import cpp
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Dataflow that detects a call to BCryptSetProperty pszProperty = ChainingMode (CNG)
 */
module CngBCryptSetPropertyParamtoKChainingModeConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getValue().toString().matches("ChainingMode")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // BCryptSetProperty 2nd argument specifies the key parameter to set
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("BCryptSetProperty")
    )
  }
}

module CngBCryptSetPropertyParamtoKChainingMode =
  DataFlow::Global<CngBCryptSetPropertyParamtoKChainingModeConfiguration>;

/**
 * A function call to BCryptSetProperty pszProperty = ChainingMode (CNG)
 */
class CngBCryptSetPropertyParamtoKChainingMode extends FunctionCall {
  CngBCryptSetPropertyParamtoKChainingMode() {
    exists(Expr var |
      CngBCryptSetPropertyParamtoKChainingMode::flow(DataFlow::exprNode(var),
        DataFlow::exprNode(this.getArgument(1)))
    )
  }
}

predicate isChaniningModeCbc(DataFlow::Node source) {
  // Verify if algorithm is in the approved list.
  exists(string s | s = source.asExpr().getValue().toString() |
    s.regexpMatch("ChainingMode[A-Za-z0-9/]+") and
    // Property Strings
    // BCRYPT_CHAIN_MODE_NA    L"ChainingModeN/A"  - The algorithm does not support chaining
    // BCRYPT_CHAIN_MODE_CBC   L"ChainingModeCBC"  - Microsoft-Only: Only mode allowed by Crypto Board from this list (CBC-MAC)
    // BCRYPT_CHAIN_MODE_ECB   L"ChainingModeECB"  - Generally not recommended for usage in cryptographic protocols at all
    // BCRYPT_CHAIN_MODE_CFB   L"ChainingModeCFB"  - Microsoft-Only: Banned, usage requires Crypto Board review
    // BCRYPT_CHAIN_MODE_CCM   L"ChainingModeCCM"  - Microsoft-Only: Banned, usage requires Crypto Board review
    // BCRYPT_CHAIN_MODE_GCM   L"ChainingModeGCM"  - Microsoft-Only: Only for TLS, other usage requires Crypto Board review
    not s.matches("ChainingModeCBC")
  )
}

module CngBCryptSetPropertyChainingBannedModeConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isChaniningModeCbc(source) }

  predicate isSink(DataFlow::Node sink) {
    exists(CngBCryptSetPropertyParamtoKChainingMode call |
      // BCryptOpenAlgorithmProvider 3rd argument sets the chaining mode value
      sink.asExpr() = call.getArgument(2)
    )
  }
}

module CngBCryptSetPropertyChainingBannedMode =
  DataFlow::Global<CngBCryptSetPropertyChainingBannedModeConfiguration>;

module CngBCryptSetPropertyChainingBannedModeIndirectParameterConfiguration implements
  DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node source) { isChaniningModeCbc(source) }

  predicate isSink(DataFlow::Node sink) {
    exists(CngBCryptSetPropertyParamtoKChainingMode call |
      // CryptSetKeyParam 3rd argument specifies the mode (KP_MODE)
      sink.asIndirectExpr() = call.getArgument(2)
    )
  }
}

module CngBCryptSetPropertyChainingBannedModeIndirectParameter =
  DataFlow::Global<CngBCryptSetPropertyChainingBannedModeIndirectParameterConfiguration>;

// CNG-specific DataFlow configuration
module BCryptOpenAlgorithmProviderBannedHashConfiguration implements DataFlow::ConfigSig {
  // NOTE: Unlike the CAPI scenario, CNG will use this method to load and initialize
  //       a cryptographic provider for any type of algorithm,not only hash.
  //       Therefore, we have to take a banned-list instead of approved list approach.
  //
  predicate isSource(DataFlow::Node source) {
    // Verify if algorithm is marked as banned.
    source.asExpr().getValue().toString().matches("MD_")
    or
    source.asExpr().getValue().toString().matches("SHA1")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
    )
  }
}

module BCryptOpenAlgorithmProviderBannedHash =
  DataFlow::Global<BCryptOpenAlgorithmProviderBannedHashConfiguration>;

// CNG-specific DataFlow configuration
module BCryptOpenAlgorithmProviderBannedEncryptionConfiguration implements DataFlow::ConfigSig {
  // NOTE: Unlike the CAPI scenario, CNG will use this method to load and initialize
  //       a cryptographic provider for any type of algorithm,not only encryption.
  //       Therefore, we have to take a banned-list instead of approved list approach.
  //
  predicate isSource(DataFlow::Node source) {
    // Verify if algorithm is marked as banned.
    source.asExpr().getValue().toString().matches("RC_") or
    source.asExpr().getValue().toString().matches("DES") or
    source.asExpr().getValue().toString().matches("DESX") or
    source.asExpr().getValue().toString().matches("3DES") or
    source.asExpr().getValue().toString().matches("3DES_112") or
    source.asExpr().getValue().toString().matches("AES_GMAC") or // Microsoft Only: Requires Cryptoboard review
    source.asExpr().getValue().toString().matches("AES_CMAC") // Microsoft Only: Requires Cryptoboard review
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
    )
  }
}

module BCryptOpenAlgorithmProviderBannedEncryption =
  DataFlow::Global<BCryptOpenAlgorithmProviderBannedEncryptionConfiguration>;
