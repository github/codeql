/**
 * @name KDF may only use SHA256/384/512 in generating a key.
 * @description KDF may only use SHA256/384/512 in generating a key.
 * @kind problem
 * @id cpp/microsoft/public/kdf-insecure-hash
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module BannedHashAlgorithmConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // Verify if algorithm is marked as banned.
    not source.asExpr().getValue().toString().matches("SHA256") and
    not source.asExpr().getValue().toString().matches("SHA384") and
    not source.asExpr().getValue().toString().matches("SHA512")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      // Argument 1 (0-based) specified the algorithm ID.
      // NTSTATUS BCryptOpenAlgorithmProvider(
      //     [out] BCRYPT_ALG_HANDLE *phAlgorithm,
      //     [in]  LPCWSTR           pszAlgId,
      //     [in]  LPCWSTR           pszImplementation,
      //     [in]  ULONG             dwFlags
      //   );
      sink.asExpr() = call.getArgument(1) and
      call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
    )
  }
}

module BannedHashAlgorithmTrace = DataFlow::Global<BannedHashAlgorithmConfig>;

module BCRYPT_ALG_HANDLE_Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(FunctionCall call |
      // Argument 0 (0-based) specified the algorithm handle
      // NTSTATUS BCryptOpenAlgorithmProvider(
      //     [out] BCRYPT_ALG_HANDLE *phAlgorithm,
      //     [in]  LPCWSTR           pszAlgId,
      //     [in]  LPCWSTR           pszImplementation,
      //     [in]  ULONG             dwFlags
      //   );
      source.asDefiningArgument() = call.getArgument(0) and
      call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    // Algorithm handle is the 0th (0-based) argument of the call
    //    NTSTATUS BCryptDeriveKeyPBKDF2(
    //      [in]           BCRYPT_ALG_HANDLE hPrf,
    //      [in, optional] PUCHAR            pbPassword,
    //      [in]           ULONG             cbPassword,
    //      [in, optional] PUCHAR            pbSalt,
    //      [in]           ULONG             cbSalt,
    //      [in]           ULONGLONG         cIterations,
    //      [out]          PUCHAR            pbDerivedKey,
    //      [in]           ULONG             cbDerivedKey,
    //      [in]           ULONG             dwFlags
    // );
    exists(Call c | c.getTarget().getName() = "BCryptDeriveKeyPBKDF2" |
      c.getArgument(0) = sink.asExpr()
    )
  }
}

module BCRYPT_ALG_HANDLE_Trace = DataFlow::Global<BCRYPT_ALG_HANDLE_Config>;

from DataFlow::Node src1, DataFlow::Node src2, DataFlow::Node sink1, DataFlow::Node sink2
where
  BannedHashAlgorithmTrace::flow(src1, sink1) and
  exists(Call c |
    c.getAnArgument() = sink1.asExpr() and src2.asDefiningArgument() = c.getAnArgument()
  |
    BCRYPT_ALG_HANDLE_Trace::flow(src2, sink2)
  )
select sink2.asExpr(),
  "BCRYPT_ALG_HANDLE is passed to this to KDF derived from insecure hashing function $@. Must use SHA256 or higher.",
  src1.asExpr(), src1.asExpr().getValue()
