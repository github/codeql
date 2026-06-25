---
category: minorAnalysis
---
* The `rust/hard-coded-cryptographic-value` query now treats arithmetic and bitwise operations, including string append operations, as barriers. This addresses false positive results where hard-coded constants are combined with non-constant data, such as incrementing a nonce or appending variable data to a constant prefix.
