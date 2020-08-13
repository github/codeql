/** Provides classes for working with architectures. */

import go

/**
 * An architecture that is valid in a build constraint.
 *
 * Information obtained from
 * https://github.com/golang/go/blob/98cbf45cfc6a5a50cc6ac2367f9572cb198b57c7/src/go/types/gccgosizes.go
 * where the first field of the struct is 4 for 32-bit architectures
 * and 8 for 64-bit architectures.
 */
class Architecture extends string {
  int bitSize;

  Architecture() {
    this in ["386", "amd64p32", "arm", "armbe", "mips", "mipsle", "mips64p32", "mips64p32le", "ppc",
          "s390", "sparc"] and
    bitSize = 32
    or
    this in ["amd64", "arm64", "arm64be", "ppc64", "ppc64le", "mips64", "mips64le", "s390x",
          "sparc64"] and
    bitSize = 64
  }

  int getBitSize() { result = bitSize }
}
