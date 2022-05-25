/** Provides classes for working with architectures. */

import go

/**
 * An architecture that is valid in a build constraint.
 *
 * Information obtained from
 * https://github.com/golang/go/blob/e125ccd10ea191101dbc31f0dd39a98f9d3ab929/src/go/types/gccgosizes.go
 * where the first field of the struct is 4 for 32-bit architectures
 * and 8 for 64-bit architectures.
 */
class Architecture extends string {
  int bitSize;

  Architecture() {
    this in [
        "386", "amd64p32", "arm", "armbe", "m64k", "mips", "mipsle", "mips64p32", "mips64p32le",
        "nios2", "ppc", "riscv", "s390", "sh", "shbe", "sparc"
      ] and
    bitSize = 32
    or
    this in [
        "alpha", "amd64", "arm64", "arm64be", "ia64", "mips64", "mips64le", "ppc64", "ppc64le",
        "riscv64", "s390x", "sparc64", "wasm"
      ] and
    bitSize = 64
  }

  /**
   * Gets the integer and pointer type width for this architecture.
   *
   * As of the time of writing, this appears to always be identical -- there aren't
   * Go architectures with 64-bit pointers but 32-bit ints, for example.
   */
  int getBitSize() { result = bitSize }
}
