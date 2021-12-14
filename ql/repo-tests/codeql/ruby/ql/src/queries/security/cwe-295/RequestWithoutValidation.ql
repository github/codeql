/**
 * @name Request without certificate validation
 * @description Making a request without certificate validation can allow
 *              man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id rb/request-without-cert-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import ruby
import codeql.ruby.Concepts
import codeql.ruby.DataFlow

from HTTP::Client::Request request, DataFlow::Node disablingNode
where request.disablesCertificateValidation(disablingNode)
select request, "This request may run with $@.", disablingNode, "certificate validation disabled"
