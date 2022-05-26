/**
 * Provides sources, sinks and sanitizers for reasoning about flow of
 * untrusted data into an external API.
 */

import javascript

/**
 * Provides sources, sinks and sanitizers for reasoning about flow of
 * untrusted data into an external API.
 */
module ExternalApiUsedWithUntrustedData {
  /**
   * A source of untrusted data.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * An input to an external API call.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a human-readable name for the external API which this value flows into.
     *
     * This has the form of a pseudo-access path leading to the sink. Some ambiguity
     * is tolerated in exchange for better readability here, as the user will typically
     * have to scan over many irrelevant sinks in order to pick out the interesting ones.
     */
    abstract string getApiName();
  }

  /**
   * A value that is treated as a generic deep object sink.
   *
   * By default, this includes the objects passed to a `PropertyProjection` or `ExtendCall`.
   *
   * Such objects tend to have lots of application-defined properties which don't represent
   * distinct API usages, so the query will avoid generating API names from them.
   */
  abstract class DeepObjectSink extends DataFlow::Node { }

  private class DefaultDeepObjectSink extends DeepObjectSink {
    DefaultDeepObjectSink() {
      this = any(PropertyProjection p).getObject()
      or
      this = any(ExtendCall c).getAnOperand()
    }
  }

  /** Holds if `node` corresponds to a deep object argument. */
  private predicate isDeepObjectSink(API::Node node) { node.getARhs() instanceof DeepObjectSink }

  /**
   * A sanitizer for data flowing to an external API.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  private class RemoteFlowAsSource extends Source {
    RemoteFlowAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A package name whose entire API is considered "safe" for the purpose of this query.
   */
  abstract class SafeExternalApiPackage extends string {
    SafeExternalApiPackage() { exists(API::moduleImport(this)) }
  }

  /** DEPRECATED: Alias for SafeExternalApiPackage */
  deprecated class SafeExternalAPIPackage = SafeExternalApiPackage;

  private class DefaultSafeExternalApiPackage extends SafeExternalApiPackage {
    DefaultSafeExternalApiPackage() {
      // Promise libraries are safe and generate too much noise if included
      this =
        [
          "bluebird", "q", "deferred", "when", "promise", "promises", "es6-promise",
          "promise-polyfill"
        ]
    }
  }

  /**
   * A function that is considered a "safe" external API from a security perspective.
   */
  abstract class SafeExternalApiFunction extends API::Node { }

  /** DEPRECATED: Alias for SafeExternalApiFunction */
  deprecated class SafeExternalAPIFunction = SafeExternalApiFunction;

  /** Holds if data read from a use of `f` may originate from an imported package. */
  private predicate mayComeFromLibrary(API::Node f) {
    // base case: import
    exists(string path |
      f = API::moduleImport(path) and
      not path instanceof SafeExternalApiPackage and
      // Exclude paths that can be resolved to a file in the project
      not exists(Import imprt |
        imprt.getImportedPath().getValue() = path and exists(imprt.getImportedModule())
      )
    )
    or
    // covariant recursive cases: instances, members, results, and promise contents
    // of something that comes from a library may themselves come from that library
    exists(API::Node base | mayComeFromLibrary(base) |
      f = base.getInstance() or
      f = base.getAMember() or
      f = base.getReturn() or
      f = base.getPromised()
    )
    or
    // contravariant recursive case: parameters of something that escapes to a library
    // may come from that library
    exists(API::Node base | mayEscapeToLibrary(base) | f = base.getAParameter())
  }

  /**
   * Holds if data written to a definition of `f` may flow to an imported package.
   */
  private predicate mayEscapeToLibrary(API::Node f) {
    // covariant recursive case: members, results, and promise contents of something that
    // escapes to a library may themselves escape to that library
    exists(API::Node base | mayEscapeToLibrary(base) and not isDeepObjectSink(base) |
      f = base.getAMember() or
      f = base.getPromised() or
      f = base.getReturn()
    )
    or
    // contravariant recursive case: arguments (other than the receiver) passed to a function
    // that comes from a library may escape to that library
    exists(API::Node base | mayComeFromLibrary(base) |
      f = base.getAParameter() and not f = base.getReceiver()
    )
  }

  /**
   * Holds if `node` may be part of an access path leading to an external API call.
   */
  private predicate nodeIsRelevant(API::Node node) {
    mayComeFromLibrary(node) and
    not node instanceof SafeExternalApiFunction
    or
    nodeIsRelevant(node.getASuccessor()) and
    not node = API::moduleImport(any(SafeExternalApiPackage p))
  }

  /** Holds if the edge `pred -> succ` may lead to an external API call. */
  private predicate edge(API::Node pred, API::Node succ) {
    nodeIsRelevant(succ) and
    pred.getASuccessor() = succ
  }

  /**
   * Gets the depth of `node` from the API graph root, not including paths that go through
   * irrelevant nodes, such as a package marked as safe.
   */
  private int getDepth(API::Node node) = shortestDistances(API::root/0, edge/2)(_, node, result)

  /**
   * Gets a parameter of `base` with name `name`, or a property named `name` of a destructuring parameter.
   */
  private API::Node getNamedParameter(API::Node base, string name) {
    exists(API::Node param |
      param = base.getAParameter() and
      not param = base.getReceiver()
    |
      result = param and
      name = param.getAnImmediateUse().asExpr().(Parameter).getName()
      or
      param.getAnImmediateUse().asExpr() instanceof DestructuringPattern and
      result = param.getMember(name)
    )
  }

  /**
   * Gets a simplified name for the access path leading to `node`.
   */
  private string getSimplifiedName(API::Node node) {
    node = API::moduleImport(result)
    or
    exists(API::Node base, string basename |
      getDepth(base) < getDepth(node) and basename = getSimplifiedName(base)
    |
      // In practice there is no need to distinguish between 'new X' and 'X()'
      node = [base.getInstance(), base.getReturn()] and
      result = basename + "()"
      or
      exists(string member |
        node = base.getMember(member) and
        not node = base.getUnknownMember() and
        not isNumericString(member) and
        not (member = "default" and base = API::moduleImport(_)) and
        not member = "then" // use the 'promised' edges for .then callbacks
      |
        if member.regexpMatch("[a-zA-Z_$]\\w*")
        then result = basename + "." + member
        else result = basename + "['" + member.regexpReplaceAll("'", "\\'") + "']"
      )
      or
      (
        node = base.getUnknownMember() or
        node = base.getMember(any(string s | isNumericString(s)))
      ) and
      result = basename + "[]"
      or
      // just collapse promises
      node = base.getPromised() and
      result = basename
      or
      // Name callback parameters after their name in the source code.
      // For example, the 'res' parameter in,
      //
      //   express.get('/foo', (req, res) => {...})`
      //
      // will be named `express().get.[callback].[param 'res']`
      exists(string paramName |
        node = getNamedParameter(base.getAParameter(), paramName) and
        result = basename + ".[callback].[param '" + paramName + "']"
        or
        exists(string callbackName, int index |
          node = getNamedParameter(base.getParameter(index).getMember(callbackName), paramName) and
          result =
            basename + ".[callback " + index + " '" + callbackName + "'].[param '" + paramName +
              "']"
        )
      )
    )
  }

  bindingset[str]
  private predicate isNumericString(string str) { exists(str.toInt()) }

  /**
   * Holds if `name` is the name of a built-in method on Object, Array, or String that
   * takes one or more arguments (methods not taking arguments are unlikely to be called
   * by a call that actually has arguments, so they are excluded).
   */
  private predicate isCommonBuiltinMethodName(string name) {
    exists(ExternalInstanceMemberDecl member |
      member.getBaseName() in ["Object", "Array", "String"] and
      name = member.getName() and
      member.getInit().(Function).getNumParameter() > 0
    )
  }

  /**
   * A call to an external API.
   */
  private class ExternalApiInvocation extends DataFlow::InvokeNode {
    API::Node callee;

    ExternalApiInvocation() {
      mayComeFromLibrary(callee) and
      this = callee.getAnInvocation() and
      // Ignore arguments to a method such as 'indexOf' that's likely called on a string or array value
      not isCommonBuiltinMethodName(this.(DataFlow::CallNode).getCalleeName()) and
      // Not already modeled as a flow/taint step
      not exists(DataFlow::Node arg |
        arg = this.getAnArgument() and not arg instanceof DeepObjectSink
      |
        TaintTracking::sharedTaintStep(arg, _) or
        DataFlow::SharedFlowStep::step(arg, _) or
        DataFlow::SharedFlowStep::step(arg, _, _, _) or
        DataFlow::SharedFlowStep::loadStep(arg, _, _) or
        DataFlow::SharedFlowStep::storeStep(arg, _, _) or
        DataFlow::SharedFlowStep::loadStoreStep(arg, _, _)
      )
    }

    /** Gets the API name representing this call. */
    string getApiName() { result = getSimplifiedName(callee) + "()" }
  }

  /**
   * Holds if `object` can be seen as a record of named arguments to a call.
   *
   * This holds for all object literals except deep object sinks.
   */
  private predicate isNamedArgumentObject(DataFlow::ObjectLiteralNode object) {
    not object instanceof DeepObjectSink
  }

  /** An argument to an external API call, seen as a sink. */
  private class DirectParameterSink extends Sink {
    ExternalApiInvocation invoke;
    int index;

    DirectParameterSink() {
      this = invoke.getArgument(index) and
      not isNamedArgumentObject(this) // handled by NamedParameterSink
      or
      this = invoke.getArgument(index).(DataFlow::ObjectLiteralNode).getASpreadProperty()
    }

    override string getApiName() { result = invoke.getApiName() + " [param " + index + "]" }
  }

  /** A spread argument or an unknown-index argument to an external API. */
  private class SpreadParameterSink extends Sink {
    ExternalApiInvocation invoke;

    SpreadParameterSink() {
      this = invoke.getASpreadArgument()
      or
      exists(InvokeExpr expr, int i | expr = invoke.asExpr() |
        this = expr.getArgument(i).flow() and
        expr.getArgument([0 .. i - 1]) instanceof SpreadElement
      )
    }

    override string getApiName() { result = invoke.getApiName() + " [param *]" }
  }

  /** A "named argument" to an external API call, seen as a sink. */
  private class NamedParameterSink extends Sink {
    ExternalApiInvocation invoke;
    int index;
    string prop;

    NamedParameterSink() {
      exists(DataFlow::ObjectLiteralNode object, DataFlow::PropWrite write |
        object = invoke.getArgument(index) and
        isNamedArgumentObject(object) and
        write = object.getAPropertyWrite() and
        this = write.getRhs() and
        (
          prop = write.getPropertyName()
          or
          not exists(write.getPropertyName()) and
          prop = "*"
        )
      )
    }

    override string getApiName() {
      result = invoke.getApiName() + " [param " + index + " '" + prop + "']"
    }
  }

  /** The return value from a direct callback to an external API call, seen as a sink */
  private class CallbackSink extends Sink {
    ExternalApiInvocation invoke;
    int index;

    CallbackSink() {
      this = invoke.getCallback(index).getAReturn() and
      // Exclude promise-related method names for callback-return sinks
      not invoke.getCalleeName() = ["then", "catch", "finally"]
    }

    override string getApiName() {
      result = invoke.getApiName() + " [callback " + index + " result]"
    }
  }

  /** The return value from a named callback to an external API call, seen as a sink. */
  private class NamedCallbackSink extends Sink {
    ExternalApiInvocation invoke;
    int index;
    string prop;

    NamedCallbackSink() {
      this =
        invoke
            .getOptionArgument(index, prop)
            .getALocalSource()
            .(DataFlow::FunctionNode)
            .getAReturn()
    }

    override string getApiName() {
      result = invoke.getApiName() + " [callback " + index + " '" + prop + "' result]"
    }
  }
}

/** DEPRECATED: Alias for ExternalApiUsedWithUntrustedData */
deprecated module ExternalAPIUsedWithUntrustedData = ExternalApiUsedWithUntrustedData;
