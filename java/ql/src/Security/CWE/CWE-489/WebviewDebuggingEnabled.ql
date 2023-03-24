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
import semmle.code.java.security.WebviewDebuggingEnabledQuery
import WebviewDebugEnabledFlow::PathGraph

from WebviewDebugEnabledFlow::PathNode source, WebviewDebugEnabledFlow::PathNode sink
where WebviewDebugEnabledFlow::flowPath(source, sink)
select sink, source, sink, "Webview debugging is enabled."
