﻿using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;
using System;
using System.Linq;
using System.Text;

namespace Semmle.Extraction
{
    /// <summary>
    /// Encapsulates information for a log message.
    /// </summary>
    public class Message
    {
        public readonly Severity Severity;
        public readonly string Text;
        public readonly string StackTrace;
        public readonly string EntityText;
        public readonly Entities.Location? Location;

        public Message(string text, string entityText, Entities.Location? location, string? stackTrace = null, Severity severity = Severity.Error)
        {
            Severity = severity;
            Text = text;
            StackTrace = stackTrace ?? "";
            EntityText = entityText;
            Location = location;
        }

        public static Message Create(Context cx, string text, ISymbol symbol, string? stackTrace = null, Severity severity = Severity.Error)
        {
            return new Message(text, symbol.ToString() ?? "", Entities.Location.Create(cx, symbol.Locations.FirstOrDefault()), stackTrace, severity);
        }

        public static Message Create(Context cx, string text, SyntaxNode node, string? stackTrace = null, Severity severity = Severity.Error)
        {
            return new Message(text, node.ToString(), Entities.Location.Create(cx, node.GetLocation()), stackTrace, severity);
        }

        public override string ToString() => Text;

        public string ToLogString()
        {
            var sb = new StringBuilder();
            sb.Append(Text);
            if (!string.IsNullOrEmpty(EntityText))
                sb.Append(" in ").Append(EntityText);
            if (!(Location is null) && !(Location.UnderlyingObject is null))
                sb.Append(" at ").Append(Location.UnderlyingObject.GetLineSpan());
            if (!string.IsNullOrEmpty(StackTrace))
                sb.Append(" ").Append(StackTrace);
            return sb.ToString();
        }
    }
}
