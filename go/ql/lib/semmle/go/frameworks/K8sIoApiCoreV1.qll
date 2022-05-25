/** Provides models of commonly used functions in the `k8s.io/api/core/v1` package. */

import go

/**
 * Provides models of commonly used functions in the `k8s.io/api/core/v1` package.
 */
module K8sIoApiCoreV1 {
  /** Gets the package name `k8s.io/api/core/v1`. */
  string packagePath() { result = package("k8s.io/api", "core/v1") }

  private class SecretDeepCopy extends TaintTracking::FunctionModel, Method {
    string methodName;
    FunctionOutput output;

    SecretDeepCopy() {
      (
        methodName in ["DeepCopy", "DeepCopyObject"] and output.isResult()
        or
        methodName = "DeepCopyInto" and output.isParameter(0)
      ) and
      this.hasQualifiedName(packagePath(), ["Secret", "SecretList"], methodName)
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp = outp
    }
  }

  private class SecretMarshal extends TaintTracking::FunctionModel, Method,
    MarshalingFunction::Range {
    SecretMarshal() { this.hasQualifiedName(packagePath(), ["Secret", "SecretList"], "Marshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }

  private class SecretUnmarshal extends TaintTracking::FunctionModel, Method,
    UnmarshalingFunction::Range {
    SecretUnmarshal() {
      this.hasQualifiedName(packagePath(), ["Secret", "SecretList"], "Unmarshal")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp = this.getAnInput() and outp = this.getOutput()
    }
  }
}
