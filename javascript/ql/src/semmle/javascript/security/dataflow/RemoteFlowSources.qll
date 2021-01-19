/**
 * Provides a class for modelling sources of remote user input.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.dataflow.DOM

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();

  /**
   * Holds if this can be a user-controlled object, such as a JSON object parsed from user-controlled data.
   */
  predicate isUserControlledObject() { none() }
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
private class RemoteFlowSourceAccessPath extends JSONString {
  string sourceType;

  RemoteFlowSourceAccessPath() {
    exists(JSONObject specs |
      specs.isTopLevel() and
      this.getFile().getBaseName() = "codeql-javascript-remote-flow-sources.json" and
      this = specs.getPropValue(sourceType).(JSONArray).getElementValue(_) and
      this.getValue().regexpMatch("window(\\.\\w+)+")
    )
  }

  /** Gets the source type of this remote flow source. */
  string getSourceType() { result = sourceType }

  /** Gets the `i`th component of the access path specifying this remote flow source. */
  string getComponent(int i) {
    exists(string raw | raw = this.getValue().splitAt(".", i + 1) |
      i = 0 and
      result = "ExternalRemoteFlowSourceSpec " + raw
      or
      i > 0 and
      result = API::EdgeLabel::member(raw)
    )
  }

  /** Gets the index of the last component of this access path. */
  int getMaxComponentIndex() { result = max(int i | exists(getComponent(i))) }

  /**
   * Gets the API node to which the prefix of the access path up to and including `i` resolves.
   *
   * As a special base case, resolving up to -1 gives the root API node.
   */
  private API::Node resolveUpTo(int i) {
    i = -1 and
    result = API::root()
    or
    result = resolveUpTo(i - 1).getASuccessor(getComponent(i))
  }

  /** Gets the API node to which this access path resolves. */
  API::Use resolve() { result = resolveUpTo(getMaxComponentIndex()) }
}

/**
 * The global variable referenced by a `RemoteFlowSourceAccessPath`, declared as an API
 * entry point.
 */
private class ExternalRemoteFlowSourceSpecEntryPoint extends API::EntryPoint {
  string name;

  ExternalRemoteFlowSourceSpecEntryPoint() {
    this = any(RemoteFlowSourceAccessPath s).getComponent(0) and
    this = "ExternalRemoteFlowSourceSpec " + name
  }

  override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef(name) }

  override DataFlow::Node getARhs() { none() }
}

/**
 * A remote flow source induced by a `RemoteFlowSourceAccessPath`.
 */
private class ExternalRemoteFlowSource extends RemoteFlowSource {
  RemoteFlowSourceAccessPath ap;

  ExternalRemoteFlowSource() { this = ap.resolve().getAnImmediateUse() }

  override string getSourceType() { result = ap.getSourceType() }
}
