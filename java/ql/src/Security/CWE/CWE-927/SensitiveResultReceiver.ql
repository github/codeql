/**
 * @name Leaking sensitive information through a ResultReceiver
 * @description Sending sensitive data to a 'ResultReceiver' obtained from an untrusted source
 *              can allow malicious actors access to your information.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.2
 * @precision medium
 * @id java/android/sensitive-result-receiver
 * @tags security
 *       external/cwe/cwe-927
 */

import java
import semmle.code.java.security.SensitiveResultReceiverQuery
import DataFlow::PathGraph

from DataFlow::PathNode src, DataFlow::PathNode sink, DataFlow::Node recSrc
where sensitiveResultReceiver(src, sink, recSrc)
select sink, src, sink, "This $@ is sent to a ResultReceiver obtained from $@.", src,
  "sensitive information", recSrc, "this untrusted source"
