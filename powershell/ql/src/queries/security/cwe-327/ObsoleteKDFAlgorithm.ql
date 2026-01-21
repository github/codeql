/**
 * @name Use of obsolete Key Derivation Function (KDF) algorithm
 * @description Using obsolete or weak KDF algorithms like PasswordDeriveBytes (PBKDF1) 
 *              instead of secure alternatives like Rfc2898DeriveBytes (PBKDF2) can 
 *              compromise password security.
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
        this = API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("passwordderivebytes")
            .getMember("cryptderivekey")
            .asCall()
            or 
        this = API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("rfc2898derivebytes")
            .getMember("cryptderivekey")
            .asCall()
    }
}

// from DataFlow::CallNode cn 
// where
//     cn instanceof CryptDeriveKeyCall
// select cn, "Use of obsolete Crypto API. Consider using Rfc2898DeriveBytes (PBKDF2) or a more modern alternative like Argon2."

// from DataFlow::CallNode cn 
// select cn, "cn"
// from CryptDeriveKeyCall cn
// select cn, "Use of obsolete KDF algorithm PasswordDeriveBytes (PBKDF1). Consider using Rfc2898DeriveBytes (PBKDF2) or a more modern alternative like Argon2."

from DataFlow::CallNode apiNode
where 
apiNode = API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember("passwordderivebytes")
            .getMember("cryptderivekey").asCall()
select apiNode, "node"