/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import go
private import semmle.go.dataflow.FlowSummary
private import Xss
private import SqlInjectionCustomizations
private import RequestForgeryCustomizations
private import CommandInjectionCustomizations
private import CleartextLoggingCustomizations
private import Logrus

/**
 * A `Function` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalApiFunction extends Function { }

/**
 * A `Function` with one or more arguments that are considered "safe" from a security perspective.
 */
abstract class SafeExternalApiArgument extends Function {
  /**
   * Holds if `i` is a safe argument to this function.
   */
  abstract predicate isSafeArgument(int i);
}

private predicate isDefaultSafePackage(Package package) {
  package.getPath() in ["time", "unicode/utf8", package("gopkg.in/go-playground/validator", "")]
}

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalApiFunction extends SafeExternalApiFunction {
  DefaultSafeExternalApiFunction() {
    this instanceof BuiltinFunction or
    isDefaultSafePackage(this.getPackage()) or
    this.hasQualifiedName(package([
          "gopkg.in/square/go-jose", "gopkg.in/go-jose/go-jose", "github.com/square/go-jose",
          "github.com/go-jose/go-jose"
        ], "jwt"), "ParseSigned") or
    this.(Method).hasQualifiedName(Gorm::packagePath(), "DB", "Update") or
    this.hasQualifiedName("crypto/hmac", "Equal") or
    this.hasQualifiedName("crypto/subtle", "ConstantTimeCompare") or
    this.(Method).hasQualifiedName(package("golang.org/x/oauth2", ""), "Config", "Exchange") or
    this.hasQualifiedName(package("golang.org/x/crypto", "bcrypt"), "CompareHashAndPassword") or
    this.hasQualifiedName(package("golang.org/x/crypto", "bcrypt"), "GenerateFromPassword") or
    this.(Method).implements("hash", "Hash", "Sum") or
    this.(Method).implements("hash", "Hash32", "Sum32") or
    this.(Method).implements("hash", "Hash64", "Sum64") or
    this.hasQualifiedName("crypto/sha256", "Sum256") or
    this.hasQualifiedName("crypto/md5", "Sum") or
    this.hasQualifiedName("crypto/sha1", "Sum")
  }
}

private class DefaultSafeExternalApiFunctionArgument extends SafeExternalApiArgument {
  int index;

  DefaultSafeExternalApiFunctionArgument() {
    this.(Method).hasQualifiedName("net/http", "Header", ["Set", "Del"]) and index = -1
  }

  override predicate isSafeArgument(int i) { i = index }
}

/** Holds if `callNode` is a local function pointer. */
private predicate isProbableLocalFunctionPointer(DataFlow::CallNode callNode) {
  // Not a method call
  not callNode instanceof DataFlow::MethodCallNode and
  // Does not have a declared target function
  not exists(callNode.getTarget()) and
  // Does not appear to be in a package
  not callNode.getCall().getCalleeExpr().(QualifiedName).getBase() instanceof PackageName
}

/** A node representing data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node {
  DataFlow::CallNode call;
  int i;

  ExternalApiDataNode() {
    (
      // Argument to call to a function
      this = call.getArgument(i)
      or
      // Receiver to a call to a method which returns non trivial value
      this = call.getReceiver() and
      i = -1
    ) and
    // Not defined in the code that is being analyzed
    not exists(call.getACallee().getBody()) and
    // Not a function pointer, unless it's declared at package scope
    not isProbableLocalFunctionPointer(call) and
    // Not defined in a test file
    not call.getFile() instanceof TestFile and
    // Not already modeled as a taint step
    not TaintTracking::localTaintStep(this, _) and
    // Not a call to a known safe external API
    not call.getTarget() instanceof SafeExternalApiFunction and
    // Not a known safe argument to an external API
    not any(SafeExternalApiArgument seaa).isSafeArgument(i)
  }

  /** Gets the called API `Function`. */
  Function getFunction() { result.getACall() = call }

  /** Gets the index which is passed untrusted data (where -1 indicates the receiver). */
  int getIndex() { result = i }

  /** Gets the description of the function being called. */
  string getFunctionDescription() {
    // For methods, need to use `getReceiverBaseType` to avoid multiple values when the
    // receiver of the method is an embedded field in another type. Note also that
    // for non-methods, `getQualifiedName` isn't always defined, e.g. for built-in
    // functions or function variables. In those cases we cannot provide a package with
    // the function description.
    if this.getFunction() instanceof Method
    then
      result =
        this.getFunction().(Method).getReceiverBaseType().getQualifiedName() + "." +
          this.getFunction().getName()
    else
      if exists(this.getFunction().getQualifiedName())
      then result = this.getFunction().getQualifiedName()
      else result = call.getCalleeName()
  }
}

/** Gets the name of a method in package `p` which has a function model. */
TaintTracking::FunctionModel getAMethodModelInPackage(Package p) {
  p = result.getPackage() and
  result instanceof Method and
  // We model any method of the form "String() string"
  result.getName() != "String" and
  not exists(TaintTracking::FunctionModel baseMethod |
    baseMethod != result and result.(Method).implements(baseMethod)
  )
}

/** Gets the name of a package which has models for some functions. */
Package getAPackageWithFunctionModels() {
  exists(TaintTracking::FunctionModel f | not f instanceof Method | result = f.getPackage())
  or
  exists(getAMethodModelInPackage(result))
}

/** Gets the name of a package that has at least one SummarizedCallable. */
Package getAPackageWithSummarizedCallables() {
  result = any(SummarizedCallable c).asFunction().getPackage()
}

/** Gets the name of a package which has models. */
Package getAPackageWithModels() {
  result = getAPackageWithFunctionModels()
  or
  result = getAPackageWithSummarizedCallables()
  or
  // An incomplete list of packages which have been modeled but do not have any function models
  result.getPath() in [
      Logrus::packagePath(), GolangOrgXNetWebsocket::packagePath(), GorillaWebsocket::packagePath()
    ]
}

/** Holds if `n` is a sink for XSS, SQL injection or request forgery. */
predicate isACommonSink(DataFlow::Node n) {
  n instanceof SharedXss::Sink or
  n instanceof SqlInjection::Sink or
  n instanceof RequestForgery::Sink or
  n instanceof CommandInjection::Sink or
  n instanceof CleartextLogging::Sink
}

/** A node representing data being passed to an unknown external API. */
class UnknownExternalApiDataNode extends ExternalApiDataNode {
  UnknownExternalApiDataNode() {
    // Not a sink for a commonly-used query
    not isACommonSink(this) and
    // Not in a package that has some functions modeled
    not call.getTarget().getPackage() = getAPackageWithModels()
  }
}

private module UntrustedDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExternalApiDataNode }
}

/**
 * Tracks data flow from `ActiveThreatModelSource`s to `ExternalApiDataNode`s.
 */
module UntrustedDataToExternalApiFlow = DataFlow::Global<UntrustedDataConfig>;

private module UntrustedDataToUnknownExternalApiConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnknownExternalApiDataNode }
}

/**
 * Tracks data flow from `ActiveThreatModelSource`s to `UnknownExternalApiDataNode`s.
 */
module UntrustedDataToUnknownExternalApiFlow =
  DataFlow::Global<UntrustedDataToUnknownExternalApiConfig>;

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { UntrustedDataToExternalApiFlow::flow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { UntrustedDataToExternalApiFlow::flow(result, this) }
}

/** An external API which is used with untrusted data. */
private newtype TExternalApi =
  /** An untrusted API method `m` where untrusted data is passed at `index`. */
  TExternalApiParameter(Function m, int index) {
    exists(UntrustedExternalApiDataNode n |
      m = n.getFunction() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends TExternalApi {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    this = TExternalApiParameter(result.getFunction(), result.getIndex())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(Function f, int index, string indexString |
      if index = -1 then indexString = "receiver" else indexString = "param " + index
    |
      this = TExternalApiParameter(f, index) and
      if exists(f.getQualifiedName())
      then result = f.getQualifiedName() + " [" + indexString + "]"
      else result = f.getName() + " [" + indexString + "]"
    )
  }
}
