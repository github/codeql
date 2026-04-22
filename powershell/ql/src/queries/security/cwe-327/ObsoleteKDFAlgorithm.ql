/**
 * @name Use of obsolete Key Derivation Function (KDF) algorithm
 * @description Do not use obsolete or weak KDF algorithms like PasswordDeriveBytes (PBKDF1)
 *              instead of secure alternatives like Rfc2898DeriveBytes (PBKDF2)
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/obsolete-kdf-algorithm
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       cryptography
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow

class CryptDeriveKeyCall extends DataFlow::CallNode {
  CryptDeriveKeyCall() {
    this =
      API::getTopLevelMember("system")
          .getMember("security")
          .getMember("cryptography")
          .getMember(["passwordderivebytes", "rfc2898derivebytes"])
          .getInstance()
          .getMember("cryptderivekey")
          .asCall()
  }
}

from DataFlow::CallNode cn
where cn instanceof CryptDeriveKeyCall
select cn,
  "Use of obsolete Crypto API. Password-based key derivation should use the PBKDF2 algorithm with SHA-2 hashing"
