/**
 * @name Weak key derivation function configuration
 * @description Rfc2898DeriveBytes (PBKDF2) should use at least 100,000 iterations
 *              and a hash algorithm of SHA-256 or stronger to resist brute-force attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/weak-kdf-configuration
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       cryptography
 */

import powershell
import WeakKDFConfiguration

from WeakKdfConfig config
select config, config.getMessage()
