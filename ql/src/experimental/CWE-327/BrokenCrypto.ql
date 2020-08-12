/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @id go/broken-crypto
 * @tags security
 */

import go
import CryptoLibraries

from CryptographicOperation badcrypto
where badcrypto.getAlgorithm().isWeak()
select badcrypto, "Use of weak or broken cryptographic algorithm"
