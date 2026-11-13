---
category: newQuery
---
* Added a new query, `cpp/insecure-randomness` ("Insecure randomness"), which flags cryptographically insecure random numbers (for example from `rand` or `std::mt19937`) that are used as security-sensitive values such as encryption keys, IVs, or nonces.
