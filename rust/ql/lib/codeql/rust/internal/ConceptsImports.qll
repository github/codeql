/**
 * This file contains imports required for the Rust version of `ConceptsShared.qll`.
 * Since they are language-specific, they can't be placed directly in that file, as it is shared between languages.
 */

import codeql.rust.dataflow.DataFlow::DataFlow as DataFlow
import codeql.rust.security.CryptoAlgorithms as CryptoAlgorithms
