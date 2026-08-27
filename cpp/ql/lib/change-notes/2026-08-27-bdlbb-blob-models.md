---
category: minorAnalysis
---
* Added flow summaries for the BDE `bdlbb::Blob` segmented byte buffer (`BloombergLP::bdlbb`). Taint now flows from a blob to its bytes through the `Blob::buffer`/`BlobBuffer::data` accessor chain and through the `bdlbb::BlobUtil::copy` and `getContiguousRangeOrCopy` helpers, so a blob populated from untrusted input (for example a BlazingMQ message body read via `bmqa::Message::getData`) is tracked into the payload bytes.
