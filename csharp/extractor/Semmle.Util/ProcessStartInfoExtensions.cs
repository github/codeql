using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Semmle.Util
{
    public static class ProcessStartInfoExtensions
    {
        /// <summary>
        /// Runs this process, and returns the exit code, as well as the contents
        /// of stdout in <paramref name="stdout"/>.
        /// </summary>
        public static int ReadOutput(this ProcessStartInfo pi, out IList<string> stdout, Action<string>? onOut, Action<string>? onError)
        {
            var @out = new List<string>();
            using var process = new Process
            {
                StartInfo = pi
            };

            if (process.StartInfo.RedirectStandardOutput && !pi.UseShellExecute)
            {
                process.OutputDataReceived += new DataReceivedEventHandler((sender, e) =>
                {
                    if (e.Data == null)
                    {
                        return;
                    }

                    onOut?.Invoke(e.Data);
                    @out.Add(e.Data);
                });
            }
            if (process.StartInfo.RedirectStandardError && !pi.UseShellExecute)
            {
                process.ErrorDataReceived += new DataReceivedEventHandler((sender, e) =>
                {
                    if (e.Data == null)
                    {
                        return;
                    }

                    onError?.Invoke(e.Data);
                });
            }

            process.Start();

            if (process.StartInfo.RedirectStandardError)
            {
                process.BeginErrorReadLine();
            }

            if (process.StartInfo.RedirectStandardOutput)
            {
                process.BeginOutputReadLine();
            }

            process.WaitForExit();
            stdout = @out;
            return process.ExitCode;
        }
    }
}
