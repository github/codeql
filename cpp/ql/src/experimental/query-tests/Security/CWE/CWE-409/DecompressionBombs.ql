/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File
import Bzip2
import Brotli
import LibArchive
import LibMiniz
import ZSTD
import MiniZip
import XZ
import ZlibGzopen
import ZlibUncompress
import ZlibInflator
import Brotli

module DecompressionTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressStreamFunction |
      fc.getArgument(2) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressFunction |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzDecompressFunction |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzReadFunction |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzBuffToBuffDecompressFunction |
      fc.getArgument(2) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_data_block |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzUncompress |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzZipReaderExtract |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzInflate |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof TinflDecompress |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof TinflDecompressMem |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressFunction |
      fc.getArgument(2) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressDCtxFunction |
      fc.getArgument(3) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressStreamFunction |
      fc.getArgument(2) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressUsingDictFunction |
      fc.getArgument(3) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressUsingDDictFunction |
      fc.getArgument(3) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof UnzReadCurrentFileFunction |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof LzmaStreamBufferDecodeFunction |
      fc.getArgument(1) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof LzmaCodeFunction |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzReadFunction |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzFreadFunction |
      sink.asExpr() = fc.getArgument(3)
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzGetsFunction |
      sink.asExpr() = fc.getArgument(0)
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof InflateFunction |
      fc.getArgument(0) = sink.asExpr()
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof UncompressFunction |
      fc.getArgument(0) = sink.asExpr()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1)
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1)
    )
    or
    exists(FunctionCall fc |
      fc.getTarget() instanceof GzopenFunction or fc.getTarget() instanceof GzdopenFunction
    |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzReadFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1)
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzFreadFunction |
      node1.asExpr() = fc.getArgument(3) and
      node2.asExpr() = fc.getArgument(0)
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof GzGetsFunction |
      node1.asExpr() = fc.getArgument(0) and
      node1.asExpr() = fc.getArgument(1)
    )
  }
}

module DecompressionTaint = TaintTracking::Global<DecompressionTaintConfig>;

import DecompressionTaint::PathGraph

from DecompressionTaint::PathNode source, DecompressionTaint::PathNode sink
where DecompressionTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression output $@.", source.getNode(),
  "is not limited"
