import go

/**
 * A simplistic points-to alternative: given a struct creation and a field name, get the values that field can be assigned.
 *
 * Assumptions:
 *    - we don't reassign the variable that the creation is stored in
 *    - we always access the creation through the same variable it is initially assigned to
 *
 * This should cover most typical patterns...
 */
DataFlow::Node getValueForFieldWrite(StructLit sl, string field) {
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
 * Tracks struct creation without `HttpOnly` to `SetCookie`.
 */
class HttpOnlyCookieTrackingConfiguration extends TaintTracking::Configuration {
  HttpOnlyCookieTrackingConfiguration() { this = "HttpOnlyCookieTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      source.asExpr() = sl and
      sl.getType().hasQualifiedName("net/http", "Cookie") and
      (
        not exists(DataFlow::Node rhs | rhs = getValueForFieldWrite(sl, "HttpOnly"))
        or
        exists(DataFlow::Node rhs |
          rhs = getValueForFieldWrite(sl, "HttpOnly") and
          rhs.getAPredecessor*().asExpr().getBoolValue() = false
        )
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }
}

/**
 * A cookie passed the second parameter to `SetCookie`.
 */
class SetCookieSink extends DataFlow::Node {
  SetCookieSink() {
    exists(CallExpr c |
      c.getTarget().hasQualifiedName("net/http", "SetCookie") and
      this.asExpr() = c.getArgument(1)
    )
  }
}

/**
 * Holds if the expression or its value has a sensitive name
 */
predicate isAuthVariable(Expr expr) {
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
 * Tracks if a variable with a sensitive name is used as a cookie name.
 */
class AuthCookieNameConfiguration extends TaintTracking::Configuration {
  AuthCookieNameConfiguration() { this = "AuthCookieNameConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      source.asExpr() = sl and
      sl.getType().hasQualifiedName("net/http", "Cookie") and
      exists(DataFlow::Node rhs |
        rhs = getValueForFieldWrite(sl, "Name") and
        isAuthVariable(rhs.getAPredecessor*().asExpr())
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetCookieSink }
}

/**
 * Tracks from gorilla cookie store creation to session save.
 */
class CookieStoreSaveTrackingConfiguration extends DataFlow::Configuration {
  CookieStoreSaveTrackingConfiguration() { this = "CookieStoreSaveTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(CallExpr c |
      source.asExpr() = c and
      c.getTarget().hasQualifiedName("github.com/gorilla/sessions", "NewCookieStore")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr c |
      sink.asExpr() = c.getCalleeExpr().(SelectorExpr).getBase() and
      c.getTarget().getQualifiedName() = "github.com/gorilla/sessions.Session.Save"
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
      f.getQualifiedName() = "github.com/gorilla/sessions.CookieStore.Get" and
      pred = cn.getReceiver() and
      succ = cn.getResult(0)
    )
  }
}

/**
 * Tracks session options to session save.
 */
class SessionOptionsTrackingConfiguration extends TaintTracking::Configuration {
  SessionOptionsTrackingConfiguration() { this = "SessionOptionsTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(StructLit sl |
      sl.getType().hasQualifiedName("github.com/gorilla/sessions", "Options") and
      source.asExpr() = sl
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr c |
      sink.asExpr() = c.getCalleeExpr().(SelectorExpr).getBase() and
      c.getTarget().getQualifiedName() = "github.com/gorilla/sessions.Session.Save"
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Field f, DataFlow::Write w, DataFlow::Node base |
      f.getQualifiedName() = "github.com/gorilla/sessions.Session.Options" and
      w.writesField(base, f, pred) and
      succ = base
    )
  }
}
