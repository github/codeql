using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Util
{
    public static class CommandLineExtensions
    {
        /// <summary>
        /// Archives the first "@" argument in a list of command line arguments.
        /// Subsequent "@" arguments are ignored.
        /// </summary>
        /// <param name="commandLineArguments">The raw command line arguments.</param>
        /// <param name="textWriter">The writer to archive to.</param>
        /// <returns>True iff the file was written.</returns>
        public static bool WriteCommandLine(this IEnumerable<string> commandLineArguments, TextWriter textWriter)
        {
            var found = false;
            foreach (var arg in commandLineArguments.Where(arg => arg.StartsWith('@')).Select(arg => arg.Substring(1)))
            {
                string? line;
                using var file = new StreamReader(arg);
                while ((line = file.ReadLine()) is not null)
                    textWriter.WriteLine(line);
                found = true;
            }
            return found;
        }
    }
}
