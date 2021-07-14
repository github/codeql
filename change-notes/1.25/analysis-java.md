# Improvements to Java analysis

The following changes in version 1.25 affect Java analysis in all applications.

## General improvements

The Java autobuilder has been improved to detect more Gradle Java versions.

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Hard-coded credential in API call (`java/hardcoded-credential-api-call`) | More results | The query now recognizes the `BasicAWSCredentials` class of the Amazon client SDK library with hardcoded access key/secret key. |
| Deserialization of user-controlled data (`java/unsafe-deserialization`) | Fewer false positive results | The query no longer reports results using `org.apache.commons.io.serialization.ValidatingObjectInputStream`. |
| Use of a broken or risky cryptographic algorithm (`java/weak-cryptographic-algorithm`) | More results | The query now recognizes the `MessageDigest.getInstance` method. |
| Use of a potentially broken or risky cryptographic algorithm (`java/potentially-weak-cryptographic-algorithm`) | More results | The query now recognizes the `MessageDigest.getInstance` method. |
| Reading from a world writable file (`java/world-writable-file-read`) | More results | The query now recognizes more JDK file operations. |

## Changes to libraries

* The data-flow library has been improved with more taint flow modeling for the
  Collections framework and other classes of the JDK. This affects all security
  queries using data flow and can yield additional results.
* The data-flow library has been improved with more taint flow modeling for the
  Spring framework. This affects all security queries using data flow and can
  yield additional results on project that rely on the Spring framework.
* The data-flow library has been improved, which affects most security queries by potentially
  adding more results. Flow through methods now takes nested field reads/writes into account.
  For example, the library is able to track flow from `"taint"` to `sink()` via the method
  `getF2F1()` in
  ```java
  class C1 {
    String f1;
    C1(String f1) { this.f1 = f1; }
  }

  class C2 {
    C1 f2;
    String getF2F1() {
        return this.f2.f1; // Nested field read
    }
    void m() {
        this.f2 = new C1("taint");
        sink(this.getF2F1()); // NEW: "taint" reaches here
    }
  }
  ```
* The library has been extended with more support for Java 14 features
  (`switch` expressions and pattern-matching for `instanceof`).
