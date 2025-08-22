/**
 * @name Incorrect return-value check for a 'scanf'-like function
 * @description Failing to account for EOF in a call to a scanf-like function can lead to
 *             undefined behavior.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/incorrectly-checked-scanf
 * @tags security
 *       correctness
 *       external/cwe/cwe-253
 */

import cpp
import semmle.code.cpp.commons.Scanf
import ScanfChecks

from ScanfFunctionCall call
where incorrectlyCheckedScanf(call)
select call, "The result of scanf is only checked against 0, but it can also return EOF."
