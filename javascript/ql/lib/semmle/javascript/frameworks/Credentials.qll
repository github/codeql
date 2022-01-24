/**
 * Provides a class for modeling expressions used to supply
 * credentials.
 */

import javascript

/**
 * An expression whose value is used to supply credentials such
 * as a user name, a password, or a key.
 */
abstract class CredentialsExpr extends Expr {
  /**
   * Gets a description of the kind of credential this expression is used as,
   * such as `"user name"`, `"password"`, `"key"`.
   */
  abstract string getCredentialsKind();
}

private class CredentialsFromModel extends CredentialsExpr {
  string kind;

  CredentialsFromModel() {
    this = ModelOutput::getASinkNode("credentials[" + kind + "]").getARhs().asExpr()
  }

  override string getCredentialsKind() { result = kind }
}
