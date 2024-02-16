using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Util
{
    public static class CommandLineExtensions
    {
        public static bool IsFileArgument(string arg) => arg.StartsWith('@');

        /// <summary>
        /// Archives the content of all the "@" arguments in a list of command line arguments.
        /// </summary>
        /// <param name="textWriter">The writer to archive to.</param>
        /// <param name="commandLineArguments">The raw command line arguments.</param>
        /// <returns>True iff the file was written.</returns>
        public static bool WriteContentFromArgumentFile(this TextWriter textWriter, IEnumerable<string> commandLineArguments)
        {
            var found = false;
            foreach (var arg in commandLineArguments.Where(IsFileArgument).Select(arg => arg[1..]))
            {
                string? line;
                using var file = new StreamReader(arg);
                while ((line = file.ReadLine()) is not null)
                {
                    textWriter.WriteLine(line);
                }
                found = true;
            }
            return found;
        }
    }
}
