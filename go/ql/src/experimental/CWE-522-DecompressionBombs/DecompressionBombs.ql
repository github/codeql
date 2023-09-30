/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import go
import semmle.go.dataflow.Properties
import MultipartAndFormRemoteSource

module DecompressionBombsConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof UntrustedFlowSource and
    state = ""
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    (
      exists(Function f | f.hasQualifiedName("io", ["Copy", "CopyBuffer", "CopyN"]) |
        sink = f.getACall().getArgument(1)
      )
      or
      exists(Function f | f.hasQualifiedName("io", ["Pipe", "ReadAll", "ReadAtLeast", "ReadFull"]) |
        sink = f.getACall().getArgument(0)
      )
      or
      exists(Function f |
        f.hasQualifiedName("bufio.Reader",
          ["Read", "ReadBytes", "ReadByte", "ReadLine", "ReadRune", "ReadSlice", "ReadString"])
      |
        sink = f.getACall().getReceiver()
      )
      or
      exists(Function f | f.hasQualifiedName("bufio.Scanner", ["Text", "Bytes"]) |
        sink = f.getACall().getReceiver()
      )
      or
      exists(Function f | f.hasQualifiedName("io/ioutil", "ReadAll") |
        sink = f.getACall().getArgument(0)
      )
      or
      exists(Function f |
        f.hasQualifiedName([
            "github.com/klauspost/compress/flate.decompressor",
            "github.com/dsnet/compress/bzip2.Reader", "compress/flate.decompressor",
            "github.com/dsnet/compress/flate.Reader", "github.com/klauspost/compress/zlib.reader",
            "compress/zlib.reader", "github.com/golang/snappy.Reader",
            "github.com/klauspost/compress/s2.Reader", "github.com/klauspost/compress/gzip.Reader",
            "github.com/klauspost/pgzip.Reader", "github.com/klauspost/compress/zstd.Decoder",
            "github.com/DataDog/zstd.reader", "compress/gzip.Reader",
            "github.com/ulikunitz/xz.Reader", "archive/tar.Reader", "compress/bzip2.reader"
          ], "Read")
      |
        sink = f.getACall().getReceiver()
      )
      or
      exists(Function f |
        f.hasQualifiedName("github.com/klauspost/compress/s2.Reader",
          ["DecodeConcurrent", "ReadByte"])
        or
        f.hasQualifiedName("github.com/golang/snappy.Reader", "ReadByte")
        or
        f.hasQualifiedName("github.com/klauspost/compress/gzip.Reader", "WriteTo")
        or
        f.hasQualifiedName("github.com/klauspost/pgzip.Reader", "WriteTo")
        or
        f.hasQualifiedName("github.com/klauspost/compress/zstd.Decoder", ["WriteTo", "DecodeAll"])
      |
        sink = f.getACall().getReceiver()
      )
    ) and
    state =
      [
        "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
        "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "ZipKlauspost"
      ]
  }

  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
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

  predicate isAdditionalFlowStep(
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
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/klauspost/compress/zip", ["NewReader", "OpenReader"]) and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZipKlauspost"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/ulikunitz/xz", "NewReader") and call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "XzNewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName([
          "compress/gzip", "github.com/klauspost/compress/gzip", "github.com/klauspost/pgzip"
        ], "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "GzipNewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName([
          "compress/bzip2", "github.com/dsnet/compress/bzip2", "github.com/cosnicolaou/pbzip2"
        ], "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "Bzip2NewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      (
        f.hasQualifiedName("github.com/dsnet/compress/flate", "NewReader") or
        f.hasQualifiedName(["compress/flate", "github.com/klauspost/compress/flate"],
          ["NewReaderDict", "NewReader"])
      ) and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "FlateNewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName(["compress/zlib", "github.com/klauspost/compress/zlib"], "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZlibNewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName(["github.com/klauspost/compress/zstd", "github.com/DataDog/zstd"],
        "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZstdNewReader"
    )
    or
    exists(Function f, DataFlow::CallNode call |
      f.hasQualifiedName(["github.com/golang/snappy", "github.com/klauspost/compress/snappy"],
        "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "SnapyNewReader"
    )
    or
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

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // //here I want to the CopyN return value be compared with < or > but I can't reach the tainted result
    // // exists(Function f | f.hasQualifiedName("io", "CopyN") |
    // //   node = f.getACall().getArgument([0, 1]) and
    // //   TaintTracking::localExprTaint(f.getACall().getResult(_).asExpr(),
    // //     any(RelationalComparisonExpr e).getAChildExpr*())
    // // )
    // // or
    // exists(Function f | f.hasQualifiedName("io", "LimitReader") |
    //   node = f.getACall().getArgument(0) and f.getACall().getArgument(1).isConst()
    // ) and
    // state =
    //   [
    //     "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
    //     "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "ZipKlauspost"
    //   ]
    none()
  }
}

// // here I want to the CopyN return value be compared with < or > but I can't reach the tainted result
// predicate test(DataFlow::Node n2) { any(Test testconfig).hasFlowTo(n2) }
// class Test extends DataFlow::Configuration {
//   Test() { this = "test" }
//   override predicate isSource(DataFlow::Node source) {
//     exists(Function f | f.hasQualifiedName("io", "CopyN") |
//       f.getACall().getResult(0) = source
//     )
//   }
//   override predicate isSink(DataFlow::Node sink) { sink instanceof DataFlow::Node }
// }
module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This decompression is $@.", source.getNode(),
  "decompressing compressed data without managing output size"
