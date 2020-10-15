using System;

namespace Semmle.Util
{
    /// <summary>
    /// An instance of this class is used to store the computed line count metrics (of
    /// various different types) for a piece of text.
    /// </summary>
    public sealed class LineCounts
    {
        //#################### PROPERTIES ####################
        #region

        /// <summary>
        /// The number of lines in the text that contain code.
        /// </summary>
        public int Code { get; set; }

        /// <summary>
        /// The number of lines in the text that contain comments.
        /// </summary>
        public int Comment { get; set; }

        /// <summary>
        /// The total number of lines in the text.
        /// </summary>
        public int Total { get; set; }

        #endregion

        //#################### PUBLIC METHODS ####################
        #region

        public override bool Equals(object? other)
        {
            return other is LineCounts rhs &&
                Total == rhs.Total &&
                Code == rhs.Code &&
                Comment == rhs.Comment;
        }

        public override int GetHashCode()
        {
            return Total ^ Code ^ Comment;
        }

        public override string ToString()
        {
            return "Total: " + Total + " Code: " + Code + " Comment: " + Comment;
        }

        #endregion
    }

    /// <summary>
    /// This class can be used to compute line count metrics of various different types
    /// (code, comment and total) for a piece of text.
    /// </summary>
    public static class LineCounter
    {
        //#################### NESTED CLASSES ####################
        #region

        /// <summary>
        /// An instance of this class keeps track of the contextual information required during line counting.
        /// </summary>
        private class Context
        {
            /// <summary>
            /// The index of the current character under consideration.
            /// </summary>
            public int CurIndex { get; set; }

            /// <summary>
            /// Whether or not the current line under consideration contains any code.
            /// </summary>
            public bool HasCode { get; set; }

            /// <summary>
            /// Whether or not the current line under consideration contains a comment.
            /// </summary>
            public bool HasComment { get; set; }
        }

        #endregion

        //#################### PUBLIC METHODS ####################
        #region

        /// <summary>
        /// Computes line count metrics for the specified input text.
        /// </summary>
        /// <param name="input">The input text for which to compute line count metrics.</param>
        /// <returns>The computed metrics.</returns>
        public static LineCounts ComputeLineCounts(string input)
        {
            var counts = new LineCounts();
            var context = new Context();

            char? cur, prev = null;
            while ((cur = GetNext(input, context)) != null)
            {
                if (IsNewLine(cur))
                {
                    RegisterNewLine(counts, context);
                    cur = null;
                }
                else if (cur == '*' && prev == '/')
                {
                    ReadMultiLineComment(input, counts, context);
                    cur = null;
                }
                else if (cur == '/' && prev == '/')
                {
                    ReadEOLComment(input, context);
                    context.HasComment = true;
                    cur = null;
                }
                else if (cur == '"')
                {
                    ReadRestOfString(input, context);
                    context.HasCode = true;
                    cur = null;
                }
                else if (cur == '\'')
                {
                    ReadRestOfChar(input, context);
                    context.HasCode = true;
                    cur = null;
                }
                else if (!IsWhitespace(cur) && cur != '/')  // exclude '/' to avoid counting comments as code
                {
                    context.HasCode = true;
                }
                prev = cur;
            }

            // The final line of text should always be counted, even if it's empty.
            RegisterNewLine(counts, context);

            return counts;
        }

        #endregion

        //#################### PRIVATE METHODS ####################
        #region

        /// <summary>
        /// Gets the next character to be considered from the input text and updates the current character index accordingly.
        /// </summary>
        /// <param name="input">The input text for which we are computing line count metrics.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        /// <returns></returns>
        private static char? GetNext(string input, Context context)
        {
            return input == null || context.CurIndex >= input.Length ?
                (char?)null :
                input[context.CurIndex++];
        }

        /// <summary>
        /// Determines whether or not the specified character equals '\n'.
        /// </summary>
        /// <param name="c">The character to test.</param>
        /// <returns>true, if the specified character equals '\n', or false otherwise.</returns>
        private static bool IsNewLine(char? c)
        {
            return c == '\n';
        }

        /// <summary>
        /// Determines whether or not the specified character should be considered to be whitespace.
        /// </summary>
        /// <param name="c">The character to test.</param>
        /// <returns>true, if the specified character should be considered to be whitespace, or false otherwise.</returns>
        private static bool IsWhitespace(char? c)
        {
            return c == ' ' || c == '\t' || c == '\r';
        }

        /// <summary>
        /// Consumes the input text up to the end of the current line (not including any '\n').
        /// This is used to consume an end-of-line comment (i.e. a //-style comment).
        /// </summary>
        /// <param name="input">The input text.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        private static void ReadEOLComment(string input, Context context)
        {
            char? c;
            do
            {
                c = GetNext(input, context);
            } while (c != null && !IsNewLine(c));

            // If we reached the end of a line (as opposed to reaching the end of the text),
            // put the '\n' back so that it can be handled by the normal newline processing
            // code.
            if (IsNewLine(c))
                --context.CurIndex;
        }

        /// <summary>
        /// Consumes the input text up to the end of a multi-line comment.
        /// </summary>
        /// <param name="input">The input text.</param>
        /// <param name="counts">The line count metrics for the input text.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        private static void ReadMultiLineComment(string input, LineCounts counts, Context context)
        {
            char? cur = '\0', prev = null;
            context.HasComment = true;
            while (cur != null && ((cur = GetNext(input, context)) != '/' || prev != '*'))
            {
                if (IsNewLine(cur))
                {
                    RegisterNewLine(counts, context);
                    context.HasComment = true;
                }
                prev = cur;
            }
        }

        /// <summary>
        /// Consumes the input text up to the end of a character literal, e.g. '\t'.
        /// </summary>
        /// <param name="input">The input text.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        private static void ReadRestOfChar(string input, Context context)
        {
            if (GetNext(input, context) == '\\')
            {
                GetNext(input, context);
            }
            GetNext(input, context);
        }

        /// <summary>
        /// Consumes the input text up to the end of a string literal, e.g. "Wibble".
        /// </summary>
        /// <param name="input">The input text.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        private static void ReadRestOfString(string input, Context context)
        {
            char? cur = '\0';
            var numSlashes = 0;
            while (cur != null && ((cur = GetNext(input, context)) != '"' || (numSlashes % 2 != 0)))
            {
                if (cur == '\\')
                    ++numSlashes;
                else
                    numSlashes = 0;
            }
        }

        /// <summary>
        /// Updates the line count metrics when a newline character is seen, and resets
        /// the code and comment flags in the context ready to process the next line.
        /// </summary>
        /// <param name="counts">The line count metrics for the input text.</param>
        /// <param name="context">The contextual information required during line counting.</param>
        private static void RegisterNewLine(LineCounts counts, Context context)
        {
            ++counts.Total;

            if (context.HasCode)
            {
                ++counts.Code;
                context.HasCode = false;
            }

            if (context.HasComment)
            {
                ++counts.Comment;
                context.HasComment = false;
            }
        }

        #endregion
    }
}
