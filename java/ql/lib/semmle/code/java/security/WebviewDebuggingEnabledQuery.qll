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
    subex.(MethodCall).getMethod().hasName("getProperty") and
    subex.(MethodCall).getAnArgument().(CompileTimeConstantExpr).getStringValue() = debug
  )
}

/**
 * DEPRECATED: Use `WebviewDebugEnabledFlow` instead.
 *
 * A configuration to find instances of `setWebContentDebuggingEnabled` called with `true` values.
 */
deprecated class WebviewDebugEnabledConfig extends DataFlow::Configuration {
  WebviewDebugEnabledConfig() { this = "WebviewDebugEnabledConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(BooleanLiteral).getBooleanValue() = true
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodCall ma |
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

/** A configuration to find instances of `setWebContentDebuggingEnabled` called with `true` values. */
module WebviewDebugEnabledConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr().(BooleanLiteral).getBooleanValue() = true
  }

  predicate isSink(DataFlow::Node node) {
    exists(MethodCall ma |
      ma.getMethod().hasQualifiedName("android.webkit", "WebView", "setWebContentsDebuggingEnabled") and
      node.asExpr() = ma.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(Guard debug | isDebugCheck(debug) and debug.controls(node.asExpr().getBasicBlock(), _))
    or
    node.getEnclosingCallable().getDeclaringType() instanceof NonSecurityTestClass
  }
}

/**
 * Tracks instances of `setWebContentDebuggingEnabled` with `true` values.
 */
module WebviewDebugEnabledFlow = DataFlow::Global<WebviewDebugEnabledConfig>;
