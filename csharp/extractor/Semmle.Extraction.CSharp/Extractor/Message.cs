using System.Text;
using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Encapsulates information for a log message.
    /// </summary>
    public class Message
    {
        public Severity Severity { get; }
        public string Text { get; }
        public string? StackTrace { get; }
        public string? EntityText { get; }
        public Entities.Location? Location { get; }

        public Message(string text, string? entityText, Entities.Location? location, string? stackTrace = null, Severity severity = Severity.Error)
        {
            Severity = severity;
            Text = text;
            StackTrace = stackTrace;
            EntityText = entityText;
            Location = location;
        }

        public static Message Create(Context cx, string text, ISymbol symbol, string? stackTrace = null, Severity severity = Severity.Error)
        {
            return new Message(text, symbol.ToString(), cx.CreateLocation(symbol.Locations.BestOrDefault()), stackTrace, severity);
        }

        public static Message Create(Context cx, string text, SyntaxNode node, string? stackTrace = null, Severity severity = Severity.Error)
        {
            return new Message(text, node.ToString(), cx.CreateLocation(node.GetLocation()), stackTrace, severity);
        }

        public override string ToString() => Text;

        public string ToLogString()
        {
            var sb = new StringBuilder();
            sb.Append(Text);
            if (!string.IsNullOrEmpty(EntityText))
                sb.Append(" in ").Append(EntityText);
            if (!(Location is null) && !(Location.Symbol is null))
                sb.Append(" at ").Append(Location.Symbol.GetLineSpan());
            if (!string.IsNullOrEmpty(StackTrace))
                sb.Append(" ").Append(StackTrace);
            return sb.ToString();
        }
    }
}
