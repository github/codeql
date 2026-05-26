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
  abstract class RemoteFlowSource extends ThreatModelSource::Range {
    cached
    override string getThreatModel() { result = "remote" }

    /**
     * Holds if this can be a user-controlled object, such as a JSON object parsed from user-controlled data.
     */
    cached
    predicate isUserControlledObject() { none() }
  }

  /**
   * A source of remote input in a web browser environment.
   *
   * Note that this does not include `view-component-input` sources even if that threat model has been enabled by the user.
   * Consider using the predicate `ThreatModelSource#isClientSideSource()` to check for a broader class of client-side sources.
   */
  cached
  abstract class ClientSideRemoteFlowSource extends RemoteFlowSource {
    /** Gets a string indicating what part of the browser environment this was derived from. */
    cached
    abstract ClientSideRemoteFlowKind getKind();

    cached
    final override predicate isClientSideSource() { any() }
  }
}

import Cached

/**
 * A type of remote flow source that is specific to the browser environment.
 *
 * The underlying string also corresponds to a source kind.
 */
class ClientSideRemoteFlowKind extends string {
  ClientSideRemoteFlowKind() {
    this =
      [
        "browser", "browser-url-query", "browser-url-fragment", "browser-url-path", "browser-url",
        "browser-window-name", "browser-message-event"
      ]
  }

  /**
   * Holds if this is the `browser` kind, indicating a remote source in a browser context, that does not fit into one
   * of the more specific kinds.
   */
  predicate isGenericBrowserSourceKind() { this = "browser" }

  /**
   * Holds if this is the `browser-url-query` kind, describing sources derived from the query parameters of the browser URL,
   * such as `location.search`.
   */
  predicate isQuery() { this = "browser-url-query" }

  /**
   * Holds if this is the `browser-url-fragment` kind, describing sources derived from the fragment part of the browser URL,
   * such as `location.hash`.
   */
  predicate isFragment() { this = "browser-url-fragment" }

  /**
   * Holds if this is the `browser-url-path` kind, describing sources derived from the pathname of the browser URL,
   * such as `location.pathname`.
   */
  predicate isPath() { this = "browser-url-path" }

  /**
   * Holds if this is the `browser-url` kind, describing sources derived from the browser URL,
   * where the untrusted part of the URL is prefixed by trusted data, such as the scheme and hostname.
   */
  predicate isUrl() { this = "browser-url" }

  /** Holds if this is the `browser-url-query` or `browser-url-fragment` kind. */
  predicate isQueryOrFragment() { this.isQuery() or this.isFragment() }

  /** Holds if this is the `browser-url-path`, `browser-url-query`, or `browser-url-fragment` kind. */
  predicate isPathOrQueryOrFragment() { this.isPath() or this.isQuery() or this.isFragment() }

  /** Holds if this is the `browser-url-path` or `browser-url` kind. */
  predicate isPathOrUrl() { this.isPath() or this.isUrl() }

  /** Holds if this is the `browser-window-name` kind, describing sources derived from the window name, such as `window.name`. */
  predicate isWindowName() { this = "browser-window-name" }

  /**
   * Holds if this is the `browser-message-event` kind, describing sources derived from cross-window message passing,
   * such as `event` in `window.onmessage = event => {...}`.
   */
  predicate isMessageEvent() { this = "browser-message-event" }
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
overlay[local?]
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
overlay[local?]
private class ExternalRemoteFlowSourceSpecEntryPoint extends API::EntryPoint {
  string name;

  ExternalRemoteFlowSourceSpecEntryPoint() {
    name = any(RemoteFlowSourceAccessPath s).getRootPath() and
    this = "ExternalRemoteFlowSourceSpec " + name
  }

  string getName() { result = name }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef(name) }
}

/**
 * A remote flow source induced by a `RemoteFlowSourceAccessPath`.
 */
private class ExternalRemoteFlowSource extends RemoteFlowSource {
  RemoteFlowSourceAccessPath ap;

  ExternalRemoteFlowSource() { Stages::Taint::ref() and this = ap.resolve().asSource() }

  override string getSourceType() { result = ap.getSourceType() }
}
