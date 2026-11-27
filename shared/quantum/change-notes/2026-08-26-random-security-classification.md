---
category: minorAnalysis
---
* Added a `isCryptographicallySecure()` predicate to `Crypto::RandomNumberGenerationInstance`, allowing models of random number generators to record whether the generator is cryptographically secure. It defaults to holding for no generator, so existing subclasses are unaffected until they classify themselves.
