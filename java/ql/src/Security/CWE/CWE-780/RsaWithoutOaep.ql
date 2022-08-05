/**
 * @name Use of RSA algorithm without OAEP
 * @description Using RSA encryption without OAEP padding can lead to a padding oracle attack, weakening the encryption.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/rsa-without-oaep
 * @tags security
 *       external/cwe/cwe-780
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.security.RsaWithoutOaepQuery

from CryptoAlgoSpec c
where rsaWithoutOaepCall(c)
select c, "This instance of RSA does not use OAEP padding."
