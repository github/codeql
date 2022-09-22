/**
 * Provides classes for working with [DigitalOcean](https://www.npmjs.com/package/digitalocean) applications.
 */

import javascript

module DigitalOcean {
  /**
   * An expression that is used for authentication at DigitalOcean: `digitalocean.client(<token>)`.
   */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(DataFlow::CallNode mce |
        mce = DataFlow::moduleMember("digitalocean", "client").getACall()
      |
        this = mce.getArgument(0) and kind = "token"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
