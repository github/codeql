using System;
using System.Linq;
using System.Collections.Generic;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Dependency fetching related options.
    /// </summary>
    public interface IDependencyOptions
    {
        /// <summary>
        /// Directories to search DLLs in.
        /// </summary>
        IList<string> DllDirs { get; }

        /// <summary>
        /// Files/patterns to exclude.
        /// </summary>
        IList<string> Excludes { get; }

        /// <summary>
        /// Whether to analyse NuGet packages.
        /// </summary>
        bool UseNuGet { get; }

        /// <summary>
        /// The solution file to analyse, or null if not specified.
        /// </summary>
        string? SolutionFile { get; }

        /// <summary>
        /// Whether to use the packaged dotnet runtime.
        /// </summary>
        bool UseSelfContainedDotnet { get; }

        /// <summary>
        /// Whether to search the .Net framework directory.
        /// </summary>
        bool ScanNetFrameworkDlls { get; }

        /// <summary>
        /// Determine whether the given path should be excluded.
        /// </summary>
        /// <param name="path">The path to query.</param>
        /// <returns>True iff the path matches an exclusion.</returns>
        bool ExcludesFile(string path);

        /// <summary>
        /// The number of threads to use.
        /// </summary>
        int Threads { get; }
    }

    public class DependencyOptions : IDependencyOptions
    {
        public static IDependencyOptions Default => new DependencyOptions();

        public IList<string> DllDirs { get; set; } = new List<string>();

        public IList<string> Excludes { get; set; } = new List<string>();

        public bool UseNuGet { get; set; } = true;

        public string? SolutionFile { get; set; }

        public bool UseSelfContainedDotnet { get; set; } = false;

        public bool ScanNetFrameworkDlls { get; set; } = true;

        public bool ExcludesFile(string path) =>
            Excludes.Any(path.Contains);

        public int Threads { get; set; } = EnvironmentVariables.GetDefaultNumberOfThreads();
    }
}
