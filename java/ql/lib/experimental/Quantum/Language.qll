private import codeql.cryptography.Model
private import java as Language
private import semmle.code.java.security.InsecureRandomnessQuery
private import semmle.code.java.security.RandomQuery

private class UnknownLocation extends Language::Location {
  UnknownLocation() { this.getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
private class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

module CryptoInput implements InputSig<Language::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Language::Element;

  class UnknownLocation = UnknownDefaultLocation;
}

/**
 * Instantiate the model
 */
module Crypto = CryptographyBase<Language::Location, CryptoInput>;

/**
 * Random number generation, where each instance is modelled as the expression
 * tied to an output node (i.e., the result of the source of randomness)
 */
abstract class RandomnessInstance extends Crypto::RandomNumberGenerationInstance {
  override DataFlow::Node asOutputData() { result.asExpr() = this }
}

class SecureRandomnessInstance extends RandomnessInstance {
  SecureRandomnessInstance() {
    exists(RandomDataSource s | this = s.getOutput() |
      s.getSourceOfRandomness() instanceof SecureRandomNumberGenerator
    )
  }
}

class InsecureRandomnessInstance extends RandomnessInstance {
  InsecureRandomnessInstance() { exists(InsecureRandomnessSource node | this = node.asExpr()) }
}

// Import library-specific modeling
import JCA
