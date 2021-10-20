/**
 * @name Leaking sensetive information through an implicit Intent.
 * @description An Android application uses implicit intents containing sensitive data
 *              in a way that exposes it to arbitrary applications on the device.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/sensitive-communication
 * @tags security
 *       external/cwe/cwe-927
 */

import java
import semmle.code.java.security.AndroidSensitiveCommunicationQuery
import DataFlow::PathGraph

from SensitiveBroadcastConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Sending $@ to broadcast.", source.getNode(),
  "sensitive information"
