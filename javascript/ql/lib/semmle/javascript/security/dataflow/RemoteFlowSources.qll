/**
 * Provides a class for modeling sources of remote user input.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.dataflow.DOM
private import semmle.javascript.internal.CachedStages

cached
private module Cached {
  /** A data flow source of remote user input. */
  cached
  abstract class RemoteFlowSource extends DataFlow::Node {
    /** Gets a human-readable string that describes the type of this remote flow source. */
    cached
    abstract string getSourceType();

    /**
     * Holds if this can be a user-controlled object, such as a JSON object parsed from user-controlled data.
     */
    cached
    predicate isUserControlledObject() { none() }
  }

  /**
   * A source of remote input in a web browser environment.
   */
  cached
  abstract class ClientSideRemoteFlowSource extends RemoteFlowSource {
    /** Gets a string indicating what part of the browser environment this was derived from. */
    cached
    abstract ClientSideRemoteFlowKind getKind();
  }
}

import Cached

/**
 * A type of remote flow source that is specific to the browser environment.
 */
class ClientSideRemoteFlowKind extends string {
  ClientSideRemoteFlowKind() { this = ["query", "fragment", "path", "url", "name"] }

  /**
   * Holds if this is the `query` kind, describing sources derived from the query parameters of the browser URL,
   * such as `location.search`.
   */
  predicate isQuery() { this = "query" }

  /**
   * Holds if this is the `frgament` kind, describing sources derived from the fragment part of the browser URL,
   * such as `location.hash`.
   */
  predicate isFragment() { this = "fragment" }

  /**
   * Holds if this is the `path` kind, describing sources derived from the pathname of the browser URL,
   * such as `location.pathname`.
   */
  predicate isPath() { this = "path" }

  /**
   * Holds if this is the `url` kind, describing sources derived from the browser URL,
   * where the untrusted part of the URL is prefixed by trusted data, such as the scheme and hostname.
   */
  predicate isUrl() { this = "url" }

  /** Holds if this is the `query` or `fragment` kind. */
  predicate isQueryOrFragment() { this.isQuery() or this.isFragment() }

  /** Holds if this is the `path`, `query`, or `fragment` kind. */
  predicate isPathOrQueryOrFragment() { this.isPath() or this.isQuery() or this.isFragment() }

  /** Holds if this is the `path` or `url` kind. */
  predicate isPathOrUrl() { this.isPath() or this.isUrl() }

  /** Holds if this is the `name` kind, describing sources derived from the window name, such as `window.name`. */
  predicate isWindowName() { this = "name" }
}

/**
 * A specification of a remote flow source in a JSON file included in the database.
 *
 * The JSON file must be named `codeql-javascript-remote-flow-sources.json` and consist of a JSON
 * object. The object's keys are source types (in the sense of `RemoteFlowSource.getSourceType()`),
 * each mapping to a list of strings. Each string in that list must be of the form `window.f.props`
 * where `f` is the name of a global variable, and `props` is a possibly empty sequence of property
 * names separated by dots. It declares any value stored in the given property sequece of `f` to be
 * a remote flow source of the type specified by the key.
 *
 * For example, consider the following specification:
 *
 * ```json
 * {
 *  "user input": [ "window.user.name", "window.user.address", "window.dob" ]
 * }
 * ```
 *
 * It declares that the contents of global variable `dob`, as well as the contents of properties
 * `name` and `address` of global variable `user` should be considered as remote flow sources with
 * source type "user input".
 */
private class RemoteFlowSourceAccessPath extends JsonString {
  string sourceType;

  RemoteFlowSourceAccessPath() {
    exists(JsonObject specs |
      specs.isTopLevel() and
      this.getFile().getBaseName() = "codeql-javascript-remote-flow-sources.json" and
      this = specs.getPropValue(sourceType).getElementValue(_) and
      this.getValue().regexpMatch("window(\\.\\w+)+")
    )
  }

  /** Gets the source type of this remote flow source. */
  string getSourceType() { result = sourceType }

  /** Gets the `i`th component of the access path specifying this remote flow source. */
  API::Label::ApiLabel getComponent(int i) {
    exists(string raw | raw = this.getValue().splitAt(".", i + 1) |
      i = 0 and
      result =
        API::Label::entryPoint(any(ExternalRemoteFlowSourceSpecEntryPoint e | e.getName() = raw))
      or
      i > 0 and
      result = API::Label::member(raw)
    )
  }

  /** Gets the first part of this access path. E.g. for "window.user.name" the result is "window". */
  string getRootPath() { result = this.getValue().splitAt(".", 1) }

  /** Gets the index of the last component of this access path. */
  int getMaxComponentIndex() { result = max(int i | exists(this.getComponent(i))) }

  /**
   * Gets the API node to which the prefix of the access path up to and including `i` resolves.
   *
   * As a special base case, resolving up to -1 gives the root API node.
   */
  private API::Node resolveUpTo(int i) {
    i = -1 and
    result = API::root()
    or
    result = this.resolveUpTo(i - 1).getASuccessor(this.getComponent(i))
  }

  /** Gets the API node to which this access path resolves. */
  API::Use resolve() { result = this.resolveUpTo(this.getMaxComponentIndex()) }
}

/**
 * The global variable referenced by a `RemoteFlowSourceAccessPath`, declared as an API
 * entry point.
 */
private class ExternalRemoteFlowSourceSpecEntryPoint extends API::EntryPoint {
  string name;

  ExternalRemoteFlowSourceSpecEntryPoint() {
    name = any(RemoteFlowSourceAccessPath s).getRootPath() and
    this = "ExternalRemoteFlowSourceSpec " + name
  }

  string getName() { result = name }

  override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef(name) }

  override DataFlow::Node getARhs() { none() }
}

/**
 * A remote flow source induced by a `RemoteFlowSourceAccessPath`.
 */
private class ExternalRemoteFlowSource extends RemoteFlowSource {
  RemoteFlowSourceAccessPath ap;

  ExternalRemoteFlowSource() { Stages::Taint::ref() and this = ap.resolve().getAnImmediateUse() }

  override string getSourceType() { result = ap.getSourceType() }
}
