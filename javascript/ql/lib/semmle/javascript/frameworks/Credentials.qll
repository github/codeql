/**
 * Provides a class for modeling expressions used to supply
 * credentials.
 */

import javascript

/**
 * DEPRECATED: Use `CredentialsNode` instead.
 * An expression whose value is used to supply credentials such
 * as a user name, a password, or a key.
 */
deprecated class CredentialsExpr extends Expr {
  CredentialsNode node;

  CredentialsExpr() { node.asExpr() = this }

  /**
   * Gets a description of the kind of credential this expression is used as,
   * such as `"user name"`, `"password"`, `"key"`.
   */
  deprecated string getCredentialsKind() { result = node.getCredentialsKind() }
}

/**
 * An expression whose value is used to supply credentials such
 * as a user name, a password, or a key.
 */
abstract class CredentialsNode extends DataFlow::Node {
  /**
   * Gets a description of the kind of credential this expression is used as,
   * such as `"user name"`, `"password"`, `"key"`.
   */
  abstract string getCredentialsKind();
}

private class CredentialsFromModel extends CredentialsNode {
  string kind;

  CredentialsFromModel() { this = ModelOutput::getASinkNode("credentials[" + kind + "]").asSink() }

  override string getCredentialsKind() { result = kind }
}
