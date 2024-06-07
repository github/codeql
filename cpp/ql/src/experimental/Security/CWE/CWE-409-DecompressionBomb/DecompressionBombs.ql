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

module DecompressionTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    (
      exists(FunctionCall fc | fc.getTarget() instanceof AllocationFunction | fc = source.asExpr())
      or
      exists(FunctionCall fc | fopenCall(fc) | fc = source.asExpr())
      or
      source.asExpr() instanceof PointerVar
      or
      source.asExpr() instanceof Uint8Var
    ) and
    state = "brotli"
    or
    (
      source.asExpr() instanceof BzStreamVar
      or
      source.asExpr() instanceof BzFileVar
      or
      exists(FunctionCall fc | fopenCall(fc) | fc = source.asExpr())
    ) and
    state = "bzip2"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_new |
      fc.getArgument(0) = source.asExpr()
    ) and
    state = "libarchive"
    or
    (
      source.asExpr() instanceof UnsignedCharVar
      or
      source.asExpr() instanceof PointerVar
      or
      source.asExpr() instanceof CharVar
      or
      source.asExpr() instanceof MzZipArchiveVar
      or
      source.asExpr() instanceof MzStreampVar
      or
      source.asDefiningArgument() =
        any(Call call | call.getTarget() instanceof MzInflateInit).getArgument(0)
      or
      source.asDefiningArgument() =
        any(Call call | call.getTarget() instanceof MzZip).getArgument(0)
    ) and
    state = "libminiz"
    or
    (
      exists(FunctionCall fc | fc.getTarget() instanceof AllocationFunction | fc = source.asExpr())
      or
      exists(FunctionCall fc | fopenCall(fc) | fc = source.asExpr())
      or
      source.asExpr() instanceof ZSTDinBufferSVar
      or
      source.asExpr() instanceof ZSTDinBufferVar
    ) and
    state = "zstd"
    or
    (
      exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
        fc.getArgument(0) = source.asExpr()
      )
      or
      source.asExpr() instanceof UnzFileVar
    ) and
    state = "unzFile"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_create |
      fc = source.asExpr() and
      state = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_create |
      fc = source.asExpr() and
      state = "mz_zip"
    )
    or
    (
      source.asExpr() instanceof LzmaStreamVar
      or
      source.asExpr() instanceof Uint8Var
    ) and
    state = "xz"
    or
    (
      exists(FunctionCall fc | fc.getTarget() instanceof GzopenFunction |
        fc.getArgument(0) = source.asExpr() and
        // arg 0 can be a path string whichwe must do following check
        not fc.getArgument(0).isConstant()
      )
      or
      // IDK whether it is good to use all file decriptors function returns as source or not
      // because we can do more sanitization from fd function sources
      exists(FunctionCall fc | fc.getTarget() instanceof GzdopenFunction |
        fc.getArgument(0) = source.asExpr()
      )
      or
      source.asExpr() instanceof GzFileVar
    ) and
    state = "zlibgzopen"
    or
    source.asExpr() instanceof ZStreamVar and state = "zlifinflator"
    or
    source.asExpr() instanceof BytefVar and state = "zlibuncompress"
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    (
      exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressStreamFunction |
        fc.getArgument(2) = sink.asExpr()
      )
      or
      exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressFunction |
        fc.getArgument(1) = sink.asExpr()
      )
    ) and
    state = "brotli"
    or
    (
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
    ) and
    state = "bzip2"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_data_block |
      fc.getArgument(0) = sink.asExpr() and
      state = "libarchive"
    )
    or
    (
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
    ) and
    state = "libminiz"
    or
    (
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
    ) and
    state = "zstd"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof UnzReadCurrentFileFunction |
      fc.getArgument(0) = sink.asExpr() and
      state = "unzFile"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      fc.getArgument(1) = sink.asExpr() and
      state = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      fc.getArgument(1) = sink.asExpr() and
      state = "mz_zip"
    )
    or
    (
      exists(FunctionCall fc | fc.getTarget() instanceof LzmaStreamBufferDecodeFunction |
        fc.getArgument(1) = sink.asExpr()
      )
      or
      exists(FunctionCall fc | fc.getTarget() instanceof LzmaCodeFunction |
        fc.getArgument(0) = sink.asExpr()
      )
    ) and
    state = "xz" and
    exists(FunctionCall fc2 | fc2.getTarget() instanceof LzmaDecoderFunction)
    or
    (
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
    ) and
    state = "zlibgzopen"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof InflateFunction |
      fc.getArgument(0) = sink.asExpr()
    ) and
    state = "zlifinflator"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof UncompressFunction |
      fc.getArgument(0) = sink.asExpr()
    ) and
    state = "zlibuncompress"
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc and
      state1 = "" and
      state2 = "unzFile"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1) and
      state1 = "" and
      state2 = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1) and
      state1 = "" and
      state2 = "mz_zip"
    )
    or
    (
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
    ) and
    state1 = "" and
    state2 = "gzopen"
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module DecompressionTaint = TaintTracking::GlobalWithState<DecompressionTaintConfig>;

import DecompressionTaint::PathGraph

from DecompressionTaint::PathNode source, DecompressionTaint::PathNode sink
where DecompressionTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression output $@.", source.getNode(),
  "is not limited"
