/**
 * Provides classes modeling security-relevant aspects of the PyYAML package
 * https://pyyaml.org/wiki/PyYAMLDocumentation (obtained via `import yaml`).
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Yaml {
  /** Gets a reference to the `yaml` module. */
  private DataFlow::Node yaml(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("yaml")
    or
    exists(DataFlow::TypeTracker t2 | result = yaml(t2).track(t2, t))
  }

  /** Gets a reference to the `yaml` module. */
  DataFlow::Node yaml() { result = yaml(DataFlow::TypeTracker::end()) }

  module yaml {
    /** Gets a reference to the `yaml.load` function. */
    private DataFlow::Node load(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("yaml", "load")
      or
      t.startInAttr("load") and
      result = yaml()
      or
      exists(DataFlow::TypeTracker t2 | result = load(t2).track(t2, t))
    }

    /** Gets a reference to the `yaml.load` function. */
    DataFlow::Node load() { result = load(DataFlow::TypeTracker::end()) }
  }
}

/**
 * A call to `yaml.load`
 * See https://pyyaml.org/wiki/PyYAMLDocumentation (you will have to scroll down).
 */
private class YamlDeserialization extends UnmarshalingFunction::Range {
  YamlDeserialization() {
    this.asCfgNode().(CallNode).getFunction() = Yaml::yaml::load().asCfgNode()
  }

  override predicate unsafe() {
    // If the `Loader` is not set to either `SafeLoader` or `BaseLoader` or not set at all,
    // then the default `Loader` will be used, which is not safe.
    not this.asCfgNode().(CallNode).getArgByName("Loader").(NameNode).getId() in ["SafeLoader",
          "BaseLoader"]
  }

  override DataFlow::Node getAnInput() {
    result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
  }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() { none() }
}
