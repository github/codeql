using Semmle.Extraction.CSharp.DependencyFetching;
using Semmle.Extraction.CSharp.StubGenerator;
using Semmle.Util.Logging;

var logger = new ConsoleLogger(Verbosity.Info, logThreadId: false);
using var dependencyManager = new DependencyManager(".", logger);
StubGenerator.GenerateStubs(logger, dependencyManager.ReferenceFiles, "codeql_csharp_stubs");

return 0;
