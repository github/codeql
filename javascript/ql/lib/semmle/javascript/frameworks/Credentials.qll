/**
 * Provides a class for modeling expressions used to supply
 * credentials.
 */

import javascript

/**
 * An expression whose value is used to supply credentials such
 * as a user name, a password, or a key.
 */
abstract class CredentialsNode extends DataFlow::Node {
  /**
   * Gets a description of the kind of credential this expression is used as,
   * such as `"user name"`, `"password"`, `"key"`, `"jwt key"`.
   */
  abstract string getCredentialsKind();
}

/** Companion module to the `CredentialsExpr` class. */
module CredentialsExpr {
  /** Normalizes a credentials kind, mapping `username` to `user name`. */
  bindingset[kind]
  string normalizeKind(string kind) {
    if kind = "username" then result = "user name" else result = kind
  }
}

private class CredentialsFromModel extends CredentialsNode {
  string kind;

  CredentialsFromModel() { this = ModelOutput::getASinkNode("credentials-" + kind).asSink() }

  override string getCredentialsKind() { result = CredentialsExpr::normalizeKind(kind) }
}
