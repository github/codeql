---
category: minorAnalysis
---
* Added taint flow summaries for the BDE `bslx` byte-stream deserializers `BloombergLP::bslx::ByteInStream`, `BloombergLP::bslx::GenericInStream`, and `BloombergLP::bslx::InStreamFunctions::bdexStreamIn`, so that data read from a `bslx` in-stream is tracked as tainted.
