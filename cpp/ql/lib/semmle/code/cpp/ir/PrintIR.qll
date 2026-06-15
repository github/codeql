/**
 * Outputs a representation of the IR as a control flow graph.
 *
 * This file contains the actual implementation of `PrintIR.ql`. For test cases and very small
 * databases, `PrintIR.ql` can be run directly to dump the IR for the entire database. For most
 * uses, however, it is better to write a query that imports `PrintIR.qll`, extends
 * `PrintIRConfiguration`, and overrides `shouldPrintDeclaration()` to select a subset of declarations
 * to dump.
 */

import implementation.aliased_ssa.PrintIR
