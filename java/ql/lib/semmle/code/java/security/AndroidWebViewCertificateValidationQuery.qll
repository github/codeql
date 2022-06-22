/** Defintions for the web view certificate validation query */

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

/** A call to `SslErrorHandler.cancel` */
private class SslCancelCall extends MethodAccess {
  SslCancelCall() {
    this.getMethod().hasQualifiedName("android.webkit", "SslErrorHandler", "cancel")
  }
}

/** A call to `SslErrorHandler.proceed` */
private class SslProceedCall extends MethodAccess {
  SslProceedCall() {
    this.getMethod().hasQualifiedName("android.webkit", "SslErrorHandler", "proceed")
  }
}

/** Holds if `m` trusts all certifiates by calling `SslErrorHandler.proceed` unconditionally. */
predicate trustsAllCerts(OnReceivedSslErrorMethod m) {
  exists(SslProceedCall pr | pr.getQualifier().(VarAccess).getVariable() = m.handlerArg()) and
  not exists(SslCancelCall ca | ca.getQualifier().(VarAccess).getVariable() = m.handlerArg())
}
