/**
 * Definitions for reasoning about untrusted data used in APIs defined outside the
 * database.
 */

import go
private import Xss
private import SqlInjectionCustomizations
private import RequestForgeryCustomizations
private import CommandInjectionCustomizations
private import CleartextLoggingCustomizations
private import Logrus

/**
 * A `Function` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalAPIFunction extends Function { }

private predicate isDefaultSafePackage(Package package) {
  package.getPath() in ["time", "unicode/utf8", package("gopkg.in/go-playground/validator", "")]
}

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalAPIFunction extends SafeExternalAPIFunction {
  DefaultSafeExternalAPIFunction() {
    this instanceof BuiltinFunction or
    isDefaultSafePackage(this.getPackage()) or
    this.hasQualifiedName(package("gopkg.in/square/go-jose", "jwt"), "ParseSigned") or
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
class ExternalAPIDataNode extends DataFlow::Node {
  DataFlow::CallNode call;
  int i;

  ExternalAPIDataNode() {
    (
      // Argument to call to a function
      this = call.getArgument(i)
      or
      // Receiver to a call to a method which returns non trivial value
      this = call.getReceiver() and
      i = -1
    ) and
    // Not defined in the code that is being analysed
    not exists(call.getACallee().getBody()) and
    // Not a function pointer, unless it's declared at package scope
    not isProbableLocalFunctionPointer(call) and
    // Not defined in a test file
    not call.getFile() instanceof TestFile and
    // Not already modeled as a taint step
    not exists(DataFlow::Node next | TaintTracking::localTaintStep(this, next)) and
    // Not a call to a known safe external API
    not call.getTarget() instanceof SafeExternalAPIFunction
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

/** Gets the name of a package which has models. */
Package getAPackageWithModels() {
  result = getAPackageWithFunctionModels()
  or
  // An incomplete list of packages which have been modelled but do not have any function models
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
class UnknownExternalAPIDataNode extends ExternalAPIDataNode {
  UnknownExternalAPIDataNode() {
    // Not a sink for a commonly-used query
    not isACommonSink(this) and
    // Not in a package that has some functions modeled
    not call.getTarget().getPackage() = getAPackageWithModels()
  }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `ExternalAPIDataNode`s. */
class UntrustedDataToExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToExternalAPIConfig() { this = "UntrustedDataToExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExternalAPIDataNode }
}

/** A configuration for tracking flow from `RemoteFlowSource`s to `UnknownExternalAPIDataNode`s. */
class UntrustedDataToUnknownExternalAPIConfig extends TaintTracking::Configuration {
  UntrustedDataToUnknownExternalAPIConfig() { this = "UntrustedDataToUnknownExternalAPIConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnknownExternalAPIDataNode }
}

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalAPIDataNode extends ExternalAPIDataNode {
  UntrustedExternalAPIDataNode() { any(UntrustedDataToExternalAPIConfig c).hasFlow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() {
    any(UntrustedDataToExternalAPIConfig c).hasFlow(result, this)
  }
}

private newtype TExternalAPI =
  TExternalAPIParameter(Function m, int index) {
    exists(UntrustedExternalAPIDataNode n |
      m = n.getFunction() and
      index = n.getIndex()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalAPIUsedWithUntrustedData extends TExternalAPI {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalAPIDataNode getUntrustedDataNode() {
    this = TExternalAPIParameter(result.getFunction(), result.getIndex())
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
      this = TExternalAPIParameter(f, index) and
      if exists(f.getQualifiedName())
      then result = f.getQualifiedName() + " [" + indexString + "]"
      else result = f.getName() + " [" + indexString + "]"
    )
  }
}
