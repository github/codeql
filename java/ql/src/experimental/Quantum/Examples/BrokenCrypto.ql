/**
* @name Use of a broken or risky cryptographic algorithm
* @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
* @kind problem
* @problem.severity warning
* @security-severity 7.5
* @precision high
* @id java/weak-cryptographic-algorithm-new-model
* @tags security
*       external/cwe/cwe-327
*       external/cwe/cwe-328
*/



//THIS QUERY IS A REPLICA OF: https://github.com/github/codeql/blob/main/java/ql/src/Security/CWE/CWE-327/BrokenCryptoAlgorithm.ql
//but uses the **NEW MODELLING**
import experimental.Quantum.Language


/**
 * Gets the name of an algorithm that is known to be insecure.
 */
string getAnInsecureAlgorithmName() {
    result =
      [
        "DES", "RC2", "RC4", "RC5",
        // ARCFOUR is a variant of RC4
        "ARCFOUR",
        // Encryption mode ECB like AES/ECB/NoPadding is vulnerable to replay and other attacks
        "ECB",
        // CBC mode of operation with PKCS#5 or PKCS#7 padding is vulnerable to padding oracle attacks
        "AES/CBC/PKCS[57]Padding"
      ]
  }
  
  private string rankedInsecureAlgorithm(int i) {
    result = rank[i](string s | s = getAnInsecureAlgorithmName())
  }
  
  private string insecureAlgorithmString(int i) {
    i = 1 and result = rankedInsecureAlgorithm(i)
    or
    result = rankedInsecureAlgorithm(i) + "|" + insecureAlgorithmString(i - 1)
  }
  
  /**
   * Gets the regular expression used for matching strings that look like they
   * contain an algorithm that is known to be insecure.
   */
  string getInsecureAlgorithmRegex() {
    result = algorithmRegex(insecureAlgorithmString(max(int i | exists(rankedInsecureAlgorithm(i)))))
  }

  bindingset[algorithmString]
private string algorithmRegex(string algorithmString) {
  // Algorithms usually appear in names surrounded by characters that are not
  // alphabetical characters in the same case. This handles the upper and lower
  // case cases.
  result =
    "((^|.*[^A-Z])(" + algorithmString + ")([^A-Z].*|$))" +
      // or...
      "|" +
      // For lowercase, we want to be careful to avoid being confused by camelCase
      // hence we require two preceding uppercase letters to be sure of a case switch,
      // or a preceding non-alphabetic character
      "((^|.*[A-Z]{2}|.*[^a-zA-Z])(" + algorithmString.toLowerCase() + ")([^a-z].*|$))"
}

from Crypto::Algorithm alg 
where alg.getAlgorithmName().regexpMatch(getInsecureAlgorithmRegex()) and
// Exclude RSA/ECB/.* ciphers.
not alg.getAlgorithmName().regexpMatch("RSA/ECB.*") and
// Exclude German and French sentences.
not alg.getAlgorithmName().regexpMatch(".*\\p{IsLowercase} des \\p{IsLetter}.*")
select alg, "Cryptographic algorithm $@ is weak and should not be used.", alg,
alg.getAlgorithmName()
