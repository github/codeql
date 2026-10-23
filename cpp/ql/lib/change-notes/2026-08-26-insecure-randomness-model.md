---
category: minorAnalysis
---
* Added models of random number generation from the C standard library, POSIX/BSD, the Windows CryptoAPI/CNG, and the C++ `<random>` engines as instances of the `Crypto::RandomNumberGenerationInstance` concept, each classified as cryptographically secure or insecure. The set of generators is defined as data through the new `randomNumberGeneratorModel` extensible predicate, so it can be extended by data-extension packs. The OpenSSL `RAND_pseudo_bytes` function is now classified as insecure, while `RAND_bytes` and `RAND_priv_bytes` are classified as secure.
