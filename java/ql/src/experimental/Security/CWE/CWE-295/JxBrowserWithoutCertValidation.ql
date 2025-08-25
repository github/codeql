/**
 * @name JxBrowser with disabled certificate validation
 * @description Insecure configuration of JxBrowser disables certificate
 *              validation making the app vulnerable to man-in-the-middle
 *              attacks.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/jxbrowser/disabled-certificate-validation
 * @tags security
 *       experimental
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow

/*
 * This query is version specific to JxBrowser < 6.24. The version is indirectly detected.
 * In version 6.x.x the `Browser` class is in a different package compared to version 7.x.x.
 */

/**
 * Holds if a safe JxBrowser 6.x.x version is used, such as version 6.24.
 * This is detected by the the presence of the `addBoundsListener` in the `Browser` class.
 */
private predicate isSafeJxBrowserVersion() {
  exists(Method m | m.getDeclaringType() instanceof JxBrowser | m.hasName("addBoundsListener"))
}

/** The `com.teamdev.jxbrowser.chromium.Browser` class. */
private class JxBrowser extends RefType {
  JxBrowser() { this.hasQualifiedName("com.teamdev.jxbrowser.chromium", "Browser") }
}

/** The `setLoadHandler` method on the `com.teamdev.jxbrowser.chromium.Browser` class. */
private class JxBrowserSetLoadHandler extends Method {
  JxBrowserSetLoadHandler() {
    this.hasName("setLoadHandler") and this.getDeclaringType() instanceof JxBrowser
  }
}

/** The `com.teamdev.jxbrowser.chromium.LoadHandler` interface. */
private class JxBrowserLoadHandler extends RefType {
  JxBrowserLoadHandler() { this.hasQualifiedName("com.teamdev.jxbrowser.chromium", "LoadHandler") }
}

private predicate isOnCertificateErrorMethodSafe(Method m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m |
    rs.getResult().(CompileTimeConstantExpr).getBooleanValue() = true
  )
}

/** A class that securely implements the `com.teamdev.jxbrowser.chromium.LoadHandler` interface. */
private class JxBrowserSafeLoadHandler extends RefType {
  JxBrowserSafeLoadHandler() {
    this.getASupertype() instanceof JxBrowserLoadHandler and
    exists(Method m | m.hasName("onCertificateError") and m.getDeclaringType() = this |
      isOnCertificateErrorMethodSafe(m)
    )
  }
}

/**
 * Models flow from the source `new Browser()` to a sink `browser.setLoadHandler(loadHandler)` where `loadHandler`
 * has been determined to be safe.
 */
private module JxBrowserFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(ClassInstanceExpr newJxBrowser | newJxBrowser.getConstructedType() instanceof JxBrowser |
      newJxBrowser = src.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma | ma.getMethod() instanceof JxBrowserSetLoadHandler |
      ma.getArgument(0).getType() instanceof JxBrowserSafeLoadHandler and
      ma.getQualifier() = sink.asExpr()
    )
  }
}

private module JxBrowserFlow = DataFlow::Global<JxBrowserFlowConfig>;

deprecated query predicate problems(DataFlow::Node src, string message) {
  JxBrowserFlowConfig::isSource(src) and
  not JxBrowserFlow::flow(src, _) and
  not isSafeJxBrowserVersion() and
  message = "This JxBrowser instance may not check HTTPS certificates."
}
