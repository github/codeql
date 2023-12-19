/**
 * This file imports the module that is used to construct the strings used by `Node.ToString`.
 *
 * Normally, this file should just import `NormalNode0ToString` to compute the efficient `toString`, but for debugging purposes
 * one can import `DebugPrinting.qll` to better correlate the dataflow nodes with their underlying instructions and operands.
 */

import Node0ToStringSig
import NormalNode0ToString
