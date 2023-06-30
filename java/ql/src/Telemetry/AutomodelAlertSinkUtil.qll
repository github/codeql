private import java
private import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.java.dataflow.internal.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.RequestForgeryConfig
private import semmle.code.java.security.CommandLineQuery
private import semmle.code.java.security.SqlConcatenatedQuery
private import semmle.code.java.security.SqlInjectionQuery
private import semmle.code.java.security.UrlRedirectQuery
private import semmle.code.java.security.TaintedPathQuery
private import semmle.code.java.security.SqlInjectionQuery
private import AutomodelJavaUtil

/** An expression that may correspond to a sink model. */
private class PotentialSinkModelExpr extends Expr {
  /**
   *  Holds if this expression has the given signature. The signature should contain enough
   *  information to determine a corresponding sink model, if one exists.
   */
  pragma[nomagic]
  predicate hasSignature(
    string package, string type, boolean subtypes, string name, string signature, string input
  ) {
    exists(Call call, Callable callable, int argIdx |
      call.getCallee() = callable and
      (
        this = call.getArgument(argIdx)
        or
        this = call.getQualifier() and argIdx = -1
      ) and
      input = getArgumentForIndex(argIdx) and
      package = callable.getDeclaringType().getPackage().getName() and
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = considerSubtypes(callable) and
      name = callable.getName() and
      signature = ExternalFlow::paramsString(callable)
    )
  }
}

private string pyBool(boolean b) {
  b = true and result = "True"
  or
  b = false and result = "False"
}

/**
 * Gets a string representation of the existing sink model at the expression `e`, in the format in
 * which it would appear in a Models-as-Data file.
 */
string getSinkModelRepr(PotentialSinkModelExpr e) {
  exists(
    string package, string type, boolean subtypes, string name, string signature, string input,
    string ext, string kind, string provenance
  |
    e.hasSignature(package, type, subtypes, name, signature, input) and
    ExternalFlow::sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance) and
    provenance = "ai-generated" and
    result =
      "\"" + package + "\", \"" + type + "\", " + pyBool(subtypes) + ", \"" + name + "\", \"" +
        signature + "\", \"" + ext + "\", \"" + input + "\", \"" + kind + "\", \"" + provenance +
        "\""
  )
}

/**
 * Gets the string representation of a sink model in a format suitable for appending to an alert
 * message.
 */
string getSinkModelQueryRepr(PotentialSinkModelExpr e) {
  result = "\nsinkModel: " + getSinkModelRepr(e)
}

/**
 * A parameterised module that takes a dataflow config, and exposes a predicate for counting the
 * number of AI-generated sink models that appear in alerts for that query.
 */
private module SinkTallier<DataFlow::ConfigSig Config> {
  module ConfigFlow = TaintTracking::Global<Config>;

  predicate getSinkModelCount(int c, string s) {
    s = getSinkModelRepr(any(ConfigFlow::PathNode sink).getNode().asExpr()) and
    c =
      strictcount(ConfigFlow::PathNode sink |
        ConfigFlow::flowPath(_, sink) and
        s = getSinkModelRepr(sink.getNode().asExpr())
      )
  }
}

predicate sinkModelTallyPerQuery(string queryName, int alertCount, string sinkModel) {
  queryName = "java/request-forgery" and
  SinkTallier<RequestForgeryConfig>::getSinkModelCount(alertCount, sinkModel)
  or
  queryName = "java/command-line-injection" and
  exists(int c1, int c2 |
    SinkTallier<RemoteUserInputToArgumentToExecFlowConfig>::getSinkModelCount(c1, sinkModel) and
    SinkTallier<LocalUserInputToArgumentToExecFlowConfig>::getSinkModelCount(c2, sinkModel) and
    alertCount = c1 + c2
  )
  or
  queryName = "java/concatenated-sql-query" and
  SinkTallier<UncontrolledStringBuilderSourceFlowConfig>::getSinkModelCount(alertCount, sinkModel)
  or
  queryName = "java/ssrf" and
  SinkTallier<RequestForgeryConfig>::getSinkModelCount(alertCount, sinkModel)
  or
  queryName = "java/path-injection" and
  SinkTallier<TaintedPathConfig>::getSinkModelCount(alertCount, sinkModel)
  or
  queryName = "java/unvalidated-url-redirection" and
  SinkTallier<UrlRedirectConfig>::getSinkModelCount(alertCount, sinkModel)
  or
  queryName = "java/sql-injection" and
  SinkTallier<QueryInjectionFlowConfig>::getSinkModelCount(alertCount, sinkModel)
}

predicate sinkModelTally(int alertCount, string sinkModel) {
  sinkModelTallyPerQuery(_, _, sinkModel) and
  alertCount = sum(int c | sinkModelTallyPerQuery(_, c, sinkModel))
}
