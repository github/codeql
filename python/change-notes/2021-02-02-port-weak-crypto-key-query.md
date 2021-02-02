lgtm,codescanning
* Ported _Use of weak cryptographic key_ (`py/weak-crypto-key`) query to use new type-tracking approach instead of points-to. This might result in some difference in results being found, but overall this should result in a more robust and accurate analysis.
