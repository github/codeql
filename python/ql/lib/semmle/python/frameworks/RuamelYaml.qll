/**
 * Provides classes modeling security-relevant aspects of the `ruamel.yaml` PyPI package
 *
 * See
 * - https://pypi.org/project/ruamel.yaml/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `ruamel.yaml` PyPI package.
 *
 * See
 * - https://pypi.org/project/ruamel.yaml/
 */
private module RuamelYaml {
  // Note: `ruamel.yaml` is a fork of the `PyYAML` PyPI package, so that's why the
  // interface is so similar.
  /**
   * A call to any of the loading functions in `yaml` (`load`, `load_all`, `safe_load`, `safe_load_all`)
   *
   * See https://pyyaml.org/wiki/PyYAMLDocumentation (you will have to scroll down).
   */
  private class RuamelYamlLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    string func_name;

    RuamelYamlLoadCall() {
      func_name in ["load", "load_all", "safe_load", "safe_load_all"] and
      this = API::moduleImport("ruamel").getMember("yaml").getMember(func_name).getACall()
    }

    override predicate mayExecuteInput() {
      func_name in ["load", "load_all"] and
      // If the `Loader` argument is not set, the default loader will be used, which is
      // not safe. The only safe loaders are `SafeLoader` or `BaseLoader` (and their
      // variants with C implementation).
      not exists(DataFlow::Node loader_arg |
        loader_arg in [this.getArg(1), this.getArgByName("Loader")]
      |
        loader_arg =
          API::moduleImport("ruamel")
              .getMember("yaml")
              .getMember(["SafeLoader", "BaseLoader", "CSafeLoader", "CBaseLoader"])
              .getAUse()
      )
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("stream")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "YAML" }
  }
}
