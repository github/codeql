using System.IO;

namespace Semmle.Extraction
{
    public static class TrapExtensions
    {
        public static void WriteLabel(this TextWriter writer, int value)
        {
            writer.Write('#');
            writer.Write(value);
        }

        public static void WriteLabel(this TextWriter writer, IEntity entity)
        {
            writer.WriteLabel(entity.Label.Value);
        }

        public static void WriteSubId(this TextWriter writer, IEntity entity)
        {
            writer.Write('{');
            writer.WriteLabel(entity);
            writer.Write('}');
        }

        public static void WriteSeparator(this TextWriter writer, string separator, int index)
        {
            if (index > 0) writer.Write(separator);
        }

        // This is temporary and we can get rid of IId entirely
        public static void WriteIId(this TextWriter writer, IId iid)
        {
            iid.AppendTo(writer);
        }

        public struct FirstParam
        {
            private readonly TextWriter Writer;

            public FirstParam(TextWriter writer)
            {
                Writer = writer;
            }

            public NextParam Param(IEntity entity)
            {
                Writer.WriteLabel(entity.Label.Value);
                return new NextParam(Writer);
            }

            public void EndTuple()
            {
                Writer.WriteLine(')');
            }
        }

        public struct NextParam
        {
            private readonly TextWriter Writer;

            public NextParam(TextWriter writer)
            {
                Writer = writer;
            }

            private void WriteComma()
            {
                Writer.Write(", ");
            }

            public NextParam Param(string str)
            {
                WriteComma();
                Writer.WriteTrapString(str);
                return this;
            }

            public NextParam Param(float f)
            {
                WriteComma();
                Writer.WriteTrapFloat(f);
                return this;
            }

            public NextParam Param(Label label)
            {
                WriteComma();
                Writer.WriteLabel(label.Value);
                return this;
            }

            public NextParam Param(int i)
            {
                WriteComma();
                Writer.Write(i);
                return this;
            }

            public NextParam Param(IEntity e)
            {
                WriteComma();
                Writer.WriteLabel(e.Label.Value);
                return this;
            }

            public void EndTuple()
            {
                Writer.WriteLine(')');
            }
        }

        const int maxStringBytes = 1 << 20;  // 1MB
        static readonly System.Text.Encoding encoding = System.Text.Encoding.UTF8;

        private static bool NeedsTruncation(string s)
        {
            // Optimization: only count the actual number of bytes if there is the possibility 
            // of the string exceeding maxStringBytes
            return encoding.GetMaxByteCount(s.Length) > maxStringBytes &&
                encoding.GetByteCount(s) > maxStringBytes;
        }

        private static void WriteString(TextWriter writer, string s) => writer.Write(EncodeString(s));

        /// <summary>
        /// Truncates a string such that the output UTF8 does not exceed <paramref name="bytesRemaining"/> bytes.
        /// </summary>
        /// <param name="s">The input string to truncate.</param>
        /// <param name="bytesRemaining">The number of bytes available.</param>
        /// <returns>The truncated string.</returns>
        private static string TruncateString(string s, ref int bytesRemaining)
        {
            int outputLen = encoding.GetByteCount(s);
            if (outputLen > bytesRemaining)
            {
                outputLen = 0;
                int chars;
                for (chars = 0; chars < s.Length; ++chars)
                {
                    var bytes = encoding.GetByteCount(s, chars, 1);
                    if (outputLen + bytes <= bytesRemaining)
                        outputLen += bytes;
                    else
                        break;
                }
                s = s.Substring(0, chars);
            }
            bytesRemaining -= outputLen;
            return s;
        }

        private static string EncodeString(string s) => s.Replace("\"", "\"\"");

        /// <summary>
        /// Output a string to the trap file, such that the encoded output does not exceed
        /// <paramref name="bytesRemaining"/> bytes.
        /// </summary>
        /// <param name="writer">The trapbuilder</param>
        /// <param name="s">The string to output.</param>
        /// <param name="bytesRemaining">The remaining bytes available to output.</param>
        private static void WriteTruncatedString(TextWriter writer, string s, ref int bytesRemaining)
        {
            WriteString(writer, TruncateString(s, ref bytesRemaining));
        }

        public static void WriteTrapString(this TextWriter writer, string s)
        {
            writer.Write('\"');
            if (NeedsTruncation(s))
            {
                // Slow path
                int remaining = maxStringBytes;
                WriteTruncatedString(writer, s, ref remaining);
            }
            else
            {
                // Fast path
                WriteString(writer, s);
            }
            writer.Write('\"');
        }

        public static void WriteTrapFloat(this TextWriter writer, float f)
        {
            writer.Write(f.ToString("0.#####e0"));  // Trap importer won't accept ints
        }


        public static FirstParam BeginTuple(this TextWriter writer, string name)
        {
            writer.Write(name);
            writer.Write('(');
            return new FirstParam(writer);
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1)
        {
            writer.BeginTuple(name).Param(p1).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, IEntity p2)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, string p2, IEntity p3, IEntity p4)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).Param(p4).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, string p2, IEntity p3)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, int p2, IEntity p3)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, int p2, int p3)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, IEntity p2, int p3)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, IEntity p2, IEntity p3)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, string p2, IEntity p3, IEntity p4, IEntity p5)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).Param(p3).Param(p4).Param(p5).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, int p2)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }

        public static void WriteTuple(this TextWriter writer, string name, IEntity p1, string p2)
        {
            writer.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }


        // DELETEME
        public static void Emit(this TextWriter writer, Tuple t)
        {
            t.EmitToTrapBuilder(writer);
        }
    }
}
