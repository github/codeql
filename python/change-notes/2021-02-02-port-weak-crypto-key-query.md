lgtm,codescanning
* Updated _Use of weak cryptographic key_ (`py/weak-crypto-key`) query to use the new type-tracking approach instead of points-to analysis. You may see differences in the results found by the query, but overall this change should result in a more robust and accurate analysis.
* Renamed the query file for _Use of weak cryptographic key_ (`py/weak-crypto-key`) from `WeakCrypto.ql` to `WeakCryptoKey.ql` (in the `python/ql/src/Security/CWE-326/` folder). This will affect any custom query suites that include or exclude this query using its path.
