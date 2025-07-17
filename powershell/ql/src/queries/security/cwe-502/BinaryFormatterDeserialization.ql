/**
 * @name Use of Binary Formatter deserialization
 * @description Use of Binary Formatter is unsafe
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/binary-formatter-deserialization
 * @tags correctness
 *       security
 *       external/cwe/cwe-502
 */

import powershell
import semmle.code.powershell.security.UnsafeDeserializationCustomizations::UnsafeDeserialization

from BinaryFormatterDeserializeSink sink
select sink, "Call to BinaryFormatter.Deserialize"
