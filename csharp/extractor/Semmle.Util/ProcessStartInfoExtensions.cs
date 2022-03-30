﻿using System.Collections.Generic;
using System.Diagnostics;

namespace Semmle.Util
{
    public static class ProcessStartInfoExtensions
    {
        /// <summary>
        /// Runs this process, and returns the exit code, as well as the contents
        /// of stdout in <paramref name="stdout"/>.
        /// </summary>
        public static int ReadOutput(this ProcessStartInfo pi, out IList<string> stdout)
        {
            stdout = new List<string>();
            using var process = Process.Start(pi);

            if (process is null)
            {
                return -1;
            }

            string? s;
            do
            {
                s = process.StandardOutput.ReadLine();
                if (s is not null)
                    stdout.Add(s);
            }
            while (s is not null);
            process.WaitForExit();
            return process.ExitCode;
        }
    }
}
