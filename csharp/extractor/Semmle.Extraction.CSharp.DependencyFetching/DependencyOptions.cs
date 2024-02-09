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
        /// The number of threads to use.
        /// </summary>
        int Threads { get; }

        /// <summary>
        /// The path to the local ".dotnet" directory, if any.
        /// </summary>
        string? DotNetPath { get; }
    }

    public class DependencyOptions : IDependencyOptions
    {
        public static IDependencyOptions Default => new DependencyOptions();

        public int Threads { get; set; } = EnvironmentVariables.GetDefaultNumberOfThreads();

        public string? DotNetPath { get; set; } = null;
    }
}
