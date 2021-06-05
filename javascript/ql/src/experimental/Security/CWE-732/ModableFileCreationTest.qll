/** Provides a query for testing the modable file creation library. */

import ModableFileCreation

/** Holds if `node` is a modable file creation. */
query predicate modableFileCreation(DataFlow::Node node) { node instanceof ModableFileCreation }
