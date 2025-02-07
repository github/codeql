/**
 * @name Small KDF salt length.
 * @description KDF salts should be a minimum of 128 bits (16 bytes).
 * This query traces constants of less than the min length to the target parameter.
 * NOTE: if the constant is modified, or if a non-constant gets to the target, this query will not flag these cases.
 *      The rationale currently is that this query is meant to validate common uses of key derivation.
 *      Non-common uses (modifying the values somehow or getting the count from outside sources) are assumed to be intentional.
 * @kind problem
 * @id cpp/microsoft/public/kdf-small-salt-size
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module SaltLenConfig implements DataFlow::ConfigSig {
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
      c.getArgument(4) = sink.asExpr()
    )
  }
}

module SaltLenTrace = DataFlow::Global<SaltLenConfig>;

from DataFlow::Node src, DataFlow::Node sink
where SaltLenTrace::flow(src, sink)
select sink.asExpr(),
  "Salt size $@ is passed to this to KDF. Use at least 16 bytes for salt size when deriving cryptographic key from password.",
  src, src.asExpr().getValue()
