import go

module DecompressionBombs {
  class FlowState extends string {
    FlowState() {
      this =
        [
          "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
          "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "ZipKlauspost", ""
        ]
    }
  }

  /**
   * The additional taint steps that need for creating taint tracking or dataflow.
   */
  abstract class AdditionalTaintStep extends string {
    AdditionalTaintStep() { this = "AdditionalTaintStep" }

    /**
     * Holds if there is a additional taint step between pred and succ.
     */
    abstract predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode);

    /**
     * Holds if there is a additional taint step between pred and succ.
     */
    abstract predicate isAdditionalFlowStep(
      DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
    );
  }

  /**
   * The Sinks of uncontrolled data decompression
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * Provides Decompression Sinks and additional flow steps for `github.com/DataDog/zstd` package
   */
  module DataDogZstd {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("github.com/DataDog/zstd", "reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/DataDog/zstd", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZstdNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional flow steps for `github.com/klauspost/compress/zstd` package
   */
  module KlauspostZstd {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f |
          f.hasQualifiedName("github.com/klauspost/compress/zstd", "Decoder",
            ["WriteTo", "DecodeAll"])
        |
          this = f.getACall().getReceiver()
        )
        or
        exists(Method f |
          f.hasQualifiedName("github.com/klauspost/compress/zstd", "Decoder", "Read")
        |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/zstd", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZstdNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides additional flow steps for `archive/zip` package
   */
  module ArchiveZip {
    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("archive/zip", ["OpenReader", "NewReader"]) and call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZipOpenReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression additional taint steps for `github.com/klauspost/compress/zip` package
   */
  module KlauspostZip {
    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/zip", ["NewReader", "OpenReader"]) and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZipKlauspost"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        exists(DataFlow::FieldReadNode fi |
          fi.getType().hasQualifiedName("github.com/klauspost/compress/zip", "Reader")
        |
          fromNode = fi.getBase() and
          toNode = fi
        )
        or
        exists(Method f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/zip", "File", ["Open", "OpenRaw"]) and
          call = f.getACall()
        |
          fromNode = call.getReceiver() and
          toNode = call
        )
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/ulikunitz/xz` package
   */
  module UlikunitzXz {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("github.com/ulikunitz/xz", "Reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/ulikunitz/xz", "NewReader") and call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "XzNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `compress/gzip` package
   */
  module CompressGzip {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("compress/gzip", "Reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("compress/gzip", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "GzipNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/klauspost/compress/gzip` package
   */
  module KlauspostGzip {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f |
          f.hasQualifiedName("github.com/klauspost/compress/gzip", "Reader", "Read")
        |
          this = f.getACall().getReceiver()
        )
        or
        exists(Method f |
          f.hasQualifiedName(["github.com/klauspost/compress/gzip", "github.com/klauspost/pgzip"],
            "Reader", "WriteTo")
        |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName(["github.com/klauspost/compress/gzip", "github.com/klauspost/pgzip"],
            "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "GzipNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `compress/bzip2` package
   */
  module CompressBzip2 {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("compress/bzip2", "reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("compress/bzip2", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "Bzip2NewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/dsnet/compress/bzip2` package
   */
  module DsnetBzip2 {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("github.com/dsnet/compress/bzip2", "Reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/dsnet/compress/bzip2", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "Bzip2NewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/dsnet/compress/flate` package
   */
  module DsnetFlate {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("github.com/dsnet/compress/flate", "Reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/dsnet/compress/flate", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "FlateNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `compress/flate` package
   */
  module CompressFlate {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("compress/flate", "decompressor", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("compress/flate", ["NewReaderDict", "NewReader"]) and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "FlateNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/klauspost/compress/flate` package
   */
  module KlauspostFlate {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f |
          f.hasQualifiedName("github.com/klauspost/compress/flate", "decompressor", "Read")
        |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/flate", ["NewReaderDict", "NewReader"]) and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "FlateNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/klauspost/compress/zlib` package
   */
  module KlauspostZlib {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f |
          f.hasQualifiedName("github.com/klauspost/compress/zlib", "reader", "Read")
        |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/zlib", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZlibNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `compress/zlib` package
   */
  module CompressZlib {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f | f.hasQualifiedName("compress/zlib", "reader", "Read") |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("compress/zlib", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "ZlibNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/golang/snappy` package
   */
  module GolangSnappy {
    class TheSink extends Sink {
      TheSink() {
        exists(Method f |
          f.hasQualifiedName("github.com/golang/snappy", "Reader", ["Read", "ReadByte"])
        |
          this = f.getACall().getReceiver()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/golang/snappy", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "SnapyNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression additional taint steps for `github.com/klauspost/compress/snappy` package
   */
  module KlauspostSnappy {
    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/snappy", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "SnapyNewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }

    class TheSink extends Sink {
      TheSink() {
        exists(Method m |
          m.hasQualifiedName("github.com/klauspost/compress/s2", "Reader",
            ["DecodeConcurrent", "ReadByte", "Read"])
        |
          this = m.getACall().getReceiver()
        )
      }
    }
  }

  /**
   * Provides Decompression Sinks and additional taint steps for `github.com/klauspost/compress/s2` package
   */
  module KlauspostS2 {
    class TheSink extends DataFlow::Node {
      TheSink() {
        exists(Method m |
          m.getType()
              .getUnderlyingType()
              .hasQualifiedName("github.com/klauspost/compress/s2", "Reader")
        |
          this = m.getACall()
        )
      }
    }

    class TheAdditionalTaintStep extends AdditionalTaintStep {
      TheAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalFlowStep(
        DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
      ) {
        exists(Function f, DataFlow::CallNode call |
          f.hasQualifiedName("github.com/klauspost/compress/s2", "NewReader") and
          call = f.getACall()
        |
          fromNode = call.getArgument(0) and
          toNode = call.getResult(0) and
          fromState = "" and
          toState = "S2NewReader"
        )
      }

      override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
        none()
      }
    }
  }

  /**
   * Provides Decompression Sinks for packages that use some standard IO interfaces/methods for reading decompressed data
   */
  module GeneralReadIoSink {
    class TheSink extends Sink {
      TheSink() {
        exists(Function f | f.hasQualifiedName("io", ["Copy", "CopyBuffer", "CopyN"]) |
          this = f.getACall().getArgument(1)
        )
        or
        exists(Function f |
          f.hasQualifiedName("io", ["Pipe", "ReadAll", "ReadAtLeast", "ReadFull"])
        |
          this = f.getACall().getArgument(0)
        )
        or
        exists(Method f |
          f.hasQualifiedName("bufio", "Reader",
            ["Read", "ReadBytes", "ReadByte", "ReadLine", "ReadRune", "ReadSlice", "ReadString"])
        |
          this = f.getACall().getReceiver()
        )
        or
        exists(Method f | f.hasQualifiedName("bufio", "Scanner", ["Text", "Bytes"]) |
          this = f.getACall().getReceiver()
        )
        or
        exists(Function f | f.hasQualifiedName("io/ioutil", "ReadAll") |
          this = f.getACall().getArgument(0)
        )
      }
    }
  }
}
