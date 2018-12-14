using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;
using System;

namespace Semmle.Extraction
{
    /// <summary>
    /// Encapsulates information for a log message.
    /// </summary>
    public struct Message
    {
        public Severity severity;
        public string message;
        public ISymbol symbol;
        public SyntaxNode node;
        public Exception exception;

        public override string ToString() => message;
    }
}
