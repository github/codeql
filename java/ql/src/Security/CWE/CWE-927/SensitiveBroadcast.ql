/**
 * @name Broadcasting sensitive data to all Android applications
 * @description An Android application uses implicit intents to broadcast
 *              sensitive data to all applications without specifying any
 *              receiver permission.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/sensitive-broadcast
 * @tags security
 *       external/cwe/cwe-927
 */

import java
import semmle.code.java.security.AndroidSensitiveBroadcastQuery
import DataFlow::PathGraph

from SensitiveBroadcastConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Sending $@ to broadcast.", source.getNode(),
  "sensitive information"
