/**
 * Provides classes for working with [AWS-SDK](https://aws.amazon.com/sdk-for-node-js/) applications.
 */

import javascript

module AWS {
  /**
   * Holds if the `i`th argument of `invk` is an object hash for `AWS.Config`.
   */
  private predicate takesConfigurationObject(InvokeExpr invk, int i) {
    exists(DataFlow::ModuleImportNode mod | mod.getPath() = "aws-sdk" |
      // `AWS.config.update(nd)`
      invk = mod.getAPropertyRead("config").getAMemberCall("update").asExpr() and
      i = 0
      or
      exists(DataFlow::SourceNode cfg | cfg = mod.getAConstructorInvocation("Config") |
        // `new AWS.Config(nd)`
        invk = cfg.asExpr() and
        i = 0
        or
        // `var config = new AWS.Config(...); config.update(nd);`
        invk = cfg.getAMemberCall("update").asExpr() and
        i = 0
      )
    )
  }

  /**
   * An expression that is used as an AWS config value: `{ accessKeyId: <user>, secretAccessKey: <password>}`.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string prop, InvokeExpr invk, int i |
        takesConfigurationObject(invk, i) and
        invk.hasOptionArgument(i, prop, this)
      |
        prop = "accessKeyId" and kind = "user name"
        or
        prop = "secretAccessKey" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
