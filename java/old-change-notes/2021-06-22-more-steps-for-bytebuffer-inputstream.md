lgtm,codescanning
* Added more taint propagation models of some `java.io.InputStream` and `java.nio.ByteBuffer` methods. This may lead to extra results from queries concerning data-flow whenever a relevant path involves an instance of one of those types.
