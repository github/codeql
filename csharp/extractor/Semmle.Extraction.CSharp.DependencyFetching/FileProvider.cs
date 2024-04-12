using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Policy;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class FileProvider
    {
        private static readonly HashSet<string> binaryFileExtensions = [".dll", ".exe"]; // TODO: add more binary file extensions.

        private readonly ILogger logger;
        private readonly FileInfo[] all;
        private readonly Lazy<FileInfo[]> allNonBinary;
        private readonly Lazy<string[]> smallNonBinary;
        private readonly Lazy<string[]> sources;
        private readonly Lazy<string[]> projects;
        private readonly Lazy<string[]> solutions;
        private readonly Lazy<string[]> dlls;
        private readonly Lazy<string[]> nugetConfigs;
        private readonly Lazy<string[]> globalJsons;
        private readonly Lazy<string[]> razorViews;
        private readonly Lazy<string?> rootNugetConfig;

        public FileProvider(DirectoryInfo sourceDir, ILogger logger)
        {
            SourceDir = sourceDir;
            this.logger = logger;

            all = GetAllFiles();
            allNonBinary = new Lazy<FileInfo[]>(() => all.Where(f => !binaryFileExtensions.Contains(f.Extension.ToLowerInvariant())).ToArray());
            smallNonBinary = new Lazy<string[]>(() =>
            {
                var ret = SelectSmallFiles(allNonBinary.Value).SelectFileNames().ToArray();
                logger.LogInfo($"Found {ret.Length} small non-binary files in {SourceDir}.");
                return ret;
            });
            sources = new Lazy<string[]>(() => SelectTextFileNamesByExtension("source", ".cs"));
            projects = new Lazy<string[]>(() => SelectTextFileNamesByExtension("project", ".csproj"));
            solutions = new Lazy<string[]>(() => SelectTextFileNamesByExtension("solution", ".sln"));
            dlls = new Lazy<string[]>(() => SelectBinaryFileNamesByExtension("DLL", ".dll"));
            nugetConfigs = new Lazy<string[]>(() => allNonBinary.Value.SelectFileNamesByName("nuget.config").ToArray());
            globalJsons = new Lazy<string[]>(() => allNonBinary.Value.SelectFileNamesByName("global.json").ToArray());
            razorViews = new Lazy<string[]>(() => SelectTextFileNamesByExtension("razor view", ".cshtml", ".razor"));

            rootNugetConfig = new Lazy<string?>(() => all.SelectRootFiles(SourceDir).SelectFileNamesByName("nuget.config").FirstOrDefault());
        }

        private string[] SelectTextFileNamesByExtension(string filetype, params string[] extensions)
        {
            var ret = allNonBinary.Value.SelectFileNamesByExtension(extensions).ToArray();
            logger.LogInfo($"Found {ret.Length} {filetype} files in {SourceDir}.");
            return ret;
        }

        private string[] SelectBinaryFileNamesByExtension(string filetype, params string[] extensions)
        {
            var ret = all.SelectFileNamesByExtension(extensions).ToArray();
            logger.LogInfo($"Found {ret.Length} {filetype} files in {SourceDir}.");
            return ret;
        }

        private IEnumerable<FileInfo> SelectSmallFiles(IEnumerable<FileInfo> files)
        {
            const int oneMb = 1_048_576;
            return files.Where(file =>
            {
                if (file.Length > oneMb)
                {
                    logger.LogDebug($"Skipping {file.FullName} because it is bigger than 1MB.");
                    return false;
                }
                return true;
            });
        }

        private FileInfo[] GetAllFiles()
        {
            logger.LogInfo($"Finding files in {SourceDir}...");
            var files = SourceDir.GetFiles("*.*", new EnumerationOptions { RecurseSubdirectories = true });

            var filteredFiles = files.Where(f =>
            {
                try
                {
                    if (f.Exists)
                    {
                        return true;
                    }

                    logger.LogWarning($"File {f.FullName} could not be processed.");
                    return false;
                }
                catch (Exception ex)
                {
                    logger.LogWarning($"File {f.FullName} could not be processed: {ex.Message}");
                    return false;
                }
            });

            var allFiles = new FilePathFilter(SourceDir, logger).Filter(filteredFiles).ToArray();

            logger.LogInfo($"Found {allFiles.Length} files in {SourceDir}.");
            return allFiles;
        }

        public DirectoryInfo SourceDir { get; }
        public IEnumerable<string> SmallNonBinary => smallNonBinary.Value;
        public IEnumerable<string> Sources => sources.Value;
        public ICollection<string> Projects => projects.Value;
        public ICollection<string> Solutions => solutions.Value;
        public IEnumerable<string> Dlls => dlls.Value;
        public ICollection<string> NugetConfigs => nugetConfigs.Value;
        public string? RootNugetConfig => rootNugetConfig.Value;
        public IEnumerable<string> GlobalJsons => globalJsons.Value;
        public ICollection<string> RazorViews => razorViews.Value;
    }
}
