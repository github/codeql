using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Extraction.CSharp
{
    public sealed class InvalidFilePatternException : Exception
    {
        public InvalidFilePatternException(string pattern, string message) :
            base($"Invalid file pattern '{pattern}': {message}")
        { }
    }

    /// <summary>
    /// A file pattern, as used in either an extractor layout file or
    /// a path transformer file.
    /// </summary>
    public sealed class FilePattern
    {
        /// <summary>
        /// Whether this is an inclusion pattern.
        /// </summary>
        public bool Include { get; }

        public FilePattern(string pattern)
        {
            Include = true;
            if (pattern.StartsWith("-"))
            {
                pattern = pattern.Substring(1);
                Include = false;
            }
            pattern = FileUtils.ConvertToUnix(pattern.Trim()).TrimStart('/');
            RegexPattern = BuildRegex(pattern).ToString();
        }

        /// <summary>
        /// Constructs a regex string from a file pattern. Throws
        /// `InvalidFilePatternException` for invalid patterns.
        /// </summary>
        private static StringBuilder BuildRegex(string pattern)
        {
            bool HasCharAt(int i, Predicate<char> p) =>
                i >= 0 && i < pattern.Length && p(pattern[i]);
            var sb = new StringBuilder();
            var i = 0;
            var seenDoubleSlash = false;
            sb.Append('^');
            while (i < pattern.Length)
            {
                if (pattern[i] == '/')
                {
                    if (HasCharAt(i + 1, c => c == '/'))
                    {
                        if (seenDoubleSlash)
                            throw new InvalidFilePatternException(pattern, "'//' is allowed at most once.");
                        sb.Append("(?<doubleslash>/)");
                        i += 2;
                        seenDoubleSlash = true;
                    }
                    else
                    {
                        sb.Append('/');
                        i++;
                    }
                }
                else if (pattern[i] == '*')
                {
                    if (HasCharAt(i + 1, c => c == '*'))
                    {
                        if (HasCharAt(i - 1, c => c != '/'))
                            throw new InvalidFilePatternException(pattern, "'**' preceeded by non-`/` character.");
                        if (HasCharAt(i + 2, c => c != '/'))
                            throw new InvalidFilePatternException(pattern, "'**' succeeded by non-`/` character");

                        if (i + 2 < pattern.Length)
                        {
                            // Processing .../**/...
                            //                ^^^
                            sb.Append("(.*/|)");
                            i += 3;
                        }
                        else
                        {
                            // Processing .../** at the end of the pattern.
                            // There's no need to add .* because it's anyways added outside the loop.
                            break;
                        }
                    }
                    else
                    {
                        sb.Append("[^/]*");
                        i++;
                    }
                }
                else
                {
                    sb.Append(Regex.Escape(pattern[i++].ToString()));
                }
            }
            return sb.Append(".*");
        }


        /// <summary>
        /// The regex pattern compiled from this file pattern.
        /// </summary>
        public string RegexPattern { get; }

        /// <summary>
        /// Returns `true` if the set of file patterns `patterns` match the path `path`.
        /// If so, `transformerSuffix` will contain the part of `path` that needs to be
        /// suffixed when using path transformers.
        /// </summary>
        public static bool Matches(IEnumerable<FilePattern> patterns, string path, [NotNullWhen(true)] out string? transformerSuffix)
        {
            path = FileUtils.ConvertToUnix(path).TrimStart('/');

            foreach (var pattern in patterns.Reverse())
            {
                var m = new Regex(pattern.RegexPattern).Match(path);
                if (m.Success)
                {
                    if (pattern.Include)
                    {
                        transformerSuffix = m.Groups.TryGetValue("doubleslash", out var group)
                            ? path.Substring(group.Index)
                            : path;
                        return true;
                    }

                    transformerSuffix = null;
                    return false;
                }
            }

            transformerSuffix = null;
            return false;
        }
    }
}
