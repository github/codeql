/** Provides models of commonly used functions in the `k8s.io/client-go/kubernetes/typed/core/v1` package. */

import go

/**
 * Provides models of commonly used functions in the `k8s.io/client-go/kubernetes/typed/core/v1`
 * package.
 */
module K8sIoClientGo {
  /** Gets the package name `k8s.io/client-go/kubernetes/typed/core/v1`. */
  string packagePath() { result = package("k8s.io/client-go", "kubernetes/typed/core/v1") }

  /**
   * A model of `SecretInterface` methods that are sources of secret data.
   */
  private class SecretInterfaceSourceMethod extends Method {
    SecretInterfaceSourceMethod() {
      this.implements(packagePath(), "SecretInterface", ["Get", "List", "Patch"])
    }
  }

  /**
   * A model of `SecretInterface` as a source of secret data.
   */
  class SecretInterfaceSource extends DataFlow::Node {
    SecretInterfaceSource() { this = any(SecretInterfaceSourceMethod g).getACall().getResult(0) }
  }
}
