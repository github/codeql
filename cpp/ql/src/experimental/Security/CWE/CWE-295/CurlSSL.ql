/**
 * @name Disabled certifcate verification
 * @description Disabling SSL certificate verification of host or peer could expose the communication to man-in-the-middle(MITM) attacks.
 * @kind problem
 * @problem.severity warning
 * @id cpp/curl-disabled-ssl
 * @tags security
 *       external/cwe/cwe-295
 */

import cpp
import semmle.code.cpp.dataflow.new.TaintTracking

/** Models the `curl_easy_setopt` function call */
private class CurlSetOptCall extends FunctionCall {
  CurlSetOptCall() {
    exists(FunctionCall fc, Function f |
      f.hasGlobalOrStdName("curl_easy_setopt") and
      fc.getTarget() = f
    |
      this = fc
    )
  }
}

/** Models an access to any enum constant which could affect SSL verification */
private class CurlVerificationConstant extends EnumConstantAccess {
  CurlVerificationConstant() {
    exists(EnumConstant e | e.getName() = ["CURLOPT_SSL_VERIFYHOST", "CURLOPT_SSL_VERIFYPEER"] |
      e.getAnAccess() = this
    )
  }
}

from CurlSetOptCall c
where
  c.getArgument(1) = any(CurlVerificationConstant v) and
  c.getArgument(2).getValue() = "0"
select c, "This call disables Secure Socket Layer and could potentially lead to MITM attacks"
