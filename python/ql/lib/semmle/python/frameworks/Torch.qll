/**
 * Provides classes modeling security-relevant aspects of the `torch` PyPI package.
 * See https://pypi.org/project/torch/.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `torch` PyPI package.
 * See https://pypi.org/project/torch/.
 */
private module Torch {
  /**
   * A call to `torch.load`
   * See https://pytorch.org/docs/stable/generated/torch.load.html#torch.load
   */
  private class TorchLoadCall extends Decoding::Range, API::CallNode {
    TorchLoadCall() { this = API::moduleImport("torch").getMember("load").getACall() }

    override predicate mayExecuteInput() {
      not exists(this.getParameter(2, "pickle_module").asSink()) or
      this.getParameter(2, "pickle_module").asSink().asExpr() instanceof None
    }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "f").asSink() }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  /**
   * A call to `torch.package.PackageImporter`
   * See https://pytorch.org/docs/stable/package.html#torch.package.PackageImporter
   */
  private class TorchPackageImporter extends Decoding::Range, API::CallNode {
    TorchPackageImporter() {
      this = API::moduleImport("torch").getMember("package").getMember("PackageImporter").getACall() and
      exists(this.getAMethodCall("load_pickle"))
    }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result = this.getParameter(0, "file_or_buffer").asSink()
    }

    override DataFlow::Node getOutput() { result = this.getAMethodCall("load_pickle") }

    override string getFormat() { result = "pickle" }
  }

  /**
   * A call to `torch.jit.load`
   * See https://pytorch.org/docs/stable/generated/torch.jit.load.html#torch.jit.load
   */
  private class TorchJitLoad extends Decoding::Range, API::CallNode {
    TorchJitLoad() {
      this = API::moduleImport("torch").getMember("jit").getMember("load").getACall()
    }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "f").asSink() }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }
}
