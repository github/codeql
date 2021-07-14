using System.Diagnostics;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal static class DotNet
    {
        public static int RestoreToDirectory(string projectOrSolutionFile, string packageDirectory)
        {
            using var proc = Process.Start("dotnet", $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true");
            proc.WaitForExit();
            return proc.ExitCode;
        }
    }
}
