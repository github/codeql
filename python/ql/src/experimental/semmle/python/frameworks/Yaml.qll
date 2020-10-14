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

  /** Provides models for the `yaml` module. */
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
private class YamlLoadCall extends Decoding::Range {
  YamlLoadCall() { this.asCfgNode().(CallNode).getFunction() = Yaml::yaml::load().asCfgNode() }

  /**
   * This function was thought safe from the 5.1 release in 2017, when the default loader was changed to `FullLoader`.
   * In 2020 new exploits were found, meaning it's not safe. The Current plan is to change the default to `SafeLoader` in release 6.0
   * (as explained in https://github.com/yaml/pyyaml/issues/420#issuecomment-696752389).
   * Until 6.0 is released, we will mark `yaml.load` as possibly leading to arbitrary code execution.
   * See https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation for more details.
   */
  override predicate unsafe() {
    // If the `Loader` is not set to either `SafeLoader` or `BaseLoader` or not set at all,
    // then the default loader will be used, which is not safe.
    not this.asCfgNode().(CallNode).getArgByName("Loader").(NameNode).getId() in ["SafeLoader",
          "BaseLoader"]
  }

  override DataFlow::Node getAnInput() {
    result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
  }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() { result = "YAML" }
}
