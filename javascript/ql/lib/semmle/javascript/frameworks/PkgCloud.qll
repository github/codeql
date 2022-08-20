/**
 * Provides classes for working with [pkgcloud](https://github.com/pkgcloud/pkgcloud) applications.
 */

import javascript

module PkgCloud {
  /**
   * Holds if the `i`th argument of `invk` is an object hash for pkgcloud client creation.
   */
  private predicate takesConfigurationObject(DataFlow::InvokeNode invk, int i) {
    exists(DataFlow::ModuleImportNode mod, DataFlow::SourceNode receiver, string type |
      mod.getPath() = "pkgcloud" and
      type =
        [
          "compute", "storage", "database", "dns", "blockstorage", "loadbalancer", "network",
          "orchestration", "cdn"
        ] and
      (
        // require('pkgcloud').compute
        receiver = mod.getAPropertyRead(type)
        or
        // require('pkgcloud').providers.joyent.compute
        receiver = mod.getAPropertyRead("providers").getAPropertyRead(_).getAPropertyRead(type)
      ) and
      invk = receiver.getAMemberCall("createClient") and
      i = 0
    )
  }

  /**
   * An expression that is used for authentication through pkgcloud.
   */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(string propertyName, DataFlow::InvokeNode invk, int i |
        takesConfigurationObject(invk, i) and
        this = invk.getOptionArgument(0, propertyName).asExpr()
      |
        /*
         * Catch-all support for the following providers:
         * - Amazon
         * - Azure
         * - DigitalOcean
         * - HP Helion
         * - Joyent
         * - OpenStack
         * - Rackspace
         * - IrisCouch
         * - MongoLab
         * - MongoHQ
         * - RedisToGo
         */

        kind = "user name" and
        propertyName = ["account", "keyId", "storageAccount", "username"]
        or
        kind = "password" and
        propertyName = ["key", "apiKey", "storageAccessKey", "password"]
        or
        kind = "token" and
        propertyName = "token"
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
