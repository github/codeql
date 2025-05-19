/**
 * @name Use iteration count at least 100k to prevent brute force attacks
 * @description When deriving cryptographic keys from user-provided inputs such as password, use sufficient iteration count (at least 100k).
 * This query traces constants of <100k to the iteration count parameter of CNG's BCryptDeriveKeyPBKDF2.
 * This query traces constants of less than the min length to the target parameter.
 * NOTE: if the constant is modified, or if a non-constant gets to the iteration count, this query will not flag these cases.
 *      The rationale currently is that this query is meant to validate common uses of key derivation.
 *      Non-common uses (modifying the iteration count somehow or getting the count from outside sources) are assumed to be intentional.
 * @kind problem
 * @id cpp/microsoft/public/kdf-low-iteration-count
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module IterationCountDataFlowConfig implements DataFlow::ConfigSig {
  /**
   * Defines the source for iteration count when it's coming from a fixed value
   * Any expression that has an assigned value < 100000 could be a source.
   */
  predicate isSource(DataFlow::Node src) { src.asExpr().getValue().toInt() < 100000 }

  predicate isSink(DataFlow::Node sink) {
    // iterations count is the 5th (0-based) argument of the call
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
      c.getArgument(5) = sink.asExpr()
    )
  }
}

module IterationCountDataFlow = DataFlow::Global<IterationCountDataFlowConfig>;

from DataFlow::Node src, DataFlow::Node sink
where IterationCountDataFlow::flow(src, sink)
select sink.asExpr(),
  "Iteration count $@ is passed to this to KDF. Use at least 100000 iterations when deriving cryptographic key from password.",
  src, src.asExpr().getValue()
