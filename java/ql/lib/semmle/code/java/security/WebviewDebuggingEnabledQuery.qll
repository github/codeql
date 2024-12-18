/** Definitions for the Android Webview Debugging Enabled query */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.SecurityTests
private import semmle.code.java.dataflow.FlowSinks

/** Holds if `ex` looks like a check that this is a debug build. */
private predicate isDebugCheck(Expr ex) {
  exists(Expr subex, string debug |
    debug.toLowerCase().matches(["%debug%", "%test%"]) and
    subex.getParent*() = ex
  |
    subex.(VarAccess).getVariable().getName() = debug
    or
    subex.(MethodCall).getMethod().hasName("getProperty") and
    subex.(MethodCall).getAnArgument().(CompileTimeConstantExpr).getStringValue() = debug
  )
}

/**
 * A webview debug sink node.
 */
private class WebviewDebugSink extends ApiSinkNode {
  WebviewDebugSink() {
    exists(MethodCall ma |
      ma.getMethod().hasQualifiedName("android.webkit", "WebView", "setWebContentsDebuggingEnabled") and
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/** A configuration to find instances of `setWebContentDebuggingEnabled` called with `true` values. */
module WebviewDebugEnabledConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(BooleanLiteral).getBooleanValue() = true
  }

  predicate isSink(DataFlow::Node node) { node instanceof WebviewDebugSink }

  predicate isBarrier(DataFlow::Node node) {
    exists(Guard debug | isDebugCheck(debug) and debug.controls(node.asExpr().getBasicBlock(), _))
    or
    node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Tracks instances of `setWebContentDebuggingEnabled` with `true` values.
 */
module WebviewDebugEnabledFlow = DataFlow::Global<WebviewDebugEnabledConfig>;
