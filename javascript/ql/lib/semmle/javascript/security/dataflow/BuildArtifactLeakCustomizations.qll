/**
 * Provides default sinks for reasoning about storage of sensitive information
 * in build artifact, as well as extension points for adding your own.
 */

import javascript

/**
 * Sinks for storage of sensitive information in build artifact.
 */
module BuildArtifactLeak {
  /**
   * A data flow sink for storage of sensitive information in a build artifact.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a data-flow label that leaks information for this sink.
     */
    DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /**
   * An instantiation of `webpack.DefintePlugin` that stores information in a compiled JavaScript file.
   */
  class WebpackDefinePluginSink extends Sink {
    WebpackDefinePluginSink() {
      this = DataFlow::moduleMember("webpack", "DefinePlugin").getAnInstantiation().getAnArgument()
    }
  }
}
