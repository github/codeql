---
category: breaking
---
* The `CryptographicOperation` concept has been changed to use a range pattern. This is a breaking change and existing implementations of `CryptographicOperation` will need to be updated in order to compile. These implementations can be updated by:
  1. Extending `CryptographicOperation::Range` rather than `CryptographicOperation`
  2. Renaming the `getInput()` member predicate as `getAnInput()`
  3. Implementing the `BlockMode getBlockMode()` member predicate. The implementation for this can be `none()` if the operation is a hashing operation or an encryption operation using a stream cipher.
