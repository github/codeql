/**
 * Provides modeling for the `Digest` module.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

/** Gets an API node for a Digest class that hashes using `algo`. */
private API::Node digest(Cryptography::HashingAlgorithm algo) {
  exists(string name | result = API::getTopLevelMember("Digest").getMember(name) |
    name = ["MD5", "SHA1", "SHA2", "RMD160"] and
    algo.matchesName(name)
  )
}

/** A call that hashes some input using a hashing algorithm from the `Digest` module. */
private class DigestCall extends Cryptography::CryptographicOperation::Range instanceof DataFlow::CallNode
{
  Cryptography::HashingAlgorithm algo;
  API::Node digestNode;

  DigestCall() {
    digestNode = digest(algo) and
    (
      this = digestNode.getAMethodCall(["hexdigest", "base64digest", "bubblebabble"])
      or
      this = digestNode.getAMethodCall("file") // it's directly hashing the contents of a file, but that's close enough for us.
      or
      this = digestNode.getInstance().getAMethodCall(["digest", "update", "<<"])
    )
  }

  override DataFlow::Node getInitialization() { result = digestNode.asSource() }

  override Cryptography::HashingAlgorithm getAlgorithm() { result = algo }

  override DataFlow::Node getAnInput() { result = super.getArgument(0) }

  override Cryptography::BlockMode getBlockMode() { none() }
}
