/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id go/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import go
import DataFlow::PathGraph
import semmle.go.dataflow.Properties
import semmle.go.security.FlowSources
import CmdLineFlowSource

class DecompressionBombs extends TaintTracking::Configuration {
  DecompressionBombs() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    (
      source instanceof UntrustedFlowSource
      or
      source instanceof CmdLineFlowSource
    ) and
    state =
      [
        "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
        "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "IOMethods",
        "ZipKlauspost"
      ]
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    (
      exists(DataFlow::Function f | f.hasQualifiedName(["io", "bufio", "io/ioutil"], _) |
        sink = f.getACall().getArgument(_)
      )
      or
      exists(DataFlow::Function f |
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
      exists(DataFlow::Function f |
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
        "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "IOMethods",
        "ZipKlauspost"
      ]
  }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(DataFlow::FieldReadNode fi |
      fi.getType().hasQualifiedName("github.com/klauspost/compress/zip", "Reader")
    |
      fromNode = fi.getBase() and
      toNode = fi
    )
    or
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/klauspost/compress/zip.File", ["Open", "OpenRaw"]) and
      call = f.getACall()
    |
      fromNode = call.getReceiver() and
      toNode = call
    )
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    //here I want to the CopyN return value be compared with < or > but I can't reach the tainted result
    // exists(DataFlow::Function f | f.hasQualifiedName("io", "CopyN") |
    //   node = f.getACall().getArgument([0, 1]) and
    //   TaintTracking::localExprTaint(f.getACall().getResult(_).asExpr(),
    //     any(RelationalComparisonExpr e).getAChildExpr*())
    // )
    // or
    exists(DataFlow::Function f | f.hasQualifiedName("io", "LimitReader") |
      node = f.getACall().getArgument(0) and f.getACall().getArgument(1).isConst()
    ) and
    state =
      [
        "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
        "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "IOMethods",
        "ZipKlauspost"
      ]
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node fromNode, DataFlow::FlowState fromState, DataFlow::Node toNode,
    DataFlow::FlowState toState
  ) {
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName("archive/zip", ["OpenReader", "NewReader"]) and call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZipOpenReader"
    )
    or
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/klauspost/compress/zip", ["NewReader", "OpenReader"]) and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZipKlauspost"
    )
    or
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/ulikunitz/xz", "NewReader") and call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "XzNewReader"
    )
    or
    exists(DataFlow::Function f, DataFlow::CallNode call |
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
    exists(DataFlow::Function f, DataFlow::CallNode call |
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
    exists(DataFlow::Function f, DataFlow::CallNode call |
      (
        f.hasQualifiedName(["github.com/dsnet/compress/flate"], "NewReader") or
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
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName(["compress/zlib", "github.com/klauspost/compress/zlib"], "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "ZlibNewReader"
    )
    or
    exists(DataFlow::Function f, DataFlow::CallNode call |
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
    exists(DataFlow::Function f, DataFlow::CallNode call |
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
    exists(DataFlow::Function f, DataFlow::CallNode call |
      f.hasQualifiedName("github.com/klauspost/compress/s2", "NewReader") and
      call = f.getACall()
    |
      fromNode = call.getArgument(0) and
      toNode = call.getResult(0) and
      fromState = "" and
      toState = "S2NewReader"
    )
  }
}

// here I want to the CopyN return value be compared with < or > but I can't reach the tainted result
predicate test(DataFlow::Node n2) { any(Test testconfig).hasFlowTo(n2) }

class Test extends DataFlow::Configuration {
  Test() { this = "test" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::Function f | f.hasQualifiedName("io", "CopyN") |
      f.getACall().getResult(0) = source
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DataFlow::Node }
}

from
  DecompressionBombs cfg, DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Node request
where
  cfg.hasFlowPath(source, sink) and
  request = sink.getNode()
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
