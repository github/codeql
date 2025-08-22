/**
 * Provides models of commonly used functions in the official Couchbase Go SDK library.
 */

import go

/**
 * DEPRECATED
 *
 * Provides models of commonly used functions in the official Couchbase Go SDK library.
 */
deprecated module Couchbase {
  /**
   * DEPRECATED
   *
   * Gets a package path for the official Couchbase Go SDK library.
   *
   * Note that v1 and v2 have different APIs, but the names are disjoint so there is no need to
   * distinguish between them.
   */
  deprecated string packagePath() {
    result =
      package([
          "gopkg.in/couchbase/gocb", "github.com/couchbase/gocb", "github.com/couchbaselabs/gocb"
        ], "")
  }
}
