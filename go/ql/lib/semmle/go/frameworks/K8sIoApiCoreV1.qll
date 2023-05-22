/** Provides models of commonly used functions in the `k8s.io/api/core/v1` package. */

import go

/**
 * Provides models of commonly used functions in the `k8s.io/api/core/v1` package.
 */
module K8sIoApiCoreV1 {
  /** Gets the package name `k8s.io/api/core/v1`. */
  string packagePath() { result = package("k8s.io/api", "core/v1") }

  private class SecretMarshal extends MarshalingFunction::Range, Method {
    SecretMarshal() { this.hasQualifiedName(packagePath(), ["Secret", "SecretList"], "Marshal") }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "protobuf" }
  }

  private class SecretUnmarshal extends UnmarshalingFunction::Range, Method {
    SecretUnmarshal() {
      this.hasQualifiedName(packagePath(), ["Secret", "SecretList"], "Unmarshal")
    }

    override DataFlow::FunctionInput getAnInput() { result.isReceiver() }

    override DataFlow::FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "protobuf" }
  }
}
