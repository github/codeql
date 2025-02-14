/**
 * @name Small KDF derived key length.
 * @description KDF derived keys should be a minimum of 128 bits (16 bytes).
 * This query traces constants of less than the min length to the target parameter.
 * NOTE: if the constant is modified, or if a non-constant gets to the target, this query will not flag these cases.
 *      The rationale currently is that this query is meant to validate common uses of key derivation.
 *      Non-common uses (modifying the values somehow or getting the count from outside sources) are assumed to be intentional.
 * @kind problem
 * @id cpp/microsoft/public/kdf-small-key-size
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module KeyLenConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr().getValue().toInt() < 16 }

  predicate isSink(DataFlow::Node sink) {
    // Key length size is the 7th (0-based) argument of the call
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
      c.getArgument(7) = sink.asExpr()
    )
  }
}

module KeyLenTrace = DataFlow::Global<KeyLenConfig>;

from DataFlow::Node src, DataFlow::Node sink
where KeyLenTrace::flow(src, sink)
select sink.asExpr(),
  "Key size $@ is passed to this to KDF. Use at least 16 bytes for key length when deriving cryptographic key from password.",
  src.asExpr(), src.asExpr().getValue()
