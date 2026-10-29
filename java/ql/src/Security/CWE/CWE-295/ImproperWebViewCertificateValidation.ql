/**
 * @name Android `WebView` that accepts all certificates
 * @description Trusting all certificates allows an attacker to perform a machine-in-the-middle attack.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/improper-webview-certificate-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.security.AndroidWebViewCertificateValidationQuery

from OnReceivedSslErrorMethod m
where trustsAllCerts(m)
select m, "This handler accepts all SSL certificates."
