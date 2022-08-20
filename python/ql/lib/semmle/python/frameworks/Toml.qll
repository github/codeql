/**
 * Provides classes modeling security-relevant aspects of the `toml` PyPI package.
 *
 * See
 * - https://pypi.org/project/toml/
 * - https://github.com/uiri/toml#api-reference
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `toml` PyPI package
 *
 * See
 * - https://pypi.org/project/toml/
 * - https://github.com/uiri/toml#api-reference
 */
private module Toml {
  /**
   * A call to `toml.loads`
   *
   * See https://github.com/uiri/toml#api-reference
   */
  private class TomlLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    TomlLoadsCall() {
      this = API::moduleImport("toml").getMember("loads").getACall()
      or
      this = API::moduleImport("toml").getMember("decoder").getMember("loads").getACall()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "TOML" }
  }

  /**
   * A call to `toml.load`
   *
   * See https://github.com/uiri/toml#api-reference
   */
  private class TomlLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    TomlLoadCall() {
      this = API::moduleImport("toml").getMember("load").getACall()
      or
      this = API::moduleImport("toml").getMember("decoder").getMember("load").getACall()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("f")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "TOML" }
  }

  /**
   * A call to `toml.dumps`
   *
   * See https://github.com/uiri/toml#api-reference
   */
  private class TomlDumpsCall extends Encoding::Range, DataFlow::CallCfgNode {
    TomlDumpsCall() {
      this = API::moduleImport("toml").getMember("dumps").getACall()
      or
      this = API::moduleImport("toml").getMember("encoder").getMember("dumps").getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("o")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "TOML" }
  }

  /**
   * A call to `toml.dump`
   *
   * See https://github.com/uiri/toml#api-reference
   */
  private class TomlDumpCall extends Encoding::Range, DataFlow::CallCfgNode {
    TomlDumpCall() {
      this = API::moduleImport("toml").getMember("dump").getACall()
      or
      this = API::moduleImport("toml").getMember("encoder").getMember("dump").getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("o")] }

    override DataFlow::Node getOutput() { result in [this.getArg(1), this.getArgByName("f")] }

    override string getFormat() { result = "TOML" }
  }
}
