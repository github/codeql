import java

class OnReceivedSslErrorMethod extends Method {
  OnReceivedSslErrorMethod() {
    this.overrides*(any(Method m |
        m.hasQualifiedName("android.webkit", "WebViewClient", "onReceivedSslError")
      ))
  }

  Parameter handlerArg() { result = this.getParameter(1) }
}

private class SslCancelCall extends MethodAccess {
  SslCancelCall() {
    this.getMethod().hasQualifiedName("android.webkit", "SslErrorHandler", "cancel")
  }
}

private class SslProceedCall extends MethodAccess {
  SslProceedCall() {
    this.getMethod().hasQualifiedName("android.webkit", "SslErrorHandler", "proceed")
  }
}

predicate trustsAllCerts(OnReceivedSslErrorMethod m) {
  exists(SslProceedCall pr | pr.getQualifier().(VarAccess).getVariable() = m.handlerArg()) and
  not exists(SslCancelCall ca | ca.getQualifier().(VarAccess).getVariable() = m.handlerArg())
}
