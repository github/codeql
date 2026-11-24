---
category: minorAnalysis
---
* Updated the `java/weak-cryptographic-algorithm` query in line with NIST SP 800-131A Rev. 2 to report `SKIPJACK` (`Skipjack`) as insecure and to report Triple DES (`DESede`, `DESedeWrap`, `TripleDES`, `3DES`) with a dedicated Triple DES explanation rather than the single-DES message, including uppercase and lowercase variants.
* Updated the `java/potentially-weak-cryptographic-algorithm` query to recognize `ChaCha20`, `ChaCha20-Poly1305`, and `ChaCha20Poly1305` as secure algorithms, removing false positives.
