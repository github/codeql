---
category: minorAnalysis
---
* Added flow summaries for the Protocol Buffers C++ API (`google::protobuf::MessageLite`, covering `Message` and all generated messages). The `ParseFrom*`/`MergeFrom*` methods (string, array, Cord, istream, and zero-copy/coded-stream forms) propagate taint from the encoded input to the message, and the `SerializeTo*`/`SerializeAs*`/`AppendTo*` methods propagate taint from the message to the output buffer, stream, or return value.
