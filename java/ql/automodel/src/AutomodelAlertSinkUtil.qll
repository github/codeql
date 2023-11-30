private import java
private import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.RequestForgeryConfig
private import semmle.code.java.security.CommandLineQuery
private import semmle.code.java.security.SqlConcatenatedQuery
private import semmle.code.java.security.SqlInjectionQuery
private import semmle.code.java.security.UrlRedirectQuery
private import semmle.code.java.security.TaintedPathQuery
private import semmle.code.java.security.SqlInjectionQuery
private import AutomodelJavaUtil

private newtype TSinkModel =
  MkSinkModel(
    string package, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance
  ) {
    ExternalFlow::sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
  }

class SinkModel extends TSinkModel {
  string package;
  string type;
  boolean subtypes;
  string name;
  string signature;
  string ext;
  string input;
  string kind;
  string provenance;

  SinkModel() {
    this = MkSinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
  }

  /** Gets the package for this sink model. */
  string getPackage() { result = package }

  /** Gets the type for this sink model. */
  string getType() { result = type }

  /** Gets whether this sink model considers subtypes. */
  boolean getSubtypes() { result = subtypes }

  /** Gets the name for this sink model. */
  string getName() { result = name }

  /** Gets the signature for this sink model. */
  string getSignature() { result = signature }

  /** Gets the input for this sink model. */
  string getInput() { result = input }

  /** Gets the extension for this sink model. */
  string getExt() { result = ext }

  /** Gets the kind for this sink model. */
  string getKind() { result = kind }

  /** Gets the provenance for this sink model. */
  string getProvenance() { result = provenance }

  /** Gets the number of instances of this sink model. */
  int getInstanceCount() { result = count(PotentialSinkModelExpr p | p.getSinkModel() = this) }

  /** Gets a string representation of this sink model. */
  string toString() {
    result =
      "SinkModel(" + package + ", " + type + ", " + subtypes + ", " + name + ", " + signature + ", "
        + ext + ", " + input + ", " + kind + ", " + provenance + ")"
  }

  /** Gets a string representation of this sink model as it would appear in a Models-as-Data file. */
  string getRepr() {
    result =
      "\"" + package + "\", \"" + type + "\", " + pyBool(subtypes) + ", \"" + name + "\", \"" +
        signature + "\", \"" + ext + "\", \"" + input + "\", \"" + kind + "\", \"" + provenance +
        "\""
  }
}

/** An expression that may correspond to a sink model. */
class PotentialSinkModelExpr extends Expr {
  /**
   *  Holds if this expression has the given signature. The signature should contain enough
   *  information to determine a corresponding sink model, if one exists.
   */
  pragma[nomagic]
  predicate hasSignature(
    string package, string type, boolean subtypes, string name, string signature, string input
  ) {
    exists(Call call, Callable callable, int argIdx |
      call.getCallee().getSourceDeclaration() = callable and
      (
        this = call.getArgument(argIdx)
        or
        this = call.getQualifier() and argIdx = -1
      ) and
      (if argIdx = -1 then input = "Argument[this]" else input = "Argument[" + argIdx + "]") and
      package = callable.getDeclaringType().getPackage().getName() and
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = considerSubtypes(callable) and
      name = callable.getName() and
      signature = ExternalFlow::paramsString(callable)
    )
  }

  /** Gets a sink model that corresponds to this expression. */
  SinkModel getSinkModel() {
    this.hasSignature(result.getPackage(), result.getType(), result.getSubtypes(), result.getName(),
      result.getSignature(), result.getInput())
  }
}

private string pyBool(boolean b) {
  b = true and result = "True"
  or
  b = false and result = "False"
}

/**
 * Gets a string representation of the existing sink model at the expression `e`, in the format in
 * which it would appear in a Models-as-Data file. Also restricts the provenance of the sink model
 * to be `ai-generated`.
 */
string getSinkModelRepr(PotentialSinkModelExpr e) {
  result = e.getSinkModel().getRepr() and
  e.getSinkModel().getProvenance() = "ai-generated"
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

  predicate getSinkModelCount(int c, SinkModel s) {
    s = any(ConfigFlow::PathNode sink).getNode().asExpr().(PotentialSinkModelExpr).getSinkModel() and
    c =
      strictcount(ConfigFlow::PathNode sink |
        ConfigFlow::flowPath(_, sink) and
        s = sink.getNode().asExpr().(PotentialSinkModelExpr).getSinkModel()
      )
  }
}

predicate sinkModelTallyPerQuery(string queryName, int alertCount, SinkModel sinkModel) {
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

predicate sinkModelTally(int alertCount, SinkModel sinkModel) {
  sinkModelTallyPerQuery(_, _, sinkModel) and
  alertCount = sum(int c | sinkModelTallyPerQuery(_, c, sinkModel))
}
