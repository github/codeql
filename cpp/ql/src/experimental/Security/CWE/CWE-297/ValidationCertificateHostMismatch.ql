/**
 * @name Validation certificate host mismatch.
 * @description Lack of certificate name validation allows any valid certificate to be used. And that can lead to disclosure.
 * @kind problem
 * @id cpp/validation-certificate-host-mismatch
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-297
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

predicate checkHostnameOlder1() {
  exists(FunctionCall fctmp1 |
    fctmp1.getTarget().hasName("X509_get_ext_d2i") and
    (
      exists(MacroInvocation mi1tmp, MacroInvocation mi2tmp |
        mi1tmp.getMacroName() = "sk_GENERAL_NAME_num" and
        mi2tmp.getMacroName() = "sk_GENERAL_NAME_value"
      )
      or
      exists(FunctionCall fctmp2, FunctionCall fctmp3 |
        fctmp2.getTarget().hasName("sk_GENERAL_NAME_num") and
        fctmp3.getTarget().hasName("sk_GENERAL_NAME_value")
      )
    )
  )
}

predicate checkHostnameOlder2() {
  exists(FunctionCall fctmp1, FunctionCall fctmp2, FunctionCall fctmp3, FunctionCall fctmp4 |
    globalValueNumber(fctmp1) = globalValueNumber(fctmp3.getArgument(0)) and
    globalValueNumber(fctmp2) = globalValueNumber(fctmp4.getArgument(0)) and
    fctmp1.getTarget().hasName("X509_get_subject_name") and
    fctmp2.getTarget().hasName("X509_get_subject_name") and
    fctmp3.getTarget().hasName("X509_NAME_get_text_by_NID") and
    fctmp4.getTarget().hasName("X509_NAME_get_text_by_NID")
  )
}

predicate checkHostnameUp110() {
  exists(FunctionCall fctmp1, FunctionCall fctmp2, FunctionCall fctmp3 |
    globalValueNumber(fctmp1.getArgument(0)) = globalValueNumber(fctmp2.getArgument(0)) and
    globalValueNumber(fctmp2.getArgument(0)) = globalValueNumber(fctmp3.getArgument(0)) and
    fctmp1.getTarget().hasName("SSL_set_hostflags") and
    fctmp2.getTarget().hasName("SSL_set1_host") and
    fctmp3.getTarget().hasName("SSL_set_verify")
  )
}

predicate checkHostnameUp102() {
  exists(FunctionCall fctmp1, FunctionCall fctmp2, FunctionCall fctmp3, FunctionCall fctmp4 |
    globalValueNumber(fctmp1.getArgument(0)) = globalValueNumber(fctmp4.getArgument(0)) and
    globalValueNumber(fctmp1) = globalValueNumber(fctmp2.getArgument(0)) and
    globalValueNumber(fctmp1) = globalValueNumber(fctmp3.getArgument(0)) and
    fctmp1.getTarget().hasName("SSL_get0_param") and
    fctmp2.getTarget().hasName("X509_VERIFY_PARAM_set_hostflags") and
    fctmp3.getTarget().hasName("X509_VERIFY_PARAM_set1_host") and
    fctmp4.getTarget().hasName("SSL_set_verify")
  )
}

predicate checkHostnameGnuTLS() {
  exists(FunctionCall functionCheckHost |
    functionCheckHost
        .getTarget()
        .hasName(["gnutls_x509_crt_check_hostname", "gnutls_x509_crt_check_hostname2"])
    or
    functionCheckHost.getTarget().hasName("gnutls_certificate_verify_peers3") and
    not functionCheckHost.getArgument(1).getValue() = "0"
  )
}

predicate checkHostnameBOOST1() {
  exists(FunctionCall functionCallBackForCheck |
    functionCallBackForCheck.getTarget().hasName("set_verify_callback")
  )
}

predicate checkHostnameBOOST2() {
  exists(FunctionCall functionCallBackForCheck |
    functionCallBackForCheck.getTarget().hasName("set_verify_callback") and
    not functionCallBackForCheck
        .getArgument(0)
        .(FunctionCall)
        .getTarget()
        .hasName(["rfc2818_verification", "host_name_verification"])
  )
}

from FunctionCall fc
where
  not checkHostnameOlder1() and
  not checkHostnameOlder2() and
  not checkHostnameUp110() and
  not checkHostnameUp102() and
  fc.getTarget().hasName(["SSL_set_verify", "SSL_get_peer_certificate", "SSL_get_verify_result"])
  or
  not checkHostnameGnuTLS() and
  fc.getTarget()
      .hasName([
          "gnutls_certificate_verify_peers", "gnutls_certificate_verify_peers2",
          "gnutls_certificate_verify_peers3"
        ])
  or
  (
    not checkHostnameBOOST1() or
    checkHostnameBOOST2()
  ) and
  fc.getTarget().hasName("set_verify_mode")
select fc.getEnclosingFunction(), "You may have missed checking the name of the certificate."
