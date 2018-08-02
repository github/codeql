import csharp
import semmle.code.csharp.security.dataflow.ReDoS

select any(StringLiteral e | ReDoS::isExponentialRegex(e))
