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

/**
 * DEPRECATED: Use the `PasswordSink` class instead.
 * Holds if callable `c` from a standard Java API expects a password parameter at index `i`.
 */
deprecated predicate javaApiCallablePasswordParam(Callable c, int i) {
  exists(PasswordSink sink, MethodCall mc |
    sink.asExpr() = mc.getArgument(i) and c = mc.getCallee()
  )
}

/**
 * DEPRECATED: Use the `UsernameSink` class instead.
 * Holds if callable `c` from a standard Java API expects a username parameter at index `i`.
 */
deprecated predicate javaApiCallableUsernameParam(Callable c, int i) {
  exists(UsernameSink sink, MethodCall mc |
    sink.asExpr() = mc.getArgument(i) and c = mc.getCallee()
  )
}

/**
 * DEPRECATED: Use the `CryptoKeySink` class instead.
 * Holds if callable `c` from a standard Java API expects a cryptographic key parameter at index `i`.
 */
deprecated predicate javaApiCallableCryptoKeyParam(Callable c, int i) {
  exists(CryptoKeySink sink, MethodCall mc |
    sink.asExpr() = mc.getArgument(i) and c = mc.getCallee()
  )
}

/**
 * DEPRECATED: Use the `CredentialsSinkNode` class instead.
 * Holds if callable `c` from a known API expects a credential parameter at index `i`.
 */
deprecated predicate otherApiCallableCredentialParam(Callable c, int i) {
  c.hasQualifiedName("javax.crypto.spec", "IvParameterSpec", "IvParameterSpec") and
  i = 0
}
