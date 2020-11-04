using Microsoft.Build.Construction;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Access data in a .sln file.
    /// </summary>
    internal class SolutionFile
    {
        private readonly Microsoft.Build.Construction.SolutionFile solutionFile;

        private string FullPath { get; }

        /// <summary>
        /// Read the file.
        /// </summary>
        /// <param name="filename">The filename of the .sln.</param>
        public SolutionFile(string filename)
        {
            // SolutionFile.Parse() expects a rooted path.
            FullPath = Path.GetFullPath(filename);
            solutionFile = Microsoft.Build.Construction.SolutionFile.Parse(FullPath);
        }

        /// <summary>
        /// Projects directly included in the .sln file.
        /// </summary>
        public IEnumerable<string> MsBuildProjects
        {
            get
            {
                return solutionFile.ProjectsInOrder
                    .Where(p => p.ProjectType == SolutionProjectType.KnownToBeMSBuildFormat)
                    .Select(p => p.AbsolutePath)
                    .Select(p => Path.DirectorySeparatorChar == '/' ? p.Replace("\\", "/") : p);
            }
        }

        /// <summary>
        /// Projects included transitively via a subdirectory.
        /// </summary>
        public IEnumerable<string> NestedProjects
        {
            get
            {
                return solutionFile.ProjectsInOrder
                    .Where(p => p.ProjectType == SolutionProjectType.SolutionFolder)
                    .Where(p => Directory.Exists(p.AbsolutePath))
                    .SelectMany(p => new DirectoryInfo(p.AbsolutePath).EnumerateFiles("*.csproj", SearchOption.AllDirectories))
                    .Select(f => f.FullName);
            }
        }

        /// <summary>
        /// List of projects which were mentioned but don't exist on disk.
        /// </summary>
        public IEnumerable<string> MissingProjects
        {
            get
            {
                // Only projects in the solution file can be missing.
                // (NestedProjects are located on disk so always exist.)
                return MsBuildProjects.Where(p => !File.Exists(p));
            }
        }

        /// <summary>
        /// The list of project files.
        /// </summary>
        public IEnumerable<string> Projects => MsBuildProjects.Concat(NestedProjects);
    }
}
