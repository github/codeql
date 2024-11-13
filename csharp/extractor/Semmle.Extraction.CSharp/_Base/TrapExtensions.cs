using System;
using System.Collections.Generic;
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

        public static void WriteSeparator(this TextWriter trapFile, string separator, ref int index)
        {
            if (index++ > 0)
                trapFile.Write(separator);
        }


        public static TextWriter WriteColumn(this TextWriter trapFile, int i)
        {
            trapFile.Write(i);
            return trapFile;
        }

        public static TextWriter WriteColumn(this TextWriter trapFile, string s)
        {
            trapFile.WriteTrapString(s);
            return trapFile;
        }

        public static TextWriter WriteColumn(this TextWriter trapFile, IEntity entity)
        {
            trapFile.WriteLabel(entity.Label.Value);
            return trapFile;
        }

        public static TextWriter WriteColumn(this TextWriter trapFile, Label label)
        {
            trapFile.WriteLabel(label.Value);
            return trapFile;
        }


        public static TextWriter WriteColumn(this TextWriter trapFile, float f)
        {
            trapFile.WriteTrapFloat(f);
            return trapFile;
        }


        public static TextWriter WriteColumn(this TextWriter trapFile, object o)
        {
            switch (o)
            {
                case int i:
                    return trapFile.WriteColumn(i);
                case float f:
                    return trapFile.WriteColumn(f);
                case string s:
                    return trapFile.WriteColumn(s);
                case IEntity e:
                    return trapFile.WriteColumn(e);
                case Label l:
                    return trapFile.WriteColumn(l);
                case Enum _:
                    return trapFile.WriteColumn((int)o);
                default:
                    throw new NotSupportedException($"Unsupported object type '{o.GetType()}' received");
            }
        }

        private const int maxStringBytes = 1 << 20;  // 1MB
        private static readonly System.Text.Encoding encoding = System.Text.Encoding.UTF8;

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
            var outputLen = encoding.GetByteCount(s);
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

        public static string EncodeString(string s) => s.Replace("\"", "\"\"");

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
                var remaining = maxStringBytes;
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
            trapFile.Write(f.ToString("F5", System.Globalization.CultureInfo.InvariantCulture));  // Trap importer won't accept ints
        }

        public static void WriteTuple(this TextWriter trapFile, string name, params object[] @params)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            var index = 0;
            foreach (var p in @params)
            {
                trapFile.WriteSeparator(",", ref index);
                trapFile.WriteColumn(p);
            }
            trapFile.WriteLine(')');
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            trapFile.WriteColumn(p1);
            trapFile.WriteLine(')');
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, object p2)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            trapFile.WriteColumn(p1);
            trapFile.Write(',');
            trapFile.WriteColumn(p2);
            trapFile.WriteLine(')');
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, object p2, object p3)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            trapFile.WriteColumn(p1);
            trapFile.Write(',');
            trapFile.WriteColumn(p2);
            trapFile.Write(',');
            trapFile.WriteColumn(p3);
            trapFile.WriteLine(')');
        }

        public static void WriteTuple(this TextWriter trapFile, string name, IEntity p1, object p2, object p3, object p4)
        {
            trapFile.Write(name);
            trapFile.Write('(');
            trapFile.WriteColumn(p1);
            trapFile.Write(',');
            trapFile.WriteColumn(p2);
            trapFile.Write(',');
            trapFile.WriteColumn(p3);
            trapFile.Write(',');
            trapFile.WriteColumn(p4);
            trapFile.WriteLine(')');
        }

        /// <summary>
        /// Appends a [comma] separated list to a trap builder.
        /// </summary>
        /// <typeparam name="T">The type of the list.</typeparam>
        /// <param name="trapFile">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static TextWriter AppendList<T>(this EscapingTextWriter trapFile, string separator, IEnumerable<T> items) where T : IEntity
        {
            return trapFile.BuildList(separator, items, x => trapFile.WriteSubId(x));
        }

        /// <summary>
        /// Builds a trap builder using a separator and an action for each item in the list.
        /// </summary>
        /// <typeparam name="T">The type of the items.</typeparam>
        /// <param name="trapFile">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <param name="action">The action on each item.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static T1 BuildList<T1, T2>(this T1 trapFile, string separator, IEnumerable<T2> items, Action<int, T2> action)
            where T1 : TextWriter
        {
            var first = true;
            var i = 0;
            foreach (var item in items)
            {
                if (first)
                    first = false;
                else
                    trapFile.Write(separator);
                action(i++, item);
            }
            return trapFile;
        }

        /// <summary>
        /// Builds a trap builder using a separator and an action for each item in the list.
        /// </summary>
        /// <typeparam name="T">The type of the items.</typeparam>
        /// <param name="trapFile">The trap builder to append to.</param>
        /// <param name="separator">The separator string (e.g. ",")</param>
        /// <param name="items">The list of items.</param>
        /// <param name="action">The action on each item.</param>
        /// <returns>The original trap builder (fluent interface).</returns>
        public static T1 BuildList<T1, T2>(this T1 trapFile, string separator, IEnumerable<T2> items, Action<T2> action)
            where T1 : TextWriter =>
            trapFile.BuildList(separator, items, (_, item) => action(item));
    }
}
