/** Provides a query for testing the modable directory creation library. */

import ModableDirectoryCreation

/** Holds if `node` is a modable directory creation. */
query predicate modableDirectoryCreation(DataFlow::Node node) {
  node instanceof ModableDirectoryCreation
}
