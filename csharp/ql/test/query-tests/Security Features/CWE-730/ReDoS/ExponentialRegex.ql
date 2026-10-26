import csharp
import semmle.code.csharp.security.dataflow.ReDoSQuery

select any(StringLiteral e | isExponentialRegex(e))
