/**
 * @name Insecure hash algorithm
 * @description Detects use of classically insecure hash algorithms.
 * @id java/quantum/examples/demo/insecure-hash
 * @kind problem
 * @problem.severity error
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::HashAlgorithmNode alg
where isInsecureHashType(alg.getHashType())
select alg, "Insecure hash algorithm: " + alg.getHashType().toString() + "."
