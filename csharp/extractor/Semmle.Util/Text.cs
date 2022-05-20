using System;
using System.IO;

namespace Semmle.Util
{
    /// <summary>
    /// An instance of this class represents a piece of text, e.g. the text of a C# source file.
    /// </summary>
    public sealed class Text
    {
        //#################### PRIVATE VARIABLES ####################
        #region

        /// <summary>
        /// The text, stored line-by-line.
        /// </summary>
        private readonly string[] lines;

        #endregion

        //#################### CONSTRUCTORS ####################
        #region

        /// <summary>
        /// Constructs a text object from an array of lines.
        /// </summary>
        /// <param name="lines">The lines of text.</param>
        public Text(string[] lines)
        {
            this.lines = lines;
        }

        #endregion

        //#################### PUBLIC METHODS ####################
        #region

        /// <summary>
        /// Gets the whole text.
        /// </summary>
        /// <returns>The whole text.</returns>
        public string GetAll()
        {
            using var sw = new StringWriter();
            foreach (var s in lines)
            {
                sw.WriteLine(s);
            }
            return sw.ToString();
        }

        /// <summary>
        /// Gets the portion of text that lies in the specified location range.
        /// </summary>
        /// <param name="startRow">The row at which the portion starts.</param>
        /// <param name="startColumn">The column in the start row at which the portion starts.</param>
        /// <param name="endRow">The row at which the portion ends.</param>
        /// <param name="endColumn">The column in the end row at which the portion ends.</param>
        /// <returns>The portion of text that lies in the specified location range.</returns>
        public string GetPortion(int startRow, int startColumn, int endRow, int endColumn)
        {
            // Perform some basic validation on the range bounds.
            if (startRow < 0 || endRow < 0 || startColumn < 0 || endColumn < 0 || endRow >= lines.Length || startRow > endRow)
            {
                throw new Exception
                (
                    string.Format("Bad range ({0},{1}):({2},{3}) in a piece of text with {4} lines", startRow, startColumn, endRow, endColumn, lines.Length)
                );
            }

            using var sw = new StringWriter();
            string line;

            for (var i = startRow; i <= endRow; ++i)
            {
                if (i == startRow && i == endRow)
                {
                    // This is a single-line range, so take the bit between "startColumn" and "endColumn".
                    line = startColumn <= lines[i].Length ? lines[i].Substring(startColumn, endColumn - startColumn) : "";
                }
                else if (i == startRow)
                {
                    // This is the first line of a multi-line range, so take the bit from "startColumn" onwards.
                    line = startColumn <= lines[i].Length ? lines[i].Substring(startColumn) : "";
                }
                else if (i == endRow)
                {
                    // This is the last line of a multi-line range, so take the bit up to "endColumn".
                    line = endColumn <= lines[i].Length ? lines[i].Substring(0, endColumn) : lines[i];
                }
                else
                {
                    // This is a line in the middle of a multi-line range, so take the whole line.
                    line = lines[i];
                }

                sw.WriteLine(line);
            }

            return sw.ToString();
        }

        #endregion
    }
}
