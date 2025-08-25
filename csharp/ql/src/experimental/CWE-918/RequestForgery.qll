deprecated module;

import csharp

module RequestForgery {
  import semmle.code.csharp.controlflow.Guards
  import semmle.code.csharp.frameworks.System
  import semmle.code.csharp.frameworks.system.Web
  import semmle.code.csharp.frameworks.Format
  import semmle.code.csharp.security.dataflow.flowsources.FlowSources

  /**
   * A data flow source for server side request forgery vulnerabilities.
   */
  abstract private class Source extends DataFlow::Node { }

  /**
   * A data flow sink for server side request forgery vulnerabilities.
   */
  abstract private class Sink extends DataFlow::ExprNode { }

  /**
   * A data flow Barrier that blocks the flow of taint for
   * server side request forgery vulnerabilities.
   */
  abstract private class Barrier extends DataFlow::Node { }

  /**
   * A data flow configuration for detecting server side request forgery vulnerabilities.
   */
  private module RequestForgeryFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isAdditionalFlowStep(DataFlow::Node prev, DataFlow::Node succ) {
      interpolatedStringFlowStep(prev, succ)
      or
      stringReplaceStep(prev, succ)
      or
      uriCreationStep(prev, succ)
      or
      formatConvertStep(prev, succ)
      or
      toStringStep(prev, succ)
      or
      stringConcatStep(prev, succ)
      or
      stringFormatStep(prev, succ)
      or
      pathCombineStep(prev, succ)
    }

    predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }
  }

  /**
   * A data flow module for detecting server side request forgery vulnerabilities.
   */
  module RequestForgeryFlow = DataFlow::Global<RequestForgeryFlowConfig>;

  /**
   * A dataflow source for Server Side Request Forgery(SSRF) Vulnerabilities.
   */
  private class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

  /**
   * An url argument to a `HttpRequestMessage` constructor call
   * taken as a sink for Server Side Request Forgery(SSRF) Vulnerabilities.
   */
  private class SystemWebHttpRequestMessageSink extends Sink {
    SystemWebHttpRequestMessageSink() {
      exists(Class c | c.hasFullyQualifiedName("System.Net.Http", "HttpRequestMessage") |
        c.getAConstructor().getACall().getArgument(1) = this.asExpr()
      )
    }
  }

  /**
   * An argument to a `WebRequest.Create` call taken as a
   * sink for Server Side Request Forgery(SSRF) Vulnerabilities. *
   */
  private class SystemNetWebRequestCreateSink extends Sink {
    SystemNetWebRequestCreateSink() {
      exists(Method m |
        m.getDeclaringType().hasFullyQualifiedName("System.Net", "WebRequest") and
        m.hasName("Create")
      |
        m.getACall().getArgument(0) = this.asExpr()
      )
    }
  }

  /**
   * An argument to a new HTTP Request call of a `System.Net.Http.HttpClient` object
   * taken as a sink for Server Side Request Forgery(SSRF) Vulnerabilities.
   */
  private class SystemNetHttpClientSink extends Sink {
    SystemNetHttpClientSink() {
      exists(Method m |
        m.getDeclaringType().hasFullyQualifiedName("System.Net.Http", "HttpClient") and
        m.hasName([
            "DeleteAsync", "GetAsync", "GetByteArrayAsync", "GetStreamAsync", "GetStringAsync",
            "PatchAsync", "PostAsync", "PutAsync"
          ])
      |
        m.getACall().getArgument(0) = this.asExpr()
      )
    }
  }

  /**
   * An url argument to a method call of a `System.Net.WebClient` object
   * taken as a sink for Server Side Request Forgery(SSRF) Vulnerabilities.
   */
  private class SystemNetClientBaseAddressSink extends Sink {
    SystemNetClientBaseAddressSink() {
      exists(Property p, Type t |
        p.hasName("BaseAddress") and
        t = p.getDeclaringType() and
        (
          t.hasFullyQualifiedName("System.Net", "WebClient") or
          t.hasFullyQualifiedName("System.Net.Http", "HttpClient")
        )
      |
        p.getAnAssignedValue() = this.asExpr()
      )
    }
  }

  /**
   * A method call which checks the base of the tainted uri is assumed
   * to be a guard for Server Side Request Forgery(SSRF) Vulnerabilities.
   * This guard considers all checks as valid.
   */
  private predicate baseUriGuard(Guard g, Expr e, AbstractValue v) {
    g.(MethodCall).getTarget().hasFullyQualifiedName("System", "Uri", "IsBaseOf") and
    // we consider any checks against the tainted value to sainitize the taint.
    // This implies any check such as shown below block the taint flow.
    // Uri url = new Uri("whitelist.com")
    // if (url.isBaseOf(`taint1))
    (e = g.(MethodCall).getArgument(0) or e = g.(MethodCall).getQualifier()) and
    v.(AbstractValues::BooleanValue).getValue() = true
  }

  private class BaseUriBarrier extends Barrier {
    BaseUriBarrier() { this = DataFlow::BarrierGuard<baseUriGuard/3>::getABarrierNode() }
  }

  /**
   * A method call which checks if the Uri starts with a white-listed string is assumed
   * to be a guard for Server Side Request Forgery(SSRF) Vulnerabilities.
   * This guard considers all checks as valid.
   */
  private predicate stringStartsWithGuard(Guard g, Expr e, AbstractValue v) {
    g.(MethodCall).getTarget().hasFullyQualifiedName("System", "String", "StartsWith") and
    // Any check such as the ones shown below
    // "https://myurl.com/".startsWith(`taint`)
    // `taint`.startsWith("https://myurl.com/")
    // are assumed to sainitize the taint
    (e = g.(MethodCall).getQualifier() or g.(MethodCall).getArgument(0) = e) and
    v.(AbstractValues::BooleanValue).getValue() = true
  }

  private class StringStartsWithBarrier extends Barrier {
    StringStartsWithBarrier() {
      this = DataFlow::BarrierGuard<stringStartsWithGuard/3>::getABarrierNode()
    }
  }

  private predicate stringFormatStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(FormatCall c | c.getArgument(0) = prev.asExpr() and c = succ.asExpr())
  }

  private predicate pathCombineStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodCall combineCall |
      combineCall.getTarget().hasFullyQualifiedName("System.IO", "Path", "Combine") and
      combineCall.getArgument(0) = prev.asExpr() and
      combineCall = succ.asExpr()
    )
  }

  private predicate uriCreationStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(ObjectCreation oc |
      oc.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Uri") and
      oc.getArgument(0) = prev.asExpr() and
      oc = succ.asExpr()
    )
  }

  private predicate interpolatedStringFlowStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(InterpolatedStringExpr i |
      // allow `$"http://{`taint`}/blabla/");"` or
      // allow `$"https://{`taint`}/blabla/");"`
      i.getText(0).getValue().matches(["http://", "http://"]) and
      i.getInsert(1) = prev.asExpr() and
      succ.asExpr() = i
      or
      // allow `$"{`taint`}/blabla/");"`
      i.getInsert(0) = prev.asExpr() and
      succ.asExpr() = i
    )
  }

  private predicate stringReplaceStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodCall mc, SystemStringClass s |
      mc = s.getReplaceMethod().getACall() and
      mc.getQualifier() = prev.asExpr() and
      succ.asExpr() = mc
    )
  }

  private predicate stringConcatStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(AddExpr a |
      a.getLeftOperand() = prev.asExpr()
      or
      a.getRightOperand() = prev.asExpr() and
      a.getLeftOperand().(StringLiteral).getValue() = ["http://", "https://"]
    |
      a = succ.asExpr()
    )
  }

  private predicate formatConvertStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(Method m |
      m.hasFullyQualifiedName("System", "Convert",
        ["FromBase64String", "FromHexString", "FromBase64CharArray"]) and
      m.getParameter(0) = prev.asParameter() and
      succ.asExpr() = m.getACall()
    )
  }

  private predicate toStringStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodCall ma |
      ma.getTarget().hasName("ToString") and
      ma.getQualifier() = prev.asExpr() and
      succ.asExpr() = ma
    )
  }
}
