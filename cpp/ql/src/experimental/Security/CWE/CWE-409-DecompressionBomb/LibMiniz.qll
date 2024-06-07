/**
 * https://github.com/richgel999/miniz
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A unsigned char Variable is used in Flow source
 */
class UnsignedCharVar extends VariableAccess {
  UnsignedCharVar() { this.getType().stripType().resolveTypedefs*() instanceof UnsignedCharType }
}

/**
 * The `mz_streamp`, `z_stream` Variables are used in Flow source
 */
class MzStreampVar extends VariableAccess {
  MzStreampVar() { this.getType().hasName(["mz_streamp", "z_stream"]) }
}

/**
 * A Char Variable is used in Flow source
 */
class CharVar extends VariableAccess {
  CharVar() { this.getType().stripType().resolveTypedefs*() instanceof CharType }
}

/**
 * A `mz_zip_archive` Variable is used in Flow source
 */
class MzZipArchiveVar extends VariableAccess {
  MzZipArchiveVar() { this.getType().hasName("mz_zip_archive") }
}

/**
 * The `mz_uncompress` functions are used in Flow Sink
 */
class MzUncompress extends Function {
  MzUncompress() { this.hasGlobalName(["uncompress", "mz_uncompress", "mz_uncompress2"]) }
}

/**
 * A `zip handle` is used in Flow source
 */
class MzZip extends Function {
  MzZip() {
    this.hasGlobalName([
        "mz_zip_reader_open", "mz_zip_reader_open_file", "mz_zip_reader_open_file_in_memory",
        "mz_zip_reader_open_buffer", "mz_zip_reader_entry_open"
      ])
  }
}

/**
 * The `mz_inflate` functions are used in Flow Sink
 */
class MzInflate extends Function {
  MzInflate() { this.hasGlobalName(["mz_inflate", "inflate"]) }
}

/**
 * The `mz_inflateInit` functions are used in Flow Sink
 */
class MzInflateInit extends Function {
  MzInflateInit() { this.hasGlobalName(["inflateInit", "mz_inflateInit"]) }
}

/**
 * The `mz_zip_reader_extract_*` functions are used in Flow Sink
 */
class MzZipReaderExtract extends Function {
  MzZipReaderExtract() {
    this.hasGlobalName([
        "mz_zip_reader_extract_file_to_heap", "mz_zip_reader_extract_to_heap",
        "mz_zip_reader_extract_to_callback", "mz_zip_reader_extract_file_to_callback",
        "mz_zip_reader_extract_to_mem", "mz_zip_reader_extract_file_to_mem",
        "mz_zip_reader_extract_iter_read", "mz_zip_reader_extract_to_file",
        "mz_zip_reader_extract_file_to_file"
      ])
  }
}

/**
 * The `tinfl_decompress_mem_*` functions are used in Flow Sink
 */
class TinflDecompressMem extends Function {
  TinflDecompressMem() {
    this.hasGlobalName([
        "tinfl_decompress_mem_to_callback", "tinfl_decompress_mem_to_mem",
        "tinfl_decompress_mem_to_heap"
      ])
  }
}

/**
 * The `tinfl_decompress_*` functions are used in Flow Sink
 */
class TinflDecompress extends Function {
  TinflDecompress() { this.hasGlobalName(["tinfl_decompress"]) }
}
