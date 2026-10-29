/**
 * @name Inventory of block cipher modes
 * @description Lists all detected modes of operation for block ciphers.
 * @id java/quantum/examples/demo/inventory-modes
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::ModeOfOperationAlgorithmNode m
select m, "Mode of operation: " + m.getModeType().toString() + "."
