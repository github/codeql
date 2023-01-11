/**
 * @name Leaking sensitive information through a ResultReceiver
 * @description An Android application obtains a ResultReceiver from a
 *              third-party component and uses it to send sensitive data
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
