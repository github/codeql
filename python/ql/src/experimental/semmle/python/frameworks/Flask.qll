/**
 * Provides classes modeling security-relevant aspects of the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */

private import python
private import semmle.python.frameworks.Flask
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

module ExperimentalFlask {
  /**
   * A reference to either `flask.make_response` function, or the `make_response` method on
   * an instance of `flask.Flask`. This creates an instance of the `flask_response`
   * class (class-attribute on a flask application), which by default is
   * `flask.Response`.
   *
   * See
   * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response
   * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response
   */
  private API::Node flaskMakeResponse() {
    result =
      [API::moduleImport("flask"), Flask::FlaskApp::instance()]
          .getMember(["make_response", "jsonify", "make_default_options_response"])
  }

  /** Gets a reference to a header instance. */
  private DataFlow::LocalSourceNode headerInstance() {
    result = [Flask::Response::classRef(), flaskMakeResponse()].getReturn().getAMember().getAUse()
  }

  /** Gets a reference to a header instance call/subscript */
  private DataFlow::Node headerInstanceCall() {
    headerInstance() in [result.(DataFlow::AttrRead), result.(DataFlow::AttrRead).getObject()] or
    headerInstance().asExpr() = result.asExpr().(Subscript).getObject()
  }

  class FlaskHeaderDefinition extends DataFlow::Node, HeaderDeclaration::Range {
    DataFlow::Node headerInput;

    FlaskHeaderDefinition() {
      this.asCfgNode().(DefinitionNode) = headerInstanceCall().asCfgNode() and
      headerInput.asCfgNode() = this.asCfgNode().(DefinitionNode).getValue()
    }

    override DataFlow::Node getNameArg() { result.asExpr() = this.asExpr().(Subscript).getIndex() }

    override DataFlow::Node getValueArg() { result = headerInput }
  }

  private class FlaskMakeResponseExtend extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
    KeyValuePair item;

    FlaskMakeResponseExtend() {
      this.getFunction() = headerInstanceCall() and
      item = this.getArg(_).asExpr().(Dict).getAnItem()
    }

    override DataFlow::Node getNameArg() { result.asExpr() = item.getKey() }

    override DataFlow::Node getValueArg() { result.asExpr() = item.getValue() }
  }

  private class FlaskResponse extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
    KeyValuePair item;

    FlaskResponse() { this = Flask::Response::classRef().getACall() }

    override DataFlow::Node getNameArg() { result.asExpr() = item.getKey() }

    override DataFlow::Node getValueArg() { result.asExpr() = item.getValue() }
  }
}
