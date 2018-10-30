using Semmle.Util.Logging;
using Microsoft.CodeAnalysis;
using System;

namespace Semmle.Extraction
{
    /// <summary>
    /// Exception thrown whenever extraction encounters something unexpected.
    /// </summary>
    public class InternalError : Exception
    {
        public InternalError(ISymbol symbol, string msg, params object[] args)
        {
            ExtractionMessage = new Message { exception = this, symbol = symbol, severity = Severity.Error, message = string.Format(msg, args) };
        }

        public InternalError(SyntaxNode node, string msg, params object[] args)
        {
            ExtractionMessage = new Message { exception = this, node = node, severity = Severity.Error, message = string.Format(msg, args) };
        }

        public InternalError(string msg, params object[] args)
        {
            ExtractionMessage = new Message { exception = this, severity = Severity.Error, message = string.Format(msg, args) };
        }

        public Message ExtractionMessage
        {
            get; private set;
        }

        public override string Message => ExtractionMessage.message;
    }
}
