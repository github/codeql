/** Definitions for the Android Webview Debugging Enabled query */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.SecurityTests

/** Holds if `ex` looks like a check that this is a debug build. */
private predicate isDebugCheck(Expr ex) {
  exists(Expr subex, string debug |
    debug.toLowerCase().matches(["%debug%", "%test%"]) and
    subex.getParent*() = ex
  |
    subex.(VarAccess).getVariable().getName() = debug
    or
    subex.(MethodAccess).getMethod().hasName("getProperty") and
    subex.(MethodAccess).getAnArgument().(CompileTimeConstantExpr).getStringValue() = debug
  )
}

/** A configuration to find instances of `setWebContentDebuggingEnabled` called with `true` values. */
class WebviewDebugEnabledConfig extends DataFlow::Configuration {
  WebviewDebugEnabledConfig() { this = "WebviewDebugEnabledConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(BooleanLiteral).getBooleanValue() = true
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("android.webkit", "WebView", "setWebContentsDebuggingEnabled") and
      node.asExpr() = ma.getArgument(0)
    )
  }

  override predicate isBarrier(DataFlow::Node node) {
    exists(Guard debug | isDebugCheck(debug) and debug.controls(node.asExpr().getBasicBlock(), _))
    or
    node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass
  }
}
