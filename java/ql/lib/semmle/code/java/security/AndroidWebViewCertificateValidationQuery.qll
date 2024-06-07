/** Definitions for the web view certificate validation query */

import java

/** A method that overrides `WebViewClient.onReceivedSslError` */
class OnReceivedSslErrorMethod extends Method {
  OnReceivedSslErrorMethod() {
    this.overrides*(any(Method m |
        m.hasQualifiedName("android.webkit", "WebViewClient", "onReceivedSslError")
      ))
  }

  /** Gets the `SslErrorHandler` argument to this method. */
  Parameter handlerArg() { result = this.getParameter(1) }
}

/** A call to `SslErrorHandler.proceed` */
private class SslProceedCall extends MethodCall {
  SslProceedCall() {
    this.getMethod().hasQualifiedName("android.webkit", "SslErrorHandler", "proceed")
  }
}

/** Holds if `m` trusts all certificates by calling `SslErrorHandler.proceed` unconditionally. */
predicate trustsAllCerts(OnReceivedSslErrorMethod m) {
  exists(SslProceedCall pr | pr.getQualifier().(VarAccess).getVariable() = m.handlerArg() |
    pr.getBasicBlock().bbPostDominates(m.getBody().getBasicBlock())
  )
}
