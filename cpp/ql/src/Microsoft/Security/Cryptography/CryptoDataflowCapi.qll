/**
 * Provides classes and predicates for identifying expressions that are use Crypto API (CAPI).
 */

import cpp
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Dataflow that detects a call to CryptSetKeyParam dwParam = KP_MODE (CAPI)
 */
module CapiCryptCryptSetKeyParamtoKPMODEConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getValue().toInt() = 4 // KP_MODE
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // CryptSetKeyParam 2nd argument specifies the key parameter to set
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("CryptSetKeyParam")
    )
  }
}

module CapiCryptCryptSetKeyParamtoKPMODE =
  DataFlow::Global<CapiCryptCryptSetKeyParamtoKPMODEConfiguration>;

/**
 * A function call to CryptSetKeyParam with dwParam = KP_MODE (CAPI)
 */
class CapiCryptCryptSetKeyParamtoKPMODE extends FunctionCall {
  CapiCryptCryptSetKeyParamtoKPMODE() {
    exists(Expr var |
      CapiCryptCryptSetKeyParamtoKPMODE::flow(DataFlow::exprNode(var),
        DataFlow::exprNode(this.getArgument(1)))
    )
  }
}

// CAPI-specific DataFlow configuration
module CapiCryptCreateHashBannedConfiguration implements DataFlow::ConfigSig {
  // This mechnism will verify for approved set of values to call, rejecting anythign that is not in the list.
  // NOTE: This mechanism is not guaranteed to work with CSPs that do not use the same algorithms defined in Wincrypt.h
  //
  predicate isSource(DataFlow::Node source) {
    // Verify if source matched the mask for CAPI ALG_CLASS_HASH == 32768
    source.asExpr().getValue().toInt().bitShiftRight(13) = 4 and
    // The following hash algorithms are safe to use, anything else is considered banned
    not (
      source.asExpr().getValue().toInt().bitXor(32768) = 12 or // ALG_SID_SHA_256
      source.asExpr().getValue().toInt().bitXor(32768) = 13 or // ALG_SID_SHA_384
      source.asExpr().getValue().toInt().bitXor(32768) = 14 // ALG_SID_SHA_512
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // CryptCreateHash 2nd argument specifies the hash algorithm to be used.
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("CryptCreateHash")
    )
  }
}

module CapiCryptCreateHashBanned = DataFlow::Global<CapiCryptCreateHashBannedConfiguration>;

// CAPI-specific DataFlow configuration
module CapiCryptCreateEncryptionBannedConfiguration implements DataFlow::ConfigSig {
  // This mechanism will verify for approved set of values to call, rejecting anything that is not in the list.
  // NOTE: This mechanism is not guaranteed to work with CSPs that do not use the same algorithms defined in Wincrypt.h
  //
  predicate isSource(DataFlow::Node source) {
    // Verify if source matched the mask for CAPI ALG_CLASS_DATA_ENCRYPT == 24576
    source.asExpr().getValue().toInt().bitShiftRight(13) = 3 and
    // The following algorithms are safe to use, anything else is considered banned
    not (
      source.asExpr().getValue().toInt().bitXor(26112) = 14 or // ALG_SID_AES_128
      source.asExpr().getValue().toInt().bitXor(26112) = 15 or // ALG_SID_AES_192
      source.asExpr().getValue().toInt().bitXor(26112) = 16 or // ALG_SID_AES_256
      source.asExpr().getValue().toInt().bitXor(26112) = 17 // ALG_SID_AES
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // CryptGenKey or CryptDeriveKey 2nd argument specifies the hash algorithm to be used.
      sink.asExpr() = call.getArgument(1) and
      (
        call.getTarget().hasGlobalName("CryptGenKey") or
        call.getTarget().hasGlobalName("CryptDeriveKey")
      )
    )
  }
}

module CapiCryptCreateEncryptionBanned =
  DataFlow::Global<CapiCryptCreateEncryptionBannedConfiguration>;
