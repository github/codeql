/**
 * @name Encoding error
 * @description Encoding errors cause failures at runtime and prevent analysis of the code.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/encoding-error
 */

import python

from EncodingError error
select error, error.getMessage()
