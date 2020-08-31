using System;

namespace Semmle.Extraction.CSharp
{
    public class UnrecognizedCompilerException : Exception
    {
        public UnrecognizedCompilerException(string specifiedCompiler, string message)
            : base($"Unrecognized compiler '{specifiedCompiler}' because {message}")
        {
        }
    }
}
