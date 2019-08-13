using System.IO;
using System.Linq;

namespace Semmle.Extraction
{
    /// <summary>
    /// A tuple represents a string of the form "a(b,c,d)".
    /// </summary>
    public struct Tuple : ITrapEmitter
    {
        readonly string Name;
        readonly object[] Args;

        public Tuple(string name, params object[] args)
        {
            Name = name;
            Args = args;
        }

        const int maxStringBytes = 1<<20;  // 1MB
        static readonly System.Text.Encoding encoding = System.Text.Encoding.UTF8;

        private static bool NeedsTruncation(string s)
        {
            // Optimization: only count the actual number of bytes if there is the possibility 
            // of the string exceeding maxStringBytes
            return encoding.GetMaxByteCount(s.Length) > maxStringBytes &&
                encoding.GetByteCount(s) > maxStringBytes;
        }

        private static bool NeedsTruncation(string[] array)
        {
            // Optimization: only count the actual number of bytes if there is the possibility 
            // of the strings exceeding maxStringBytes
            return encoding.GetMaxByteCount(array.Sum(s => s.Length)) > maxStringBytes &&
                array.Sum(encoding.GetByteCount) > maxStringBytes;
        }

        private static void WriteString(TextWriter tb, string s) => tb.Write(EncodeString(s));

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
        /// <param name="tb">The trapbuilder</param>
        /// <param name="s">The string to output.</param>
        /// <param name="bytesRemaining">The remaining bytes available to output.</param>
        private static void WriteTruncatedString(TextWriter tb, string s, ref int bytesRemaining)
        {
            WriteString(tb, TruncateString(s, ref bytesRemaining));
        }

        /// <summary>
        /// Constructs a unique string for this tuple.
        /// </summary>
        /// <param name="tw">The trap builder used to store the result.</param>
        public void EmitToTrapBuilder(TextWriter tw)
        {
            tw.Write(Name);
            tw.Write("(");

            int column = 0;
            foreach (var a in Args)
            {
                tw.WriteSeparator(", ", column++);
                switch(a)
                {
                    case Label l:
                        l.AppendTo(tw);
                        break;
                    case IEntity e:
                        e.Label.AppendTo(tw);
                        break;
                    case string s:
                        tw.Write("\"");
                        if (NeedsTruncation(s))
                        {
                            // Slow path
                            int remaining = maxStringBytes;
                            WriteTruncatedString(tw, s, ref remaining);
                        }
                        else
                        {
                            // Fast path
                            WriteString(tw, s);
                        }
                        tw.Write("\"");
                        break;
                    case System.Enum _:
                        tw.Write((int)a);
                        break;
                    case int i:
                        tw.Write(i);
                        break;
                    case float f:
                        tw.Write(f.ToString("0.#####e0"));  // Trap importer won't accept ints
                        break;
                    case string[] array:
                        tw.Write('\"');
                        if (NeedsTruncation(array))
                        {
                            // Slow path
                            int remaining = maxStringBytes;
                            foreach (var element in array)
                                WriteTruncatedString(tw, element, ref remaining);
                        }
                        else
                        {
                            // Fast path
                            foreach (var element in array)
                                WriteString(tw, element);
                        }
                        tw.Write('\"');
                        break;
                    case null:
                        throw new InternalError($"Attempt to write a null argument tuple {Name} at column {column}");
                    default:
                        throw new InternalError($"Attempt to write an invalid argument type {a.GetType()} in tuple {Name} at column {column}");
                }

                ++column;
            }
            tw.WriteLine(")");
        }

        public override string ToString()
        {
            // Only implemented for debugging purposes
            using (var writer = new StringWriter())
            {
                EmitToTrapBuilder(writer);
                return writer.ToString();
            }
        }
    }
}
