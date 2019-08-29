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
            foreach (var arg in commandLineArguments.Where(arg => arg[0] == '@').Select(arg => arg.Substring(1)))
            {
                string line;
                using (StreamReader file = new StreamReader(arg))
                    while ((line = file.ReadLine()) != null)
                        textWriter.WriteLine(line);
                return true;
            }
            return false;
        }
    }
}
