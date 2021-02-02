lgtm,codescanning
* Ported _Use of weak cryptographic key_ (`py/weak-crypto-key`) query to use new type-tracking approach instead of points-to. This might result in some difference in results being found, but overall this should result in a more robust and accurate analysis.
* Renamed the query file for _Use of weak cryptographic key_ (`py/weak-crypto-key`) from `WeakCrypto.ql` to `WeakCryptoKey.ql` (in the `python/ql/src/Security/CWE-326/` folder), which could impact custom query suites that include/exclude this query by using it's path.
