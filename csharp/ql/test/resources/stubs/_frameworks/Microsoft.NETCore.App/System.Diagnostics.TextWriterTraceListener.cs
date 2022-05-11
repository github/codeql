// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.ConsoleTraceListener` in `System.Diagnostics.TextWriterTraceListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ConsoleTraceListener : System.Diagnostics.TextWriterTraceListener
        {
            public override void Close() => throw null;
            public ConsoleTraceListener() => throw null;
            public ConsoleTraceListener(bool useErrorStream) => throw null;
        }

        // Generated from `System.Diagnostics.DelimitedListTraceListener` in `System.Diagnostics.TextWriterTraceListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DelimitedListTraceListener : System.Diagnostics.TextWriterTraceListener
        {
            public DelimitedListTraceListener(System.IO.Stream stream) => throw null;
            public DelimitedListTraceListener(System.IO.Stream stream, string name) => throw null;
            public DelimitedListTraceListener(System.IO.TextWriter writer) => throw null;
            public DelimitedListTraceListener(System.IO.TextWriter writer, string name) => throw null;
            public DelimitedListTraceListener(string fileName) => throw null;
            public DelimitedListTraceListener(string fileName, string name) => throw null;
            public string Delimiter { get => throw null; set => throw null; }
            protected override string[] GetSupportedAttributes() => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, object data) => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, params object[] data) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string message) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string format, params object[] args) => throw null;
        }

        // Generated from `System.Diagnostics.TextWriterTraceListener` in `System.Diagnostics.TextWriterTraceListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TextWriterTraceListener : System.Diagnostics.TraceListener
        {
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override void Flush() => throw null;
            public TextWriterTraceListener() => throw null;
            public TextWriterTraceListener(System.IO.Stream stream) => throw null;
            public TextWriterTraceListener(System.IO.Stream stream, string name) => throw null;
            public TextWriterTraceListener(System.IO.TextWriter writer) => throw null;
            public TextWriterTraceListener(System.IO.TextWriter writer, string name) => throw null;
            public TextWriterTraceListener(string fileName) => throw null;
            public TextWriterTraceListener(string fileName, string name) => throw null;
            public override void Write(string message) => throw null;
            public override void WriteLine(string message) => throw null;
            public System.IO.TextWriter Writer { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.XmlWriterTraceListener` in `System.Diagnostics.TextWriterTraceListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class XmlWriterTraceListener : System.Diagnostics.TextWriterTraceListener
        {
            public override void Close() => throw null;
            public override void Fail(string message, string detailMessage) => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, object data) => throw null;
            public override void TraceData(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, params object[] data) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string message) => throw null;
            public override void TraceEvent(System.Diagnostics.TraceEventCache eventCache, string source, System.Diagnostics.TraceEventType eventType, int id, string format, params object[] args) => throw null;
            public override void TraceTransfer(System.Diagnostics.TraceEventCache eventCache, string source, int id, string message, System.Guid relatedActivityId) => throw null;
            public override void Write(string message) => throw null;
            public override void WriteLine(string message) => throw null;
            public XmlWriterTraceListener(System.IO.Stream stream) => throw null;
            public XmlWriterTraceListener(System.IO.Stream stream, string name) => throw null;
            public XmlWriterTraceListener(System.IO.TextWriter writer) => throw null;
            public XmlWriterTraceListener(System.IO.TextWriter writer, string name) => throw null;
            public XmlWriterTraceListener(string filename) => throw null;
            public XmlWriterTraceListener(string filename, string name) => throw null;
        }

    }
}
