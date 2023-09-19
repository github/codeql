using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Semmle.Util
{
    public static class ProcessStartInfoExtensions
    {
        /// <summary>
        /// Runs this process, and returns the exit code, as well as the contents
        /// of stdout in <paramref name="stdout"/>. If <paramref name="printToConsole"/>
        /// is true, then stdout is printed to the console and each line is prefixed
        /// with the thread id.
        /// </summary>
        public static int ReadOutput(this ProcessStartInfo pi, out IList<string> stdout, bool printToConsole)
        {
            stdout = new List<string>();
            using var process = Process.Start(pi);

            if (process is null)
            {
                return -1;
            }

            if (pi.RedirectStandardOutput && !pi.UseShellExecute)
            {
                string? s;
                do
                {
                    s = process.StandardOutput.ReadLine();
                    if (s is not null)
                    {
                        if (printToConsole)
                        {
                            Console.WriteLine($"[{Environment.CurrentManagedThreadId:D3}] {s}");
                        }
                        stdout.Add(s);
                    }
                }
                while (s is not null);
            }
            process.WaitForExit();
            return process.ExitCode;
        }
    }
}
