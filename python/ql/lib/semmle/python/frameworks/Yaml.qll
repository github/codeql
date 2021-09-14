/**
 * Provides classes modeling security-relevant aspects of the `PyYAML` PyPI package
 * (imported as `yaml`)
 *
 * See
 * - https://pyyaml.org/wiki/PyYAMLDocumentation
 * - https://pyyaml.docsforge.com/master/documentation/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `PyYAML` PyPI package
 * (imported as `yaml`)
 *
 * See
 * - https://pyyaml.org/wiki/PyYAMLDocumentation
 * - https://pyyaml.docsforge.com/master/documentation/
 */
private module Yaml {
  /**
   * A call to any of the loading functions in `yaml` (`load`, `load_all`, `full_load`,
   * `full_load_all`, `unsafe_load`, `unsafe_load_all`, `safe_load`, `safe_load_all`)
   *
   * See https://pyyaml.org/wiki/PyYAMLDocumentation (you will have to scroll down).
   */
  private class YamlLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    override CallNode node;
    string func_name;

    YamlLoadCall() {
      func_name in [
          "load", "load_all", "full_load", "full_load_all", "unsafe_load", "unsafe_load_all",
          "safe_load", "safe_load_all"
        ] and
      this = API::moduleImport("yaml").getMember(func_name).getACall()
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
        loader_arg in [this.getArg(1), this.getArgByName("Loader")]
      |
        loader_arg =
          API::moduleImport("yaml")
              .getMember(["SafeLoader", "BaseLoader", "CSafeLoader", "CBaseLoader"])
              .getAUse()
      )
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "YAML" }
  }
}
