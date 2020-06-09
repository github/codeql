/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * storage of sensitive information in build artifact, as well as extension
 * points for adding your own.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.security.SensitiveActions::HeuristicNames

module BuildArtifactLeak {
  /**
   * A data flow sink for clear-text logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node {
    DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /**
   * An instantiation of `webpack.DefintePlugin` that stores information in a compiled JavaScript file.
   */
  class WebpackDefinePluginSink extends Sink {
    WebpackDefinePluginSink() {
      this =
        DataFlow::moduleMember("webpack", "DefinePlugin")
            .getAnInstantiation()
            .getAnArgument()
            .getALocalSource()
            .getAPropertySource()
    }
  }
}
