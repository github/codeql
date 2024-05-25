/**
 * Provides classes for working with [request](https://github.com/request/request) applications.
 */

import javascript

module Request {
  /** A credentials expression that is used for authentication. */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(DataFlow::ModuleImportNode mod, DataFlow::CallNode action |
        mod.getPath() = "request" and
        (
          // default form: `request(...)`
          action = mod.getAnInvocation()
          or
          // specialized form: `request.get(...)`
          action = mod.getAMemberCall(any(Http::RequestMethodName n).toLowerCase())
        )
      |
        exists(DataFlow::MethodCallNode auth, int argIndex |
          // request.get(url).auth('username', 'password', _, 'token');
          auth = action.getAMemberCall("auth") and
          this = auth.getArgument(argIndex)
        |
          argIndex = 0 and kind = "user name"
          or
          argIndex = 1 and kind = "password"
          or
          argIndex = 3 and kind = "token"
        )
        or
        exists(DataFlow::ObjectLiteralNode auth, string propertyName |
          // request.get(url, { auth: {user: 'username', pass: 'password', bearer: 'token'}})
          auth.flowsTo(action.getOptionArgument(1, "auth")) and
          auth.hasPropertyWrite(propertyName, this)
        |
          (propertyName = "user" or propertyName = "username") and
          kind = "user name"
          or
          (propertyName = "pass" or propertyName = "password") and
          kind = "password"
          or
          propertyName = "bearer" and kind = "token"
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }
}
