/**
 * @name JXBrowser with disabled certificate validation
 * @description Insecure configuration of JXBrowser disables certificate validation making the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @id java/jxbrowser/disabled-certificate-validation
 * @tags security
 *       external/cwe-295
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking

/*
 * This query is version specific to JXBrowser 6.x.x. The version is indirectly detected.
 * In version 6.x.x the `Browser` class is in a different package compared to version 7.x.x.
 */

/** The `com.teamdev.jxbrowser.chromium.Browser` class. */
private class JXBrowser extends RefType {
  JXBrowser() { this.hasQualifiedName("com.teamdev.jxbrowser.chromium", "Browser") }
}

/** The `setLoadHandler` method on the `com.teamdev.jxbrowser.chromium.Browser` class. */
private class JXBrowserSetLoadHandler extends Method {
  JXBrowserSetLoadHandler() {
    this.hasName("setLoadHandler") and this.getDeclaringType() instanceof JXBrowser
  }
}

/** The `com.teamdev.jxbrowser.chromium.LoadHandler` interface. */
private class JXBrowserLoadHandler extends RefType {
  JXBrowserLoadHandler() { this.hasQualifiedName("com.teamdev.jxbrowser.chromium", "LoadHandler") }
}

private predicate isOnCertificateErrorMethodSafe(Method m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m |
    rs.getResult().(CompileTimeConstantExpr).getBooleanValue() = true
  )
}

/** A class that securely implements the `com.teamdev.jxbrowser.chromium.LoadHandler` interface. */
private class JXBrowserSafeLoadHandler extends RefType {
  JXBrowserSafeLoadHandler() {
    this.getASupertype() instanceof JXBrowserLoadHandler and
    exists(Method m | m.hasName("onCertificateError") and m.getDeclaringType() = this |
      isOnCertificateErrorMethodSafe(m)
    )
  }
}

private class JXBrowserTaintTracking extends TaintTracking::Configuration {
  JXBrowserTaintTracking() { this = "JXBrowserTaintTracking" }

  override predicate isSource(DataFlow::Node src) {
    exists(ClassInstanceExpr newJXBrowser | newJXBrowser.getConstructedType() instanceof JXBrowser |
      newJXBrowser = src.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma | ma.getMethod() instanceof JXBrowserSetLoadHandler |
      ma.getArgument(0).getType() instanceof JXBrowserSafeLoadHandler and
      ma.getQualifier() = sink.asExpr()
    )
  }
}

from JXBrowserTaintTracking cfg, DataFlow::Node src
where
  cfg.isSource(src) and
  not cfg.hasFlow(src, _)
select src, "This JXBrowser instance allows man-in-the-middle attacks."
