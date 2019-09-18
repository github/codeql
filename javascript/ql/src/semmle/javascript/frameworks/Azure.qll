/**
 * Provides classes for working with [Azure](https://github.com/Azure/azure-sdk-for-node) applications.
 */

import javascript

module Azure {
  /**
   * An expression that is used for authentication at Azure`.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(CallExpr mce, string methodName |
        (methodName = "loginWithUsernamePassword" or methodName = "loginWithServicePrincipalSecret") and
        mce = DataFlow::moduleMember("ms-rest-azure", methodName).getACall().asExpr()
      |
        this = mce.getArgument(0) and kind = "user name"
        or
        this = mce.getArgument(1) and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
