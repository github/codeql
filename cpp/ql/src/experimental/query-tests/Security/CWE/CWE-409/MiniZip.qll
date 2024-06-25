/**
 * https://github.com/zlib-ng/minizip-ng
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * The `mz_zip_reader_create` function as a Flow source
 * create a `mz_zip_reader` instance
 */
class Mz_zip_reader_create extends Function {
  Mz_zip_reader_create() { this.hasGlobalName("mz_zip_reader_create") }
}

/**
 * The `mz_zip_create` function as a Flow source
 * create a `mz_zip` instance
 */
class Mz_zip_create extends Function {
  Mz_zip_create() { this.hasGlobalName("mz_zip_create") }
}

/**
 * The `mz_zip_entry` function is used in Flow source
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip.md)
 */
class Mz_zip_entry extends Function {
  Mz_zip_entry() { this.hasGlobalName("mz_zip_entry_read") }
}

/**
 * The `mz_zip_reader_entry_*` and `mz_zip_reader_save_all` functions are used in Flow source
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip_rw.md)
 */
class Mz_zip_reader_entry extends Function {
  Mz_zip_reader_entry() {
    this.hasGlobalName([
        "mz_zip_reader_entry_save", "mz_zip_reader_entry_read", "mz_zip_reader_entry_save_process",
        "mz_zip_reader_entry_save_file", "mz_zip_reader_entry_save_buffer", "mz_zip_reader_save_all"
      ])
  }
}

/**
 * A `unzFile` Variable as a Flow source
 */
class UnzFileVar extends VariableAccess {
  UnzFileVar() { this.getType().hasName("unzFile") }
}

/**
 * The `UnzOpen` function as a Flow source
 */
class UnzOpenFunction extends Function {
  UnzOpenFunction() { this.hasGlobalName(["UnzOpen", "unzOpen64", "unzOpen2", "unzOpen2_64"]) }
}

/**
 * The `unzReadCurrentFile` function is used in Flow sink
 */
class UnzReadCurrentFileFunction extends Function {
  UnzReadCurrentFileFunction() { this.hasGlobalName(["unzReadCurrentFile"]) }
}
