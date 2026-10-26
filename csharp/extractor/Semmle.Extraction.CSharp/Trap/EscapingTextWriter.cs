using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// A `TextWriter` object that wraps another `TextWriter` object, and which
    /// HTML escapes the characters &amp;, {, }, &quot;, @, and #, before
    /// writing to the underlying object.
    /// </summary>
    public sealed class EscapingTextWriter : TextWriter
    {
        private readonly TextWriter wrapped;
        private readonly bool disposeUnderlying;

        public EscapingTextWriter(TextWriter wrapped, bool disposeUnderlying = false)
        {
            this.wrapped = wrapped;
            this.disposeUnderlying = disposeUnderlying;
        }

        /// <summary>
        /// Creates a new instance with a new underlying `StringWriter` object. The
        /// underlying object is disposed of when this object is.
        /// </summary>
        public EscapingTextWriter() : this(new StringWriter(), true) { }

        public EscapingTextWriter(IFormatProvider? formatProvider) : base(formatProvider)
            => throw new NotImplementedException();

        private void WriteEscaped(char c)
        {
            switch (c)
            {
                case '&':
                    wrapped.Write("&amp;");
                    break;
                case '{':
                    wrapped.Write("&lbrace;");
                    break;
                case '}':
                    wrapped.Write("&rbrace;");
                    break;
                case '"':
                    wrapped.Write("&quot;");
                    break;
                case '@':
                    wrapped.Write("&commat;");
                    break;
                case '#':
                    wrapped.Write("&num;");
                    break;
                default:
                    wrapped.Write(c);
                    break;
            }
        }

        public void WriteSubId(IEntity entity)
        {
            if (entity is null)
            {
                wrapped.Write("<null>");
                return;
            }

            WriteUnescaped('{');
            wrapped.WriteLabel(entity);
            WriteUnescaped('}');
        }

        public void WriteUnescaped(char c)
            => wrapped.Write(c);

        public void WriteUnescaped(string s)
            => wrapped.Write(s);

        #region overrides

        public override Encoding Encoding => wrapped.Encoding;

        public override IFormatProvider FormatProvider => wrapped.FormatProvider;

        public override string NewLine { get => wrapped.NewLine; }

        public override void Close()
            => throw new NotImplementedException();

        public override ValueTask DisposeAsync()
            => throw new NotImplementedException();

        public override bool Equals(object? obj)
            => wrapped.Equals(obj) && obj is EscapingTextWriter other && disposeUnderlying == other.disposeUnderlying;

        public override void Flush()
            => wrapped.Flush();

        public override Task FlushAsync()
            => wrapped.FlushAsync();

        public override int GetHashCode()
            => HashCode.Combine(wrapped, disposeUnderlying);

        public override string ToString()
            => wrapped.ToString() ?? "";

        public override void Write(bool value)
            => wrapped.Write(value);

        public override void Write(char value)
            => WriteEscaped(value);

        public override void Write(char[]? buffer)
        {
            if (buffer is null)
                return;
            Write(buffer, 0, buffer.Length);
        }

        public override void Write(char[] buffer, int index, int count)
        {
            for (var i = index; i < buffer.Length && i < index + count; i++)
            {
                WriteEscaped(buffer[i]);
            }
        }


        public override void Write(decimal value)
            => wrapped.Write(value);

        public override void Write(double value)
            => wrapped.Write(value);

        public override void Write(int value)
            => wrapped.Write(value);

        public override void Write(long value)
            => wrapped.Write(value);

        public override void Write(object? value)
            => Write(value?.ToString());

        public override void Write(ReadOnlySpan<char> buffer)
        {
            foreach (var c in buffer)
            {
                WriteEscaped(c);
            }
        }

        public override void Write(float value)
            => wrapped.Write(value);

        public override void Write(string? value)
        {
            if (value is null)
            {
                wrapped.Write(value);
            }
            else
            {
                foreach (var c in value)
                {
                    WriteEscaped(c);
                }
            }
        }

        public override void Write(string format, object? arg0)
            => Write(string.Format(format, arg0));

        public override void Write(string format, object? arg0, object? arg1)
            => Write(string.Format(format, arg0, arg1));

        public override void Write(string format, object? arg0, object? arg1, object? arg2)
            => Write(string.Format(format, arg0, arg1, arg2));

        public override void Write(string format, params object?[] arg)
            => Write(string.Format(format, arg));

        public override void Write(StringBuilder? value)
        {
            if (value is null)
            {
                wrapped.Write(value);
            }
            else
            {
                for (var i = 0; i < value.Length; i++)
                {
                    WriteEscaped(value[i]);
                }
            }
        }

        public override void Write(uint value)
            => wrapped.Write(value);

        public override void Write(ulong value)
            => wrapped.Write(value);

        public override Task WriteAsync(char value)
            => throw new NotImplementedException();

        public override Task WriteAsync(char[] buffer, int index, int count)
            => throw new NotImplementedException();

        public override Task WriteAsync(ReadOnlyMemory<char> buffer, CancellationToken cancellationToken = default)
            => throw new NotImplementedException();

        public override Task WriteAsync(string? value)
            => throw new NotImplementedException();

        public override Task WriteAsync(StringBuilder? value, CancellationToken cancellationToken = default)
            => throw new NotImplementedException();

        public override void WriteLine()
            => wrapped.WriteLine();

        public override void WriteLine(bool value)
            => wrapped.WriteLine(value);

        public override void WriteLine(char value)
        {
            Write(value);
            WriteLine();
        }

        public override void WriteLine(char[]? buffer)
        {
            Write(buffer);
            WriteLine();
        }

        public override void WriteLine(char[] buffer, int index, int count)
        {
            Write(buffer, index, count);
            WriteLine();
        }

        public override void WriteLine(decimal value)
            => wrapped.WriteLine(value);

        public override void WriteLine(double value)
            => wrapped.WriteLine(value);

        public override void WriteLine(int value)
            => wrapped.WriteLine(value);

        public override void WriteLine(long value)
            => wrapped.WriteLine(value);

        public override void WriteLine(object? value)
        {
            Write(value);
            WriteLine();
        }

        public override void WriteLine(ReadOnlySpan<char> buffer)
        {
            Write(buffer);
            WriteLine();
        }

        public override void WriteLine(float value)
            => wrapped.WriteLine(value);

        public override void WriteLine(string? value)
        {
            Write(value);
            WriteLine();
        }

        public override void WriteLine(string format, object? arg0)
        {
            Write(format, arg0);
            WriteLine();
        }

        public override void WriteLine(string format, object? arg0, object? arg1)
        {
            Write(format, arg0, arg1);
            WriteLine();
        }

        public override void WriteLine(string format, object? arg0, object? arg1, object? arg2)
        {
            Write(format, arg0, arg1, arg2);
            WriteLine();
        }

        public override void WriteLine(string format, params object?[] arg)
        {
            Write(format, arg);
            WriteLine();
        }

        public override void WriteLine(StringBuilder? value)
        {
            Write(value);
            WriteLine();
        }

        public override void WriteLine(uint value)
            => wrapped.WriteLine(value);

        public override void WriteLine(ulong value)
            => wrapped.WriteLine(value);

        public override Task WriteLineAsync()
            => throw new NotImplementedException();

        public override Task WriteLineAsync(char value)
            => throw new NotImplementedException();

        public override Task WriteLineAsync(char[] buffer, int index, int count)
            => throw new NotImplementedException();

        public override Task WriteLineAsync(ReadOnlyMemory<char> buffer, CancellationToken cancellationToken = default)
            => throw new NotImplementedException();

        public override Task WriteLineAsync(string? value)
            => throw new NotImplementedException();

        public override Task WriteLineAsync(StringBuilder? value, CancellationToken cancellationToken = default)
            => throw new NotImplementedException();

        protected override void Dispose(bool disposing)
        {
            if (disposing && disposeUnderlying)
                wrapped.Dispose();
        }

        #endregion overrides
    }
}
