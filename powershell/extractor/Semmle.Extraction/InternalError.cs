using Microsoft.CodeAnalysis;
using System;
using System.Linq;

namespace Semmle.Extraction
{
    /// <summary>
    /// Exception thrown whenever extraction encounters something unexpected.
    /// </summary>
    public class InternalError : Exception
    {
        public InternalError(ISymbol symbol, string msg)
        {
            Text = msg;
            EntityText = symbol.ToString() ?? "";
            Location = symbol.Locations.FirstOrDefault();
        }

        public InternalError(SyntaxNode node, string msg)
        {
            Text = msg;
            EntityText = node.ToString();
            Location = node.GetLocation();
        }

        public InternalError(string msg)
        {
            Text = msg;
            EntityText = "";
            Location = null;
        }

        public Location? Location { get; }
        public string Text { get; }
        public string EntityText { get; }

        public override string Message => Text;
    }
}
