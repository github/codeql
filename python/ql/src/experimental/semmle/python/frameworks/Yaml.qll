/**
 * Provides classes modeling security-relevant aspects of the `yaml` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Yaml {
  /** Gets a reference to the `yaml` module. */
  DataFlow::Node yaml(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("yaml")
    or
    exists(DataFlow::TypeTracker t2 | result = yaml(t2).track(t2, t))
  }

  /** Gets a reference to the `yaml` module. */
  DataFlow::Node yaml() { result = yaml(DataFlow::TypeTracker::end()) }

  module yaml {
    /** Gets a reference to the `yaml.load` function. */
    DataFlow::Node load(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("yaml", "load")
      or
      t.startInAttr("load") and
      result = yaml()
      or
      exists(DataFlow::TypeTracker t2 | result = yaml::load(t2).track(t2, t))
    }

    /** Gets a reference to the `yaml.load` function. */
    DataFlow::Node load() { result = yaml::load(DataFlow::TypeTracker::end()) }
  }
}

/**
 * A call to `yaml.load`
 * See https://pyyaml.org/wiki/PyYAMLDocumentation
 */
private class YamlDeserialization extends DeserializationSink::Range {
  YamlDeserialization() {
    this.asCfgNode().(CallNode).getFunction() = Yaml::yaml::load().asCfgNode()
  }

  override DataFlow::Node getData() { result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0) }
}
