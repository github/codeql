/**
 * Provides classes modeling security-relevant aspects of the PyYAML package
 * https://pyyaml.org/wiki/PyYAMLDocumentation (obtained via `import yaml`).
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts

private module Yaml {
  /** Gets a reference to the `yaml` module. */
  private DataFlow::Node yaml(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("yaml")
    or
    exists(DataFlow::TypeTracker t2 | result = yaml(t2).track(t2, t))
  }

  /** Gets a reference to the `yaml` module. */
  DataFlow::Node yaml() { result = yaml(DataFlow::TypeTracker::end()) }

  /** Provides models for the `yaml` module. */
  module yaml {
    /**
     * Gets a reference to the attribute `attr_name` of the `yaml` module.
     * WARNING: Only holds for a few predefined attributes.
     *
     * For example, using `attr_name = "load"` will get all uses of `yaml.load`.
     */
    private DataFlow::Node yaml_attr(DataFlow::TypeTracker t, string attr_name) {
      attr_name in [
          // functions
          "load", "load_all", "full_load", "full_load_all", "unsafe_load", "unsafe_load_all",
          "safe_load", "safe_load_all",
          // Classes
          "SafeLoader", "BaseLoader"
        ] and
      (
        t.start() and
        result = DataFlow::importNode("yaml." + attr_name)
        or
        t.startInAttr(attr_name) and
        result = yaml()
      )
      or
      // Due to bad performance when using normal setup with `yaml_attr(t2, attr_name).track(t2, t)`
      // we have inlined that code and forced a join
      exists(DataFlow::TypeTracker t2 |
        exists(DataFlow::StepSummary summary |
          yaml_attr_first_join(t2, attr_name, result, summary) and
          t = t2.append(summary)
        )
      )
    }

    pragma[nomagic]
    private predicate yaml_attr_first_join(
      DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(yaml_attr(t2, attr_name), res, summary)
    }

    /**
     * Gets a reference to the attribute `attr_name` of the `yaml` module.
     * WARNING: Only holds for a few predefined attributes.
     *
     * For example, using `attr_name = "load"` will get all uses of `yaml.load`.
     */
    DataFlow::Node yaml_attr(string attr_name) {
      result = yaml_attr(DataFlow::TypeTracker::end(), attr_name)
    }
  }
}

/**
 * A call to any of the loading functions in `yaml` (`load`, `load_all`, `full_load`,
 * `full_load_all`, `unsafe_load`, `unsafe_load_all`, `safe_load`, `safe_load_all`)
 *
 * See https://pyyaml.org/wiki/PyYAMLDocumentation (you will have to scroll down).
 */
private class YamlLoadCall extends Decoding::Range, DataFlow::CfgNode {
  override CallNode node;
  string func_name;

  YamlLoadCall() {
    func_name in [
        "load", "load_all", "full_load", "full_load_all", "unsafe_load", "unsafe_load_all",
        "safe_load", "safe_load_all"
      ] and
    node.getFunction() = Yaml::yaml::yaml_attr(func_name).asCfgNode()
  }

  /**
   * This function was thought safe from the 5.1 release in 2017, when the default loader was changed to `FullLoader`.
   * In 2020 new exploits were found, meaning it's not safe. The Current plan is to change the default to `SafeLoader` in release 6.0
   * (as explained in https://github.com/yaml/pyyaml/issues/420#issuecomment-696752389).
   * Until 6.0 is released, we will mark `yaml.load` as possibly leading to arbitrary code execution.
   * See https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation for more details.
   */
  override predicate mayExecuteInput() {
    func_name in ["full_load", "full_load_all", "unsafe_load", "unsafe_load_all"]
    or
    func_name in ["load", "load_all"] and
    // If the `Loader` is not set to either `SafeLoader` or `BaseLoader` or not set at all,
    // then the default loader will be used, which is not safe.
    not exists(DataFlow::Node loader_arg |
      loader_arg.asCfgNode() in [node.getArg(1), node.getArgByName("Loader")]
    |
      loader_arg = Yaml::yaml::yaml_attr(["SafeLoader", "BaseLoader"])
    )
  }

  override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() { result = "YAML" }
}
