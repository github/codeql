/**
 * Provides classes modeling security-relevant aspects of the `Werkzeug` PyPI package.
 * See
 * - https://pypi.org/project/Werkzeug/
 * - https://werkzeug.palletsprojects.com/en/1.0.x/#werkzeug
 */

private import python
private import semmle.python.frameworks.Flask
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Werkzeug {
  module Datastructures {
    module Headers {
      class WerkzeugHeaderAddCall extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
        WerkzeugHeaderAddCall() {
          this.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() =
            API::moduleImport("werkzeug")
                .getMember("datastructures")
                .getMember("Headers")
                .getACall() and
          this.getFunction().(DataFlow::AttrRead).getAttributeName() = "add"
        }

        override DataFlow::Node getNameArg() { result = this.getArg(0) }

        override DataFlow::Node getValueArg() { result = this.getArg(1) }
      }
    }
  }
}
