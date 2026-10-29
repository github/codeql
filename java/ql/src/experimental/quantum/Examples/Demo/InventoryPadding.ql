/**
 * @name Inventory of padding schemes
 * @description Lists all detected padding scheme algorithms.
 * @id java/quantum/examples/demo/inventory-padding
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::PaddingAlgorithmNode pad
select pad, "Padding scheme: " + pad.getPaddingType().toString() + "."
