/**
 * https://github.com/richgel999/miniz
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `mz_uncompress` functions are used in flow sink.
 */
class MzUncompress extends DecompressionFunction {
  MzUncompress() { this.hasGlobalName(["uncompress", "mz_uncompress", "mz_uncompress2"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * A `zip handle` is used in Flow source
 */
class MzZip extends DecompressionFunction {
  MzZip() {
    this.hasGlobalName([
        "mz_zip_reader_open", "mz_zip_reader_open_file", "mz_zip_reader_open_file_in_memory",
        "mz_zip_reader_open_buffer", "mz_zip_reader_entry_open"
      ])
  }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `mz_inflate` functions are used in flow sink.
 */
class MzInflate extends DecompressionFunction {
  MzInflate() { this.hasGlobalName(["mz_inflate", "inflate"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `mz_zip_reader_extract_*` functions are used in flow sink.
 */
class MzZipReaderExtract extends DecompressionFunction {
  MzZipReaderExtract() {
    this.hasGlobalName([
        "mz_zip_reader_extract_file_to_heap", "mz_zip_reader_extract_to_heap",
        "mz_zip_reader_extract_to_callback", "mz_zip_reader_extract_file_to_callback",
        "mz_zip_reader_extract_to_mem", "mz_zip_reader_extract_file_to_mem",
        "mz_zip_reader_extract_iter_read", "mz_zip_reader_extract_to_file",
        "mz_zip_reader_extract_file_to_file"
      ])
  }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `tinfl_decompress_mem_*` functions are used in flow sink.
 */
class TinflDecompressMem extends DecompressionFunction {
  TinflDecompressMem() {
    this.hasGlobalName([
        "tinfl_decompress_mem_to_callback", "tinfl_decompress_mem_to_mem",
        "tinfl_decompress_mem_to_heap"
      ])
  }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `tinfl_decompress_*` functions are used in flow sink.
 */
class TinflDecompress extends DecompressionFunction {
  TinflDecompress() { this.hasGlobalName(["tinfl_decompress"]) }

  override int getArchiveParameterIndex() { result = 1 }
}
