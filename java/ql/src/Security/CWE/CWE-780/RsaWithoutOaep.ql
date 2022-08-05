/**
 * @name Use of RSA algorithm without OAEP
 * @description Using RSA encryption without OAEP padding can lead to a padding oracle attack, weakening the encryption.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/rsa-without-oaep
 * @tags security
 *       external/cwe/cwe-780
 */

import java
import semmle.code.java.security.RsaWithoutOaepQuery

from MethodAccess ma
where rsaWithoutOaepCall(ma)
select ma, "This instance of RSA does not use OAEP padding."
