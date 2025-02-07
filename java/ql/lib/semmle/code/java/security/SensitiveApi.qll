/**
 * Provides predicates defining methods that consume sensitive data, such as usernames and passwords.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A node that represents the use of a credential.
 */
abstract class CredentialsSinkNode extends DataFlow::Node { }

/**
 * A node representing a password being passed to a method.
 */
class PasswordSink extends CredentialsSinkNode {
  PasswordSink() { sinkNode(this, "credentials-password") }
}

/**
 * A node representing a username being passed to a method.
 */
class UsernameSink extends CredentialsSinkNode {
  UsernameSink() { sinkNode(this, "credentials-username") }
}

/**
 * A node representing a cryptographic key being passed to a method.
 */
class CryptoKeySink extends CredentialsSinkNode {
  CryptoKeySink() { sinkNode(this, "credentials-key") }
}
