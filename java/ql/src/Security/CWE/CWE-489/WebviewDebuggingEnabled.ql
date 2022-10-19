/**
 * @name Android Webview debugging enabled
 * @description Enabling Webview debugging in production builds can expose entry points or leak sensitive information.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.2
 * @id java/android/webview-debugging-enabled
 * @tags security
 *       external/cwe/cwe-489
 * @precision high
 */

import java
import semmle.code.java.security.WebviewDubuggingEnabledQuery
import DataFlow::PathGraph

from WebviewDebugEnabledConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "Webview debugging is enabled."
