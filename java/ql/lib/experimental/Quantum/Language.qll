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

  predicate rngToIvFlow(DataFlowNode rng, DataFlowNode iv) { none() }
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
  abstract Crypto::RNGSourceSecurity getSourceSecurity();

  Crypto::TRNGSeedSecurity getSeedSecurity(Location location) { none() }
}

class SecureRandomnessInstance extends RandomnessInstance {
  SecureRandomnessInstance() {
    exists(RandomDataSource s | this = s.getOutput() |
      s.getSourceOfRandomness() instanceof SecureRandomNumberGenerator
    )
  }

  override Crypto::RNGSourceSecurity getSourceSecurity() {
    result instanceof Crypto::RNGSourceSecure
  }
}

class InsecureRandomnessInstance extends RandomnessInstance {
  InsecureRandomnessInstance() { exists(InsecureRandomnessSource node | this = node.asExpr()) }

  override Crypto::RNGSourceSecurity getSourceSecurity() {
    result instanceof Crypto::RNGSourceInsecure
  }
}

class RandomnessArtifact extends Crypto::RandomNumberGeneration {
  RandomnessInstance instance;

  RandomnessArtifact() { this = Crypto::TRandomNumberGeneration(instance) }

  override Location getLocation() { result = instance.getLocation() }

  override Crypto::RNGSourceSecurity getSourceSecurity() { result = instance.getSourceSecurity() }

  override Crypto::TRNGSeedSecurity getSeedSecurity(Location location) {
    result = instance.getSeedSecurity(location)
  }

  override Crypto::DataFlowNode asOutputData() { result.asExpr() = instance }

  override Crypto::DataFlowNode getInputData() { none() }
}

// Import library-specific modeling
import JCA
