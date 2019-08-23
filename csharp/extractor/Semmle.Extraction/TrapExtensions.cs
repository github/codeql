using System.IO;

namespace Semmle.Extraction
{
    public static class TrapExtensions
    {
        public static void WriteLabel(this TextWriter trapFile, int value)
        {
            trapFile.Write('#');
            trapFile.Write(value);
        }

        public static void WriteLabel(this TextWriter trapFile, IEntity entity)
        {
            trapFile.WriteLabel(entity.Label.Value);
        }

        public static void WriteSubId(this TextWriter trapFile, IEntity entity)
        {
            trapFile.Write('{');
            trapFile.WriteLabel(entity);
            trapFile.Write('}');
        }

        public static void WriteSeparator(this TextWriter trapFile, string separator, ref int index)
        {
            if (index++ > 0) trapFile.Write(separator);
        }

        public struct FirstParam
        {
            private readonly TextWriter Writer;

            public FirstParam(TextWriter trapFile)
            {
                Writer = trapFile;
            }

            public NextParam Param(IEntity entity)
            {
                Writer.WriteLabel(entity.Label.Value);
                return new NextParam(Writer);
            }

            public NextParam Param(Label label)
            {
                Writer.WriteLabel(label.Value);
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

            public NextParam(TextWriter trapFile)
            {
                Writer = trapFile;
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

        private static void WriteString(TextWriter trapFile, string s) => trapFile.Write(EncodeString(s));

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
        /// <param name="trapFile">The trapbuilder</param>
        /// <param name="s">The string to output.</param>
        /// <param name="bytesRemaining">The remaining bytes available to output.</param>
        private static void WriteTruncatedString(TextWriter trapFile, string s, ref int bytesRemaining)
        {
            WriteString(trapFile, TruncateString(s, ref bytesRemaining));
        }

        public static void WriteTrapString(this TextWriter trapFile, string s)
        {
            trapFile.Write('\"');
            if (NeedsTruncation(s))
            {
                // Slow path
                int remaining = maxStringBytes;
                WriteTruncatedString(trapFile, s, ref remaining);
            }
            else
            {
                // Fast path
                WriteString(trapFile, s);
            }
            trapFile.Write('\"');
        }

        public static void WriteTrapFloat(this TextWriter trapFile, float f)
        {
            trapFile.Write(f.ToString("0.#####e0"));  // Trap importer won't accept ints
        }

        public static FirstParam BeginTuple(this TextWriter trapFile, string name)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            return new FirstParam(trapFile);
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1)
        {
            trapFile.BeginTuple(name).Param(p1).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, IEntity p2)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, string p2, IEntity p3, IEntity p4)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).Param(p4).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, string p2, IEntity p3)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, int p2, IEntity p3)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, int p2, int p3)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, IEntity p2, int p3)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, IEntity p2, IEntity p3)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, string p2, IEntity p3, IEntity p4, IEntity p5)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).Param(p3).Param(p4).Param(p5).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, int p2)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, string p2)
        {
            trapFile.BeginTuple(name).Param(p1).Param(p2).EndTuple();
        }
    }
}
