import go

private class NetHttpCookieType extends Type {
  NetHttpCookieType() { this.hasQualifiedName(package("net/http", ""), "Cookie") }
}

private class GinContextSetCookieMethod extends Method {
  GinContextSetCookieMethod() {
    this.hasQualifiedName(package("github.com/gin-gonic/gin", ""), "Context", "SetCookie")
  }
}

private class GorillaSessionOptionsField extends Field {
  GorillaSessionOptionsField() {
    this.hasQualifiedName(package("github.com/gorilla/sessions", ""), "Session", "Options")
  }
}

/**
 * A simplistic points-to alternative: given a struct creation and a field name, get the values that field can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
private DataFlow::Node getValueForFieldWrite(StructLit sl, string field) {
  exists(Write w, DataFlow::Node base, Field f |
    f.getName() = field and
    w.writesField(base, f, result) and
    (
      sl = base.asExpr()
      or
      base.asExpr() instanceof VariableName and
      base.getAPredecessor*().asExpr() = sl
    )
  )
}

/**
 * Holds if the expression or its value has a sensitive name
 */
private predicate isAuthVariable(Expr expr) {
  exists(string val |
    (
      val = expr.getStringValue() or
      val = expr.(Name).getTarget().getName()
    ) and
    val.regexpMatch("(?i).*(session|login|token|user|auth|credential).*") and
    not val.regexpMatch("(?i).*(xsrf|csrf|forgery).*")
  )
}

/**
 * A cookie passed as the second parameter to `net/http.SetCookie`.
 */
private class SetCookieSink extends DataFlow::Node {
  SetCookieSink() {
    exists(DataFlow::CallNode cn |
      cn.getTarget().hasQualifiedName(package("net/http", ""), "SetCookie") and
      this = cn.getArgument(1)
    )
  }
}

private module NameToNetHttpCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "Name") = pred and
      sl = succ.asExpr()
    )
  }
}

/** Tracks taint flow from sensitive names to `net/http.SetCookie`. */
module NameToNetHttpCookieTrackingFlow = TaintTracking::Global<NameToNetHttpCookieTrackingConfig>;

private module BoolToNetHttpCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      sl.getType() instanceof NetHttpCookieType and
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
  }
}

/**
 * Tracks taint flow from a `bool` assigned to `HttpOnly` to
 * `net/http.SetCookie`.
 */
module BoolToNetHttpCookieTrackingFlow = TaintTracking::Global<BoolToNetHttpCookieTrackingConfig>;

private module BoolToGinSetCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.getBoolValue() = false }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(6) = sink and
      exists(DataFlow::Node nameArg |
        NameToGinSetCookieTrackingFlow::flowTo(nameArg) and
        mcn.getArgument(0) = nameArg
      )
    )
  }
}

/**
 * Tracks data flow from `HttpOnly` set to `false` to
 * `gin-gonic/gin.Context.SetCookie`.
 */
module BoolToGinSetCookieTrackingFlow = DataFlow::Global<BoolToGinSetCookieTrackingConfig>;

private module NameToGinSetCookieTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isAuthVariable(source.asExpr()) }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::MethodCallNode mcn |
      mcn.getTarget() instanceof GinContextSetCookieMethod and
      mcn.getArgument(0) = sink
    )
  }
}

/**
 * Tracks taint flow from sensitive names to `gin-gonic/gin.Context.SetCookie`.
 */
private module NameToGinSetCookieTrackingFlow = DataFlow::Global<NameToGinSetCookieTrackingConfig>;

/**
 * The receiver of `gorilla/sessions.Session.Save` call.
 */
private class GorillaSessionSaveSink extends DataFlow::Node {
  GorillaSessionSaveSink() {
    exists(DataFlow::MethodCallNode mcn |
      this = mcn.getReceiver() and
      mcn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "Session", "Save")
    )
  }
}

private class GorillaStoreSaveSink extends DataFlow::Node {
  GorillaStoreSaveSink() {
    exists(DataFlow::MethodCallNode mcn |
      this = mcn.getArgument(2) and
      mcn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "CookieStore", "Save")
    )
  }
}

private module GorillaCookieStoreSaveTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source
        .(DataFlow::CallNode)
        .getTarget()
        .hasQualifiedName(package("github.com/gorilla/sessions", ""), "NewCookieStore")
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof GorillaSessionSaveSink or
    sink instanceof GorillaStoreSaveSink
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode cn |
      cn.getTarget()
          .hasQualifiedName(package("github.com/gorilla/sessions", ""), "CookieStore", "Get") and
      pred = cn.getReceiver() and
      succ = cn.getResult(0)
    )
  }
}

/**
 * Tracks data flow from gorilla cookie store creation to
 * `gorilla/sessions.Session.Save`.
 */
module GorillaCookieStoreSaveTrackingFlow = DataFlow::Global<GorillaCookieStoreSaveTrackingConfig>;

private module GorillaSessionOptionsTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName(package("github.com/gorilla/sessions", ""), "Options") and
      source.asExpr() = sl
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(GorillaSessionOptionsField f, DataFlow::Write w, DataFlow::Node base |
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}

/**
 * Tracks taint flow from session options to
 * `gorilla/sessions.Session.Save`.
 */
module GorillaSessionOptionsTrackingFlow =
  TaintTracking::Global<GorillaSessionOptionsTrackingConfig>;

private module BoolToGorillaSessionOptionsTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof GorillaSessionSaveSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StructLit sl |
      getValueForFieldWrite(sl, "HttpOnly") = pred and
      sl = succ.asExpr()
    )
    or
    exists(GorillaSessionOptionsField f, DataFlow::Write w, DataFlow::Node base |
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}

/**
 * Tracks taint flow from a `bool` assigned to `HttpOnly` to
 * `gorilla/sessions.Session.Save`.
 */
module BoolToGorillaSessionOptionsTrackingFlow =
  TaintTracking::Global<BoolToGorillaSessionOptionsTrackingConfig>;
