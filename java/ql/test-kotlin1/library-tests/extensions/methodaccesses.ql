import java

// For extension methods we use JVM bytecode representation:
// * the qualifier is the dispatch receiver expression, and
// * the extension receiver expression is the 0th argument.
from MethodCall ma
select ma, ma.getQualifier(), ma.getAnArgument()
