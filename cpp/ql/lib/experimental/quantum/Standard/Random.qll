/**
 * Models random number generation from the C standard library, POSIX/BSD, the
 * Windows CryptoAPI/CNG, and the C++ `<random>` engines, as instances of the
 * shared quantum `Crypto::RandomNumberGenerationInstance` concept.
 *
 * The set of modelled generators is defined as data through the
 * `randomNumberGeneratorModel` extensible predicate, so that downstream packs can
 * register additional generators without editing this library. Each row records
 * whether the generator is cryptographically secure; insecure generators (e.g.
 * `rand`, `std::mt19937`) leave `isCryptographicallySecure()` at its default of
 * holding for no generator.
 *
 * Only functions that *produce* random output are modelled here. Seeding
 * functions such as `srand`, `srandom`, `srand48`, and `seed48` produce no output
 * artifact and are therefore out of scope for this concept.
 */

import cpp
private import experimental.quantum.Language

/**
 * Holds if a call to the function `name` is a random number generator.
 *
 * `namespace` and `type` identify the function: when `type` is empty, `name` is a
 * global or `std` free function (e.g. `rand`); otherwise `name` is a member
 * function of the class (template) whose unqualified name is `type` (e.g.
 * `operator()` of `std::mersenne_twister_engine`).
 *
 * `output` is the index of the argument into which the random bytes are written,
 * or the empty string if the random value is the return value.
 *
 * `secure` holds if the generator is cryptographically secure.
 */
extensible predicate randomNumberGeneratorModel(
  string namespace, string type, string name, string output, boolean secure
);

/**
 * Holds if `c` is a call to a modelled random number generator named
 * `generatorName`, writing its output as described by `output` (see
 * `randomNumberGeneratorModel`), where `secure` holds if it is cryptographically
 * secure.
 */
private predicate randomNumberGeneratorCall(
  Call c, string generatorName, string output, boolean secure
) {
  exists(string namespace, string type, string name, Function f |
    randomNumberGeneratorModel(namespace, type, name, output, secure) and
    f = c.getTarget()
  |
    // A global or `std` free function, e.g. `rand` or `std::rand`.
    type = "" and
    f.hasGlobalOrStdName(name) and
    generatorName = name
    or
    // A member function of a class (template), e.g. `std::mt19937::operator()`.
    type != "" and
    f.getName() = name and
    f.getDeclaringType().getSimpleName() = type and
    (if namespace = "" then generatorName = type else generatorName = namespace + "::" + type)
  )
}

/**
 * A call to a random number generator modelled through the `randomNumberGeneratorModel`
 * extensible predicate.
 */
class ModeledRandomNumberGeneratorInstance extends Crypto::RandomNumberGenerationInstance instanceof Call
{
  string generatorName;
  string output;
  boolean secure;

  ModeledRandomNumberGeneratorInstance() {
    randomNumberGeneratorCall(this, generatorName, output, secure)
  }

  override Crypto::DataFlowNode getOutputNode() {
    output = "" and result.asExpr() = this
    or
    output != "" and result.asDefiningArgument() = super.getArgument(output.toInt())
  }

  override string getGeneratorName() { result = generatorName }

  // If a call matches several `randomNumberGeneratorModel` rows with conflicting
  // `secure` values (e.g. a downstream pack reclassifies a generator), the secure
  // classification wins: this holds as soon as any matching row has `secure = true`.
  // Rows should therefore agree on the security of a given generator.
  override predicate isCryptographicallySecure() { secure = true }
}
