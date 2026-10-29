/**
 * Provides classes for working with [AWS-SDK](https://aws.amazon.com/sdk-for-node-js/) applications.
 */

import javascript

module AWS {
  /**
   * Holds if the `i`th argument of `invk` is an object hash for `AWS.Config`.
   */
  private predicate takesConfigurationObject(DataFlow::InvokeNode invk, int i) {
    exists(DataFlow::ModuleImportNode mod | mod.getPath() = "aws-sdk" |
      // `AWS.config.update(nd)`
      invk = mod.getAPropertyRead("config").getAMemberCall("update") and
      i = 0
      or
      exists(DataFlow::SourceNode cfg | cfg = mod.getAConstructorInvocation("Config") |
        // `new AWS.Config(nd)`
        invk = cfg and
        i = 0
        or
        // `var config = new AWS.Config(...); config.update(nd);`
        invk = cfg.getAMemberCall("update") and
        i = 0
      )
    )
  }

  /**
   * An expression that is used as an AWS config value: `{ accessKeyId: <user>, secretAccessKey: <password>}`.
   */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(string prop, DataFlow::InvokeNode invk, int i |
        takesConfigurationObject(invk, i) and
        this = invk.getOptionArgument(i, prop)
      |
        prop = "accessKeyId" and kind = "user name"
        or
        prop = "secretAccessKey" and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
