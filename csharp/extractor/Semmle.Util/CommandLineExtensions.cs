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
        /// <param name="filename">The full filename to write to.</param>
        /// <returns>True iff the file was written.</returns>
        public static bool ArchiveCommandLine(this IEnumerable<string> commandLineArguments, string filename)
        {
            foreach (var arg in commandLineArguments.Where(arg => arg[0] == '@').Select(arg => arg.Substring(1)))
            {
                File.Copy(arg, filename, true);
                return true;
            }
            return false;
        }
    }
}
