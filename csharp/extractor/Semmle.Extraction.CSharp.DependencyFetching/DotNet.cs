using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal partial class DotNet : IDotNet
    {
        private readonly IDotNetCliInvoker dotnetCliInvoker;
        private readonly ILogger logger;
        private readonly TemporaryDirectory? tempWorkingDirectory;

        private DotNet(IDotNetCliInvoker dotnetCliInvoker, ILogger logger, TemporaryDirectory? tempWorkingDirectory = null)
        {
            this.logger = logger;
            this.tempWorkingDirectory = tempWorkingDirectory;
            this.dotnetCliInvoker = dotnetCliInvoker;
            Info();
        }

        private DotNet(IDependencyOptions options, ILogger logger, TemporaryDirectory tempWorkingDirectory) : this(new DotNetCliInvoker(logger, Path.Combine(options.DotNetPath ?? string.Empty, "dotnet")), logger, tempWorkingDirectory) { }

        internal static IDotNet Make(IDotNetCliInvoker dotnetCliInvoker, ILogger logger) => new DotNet(dotnetCliInvoker, logger);

        public static IDotNet Make(IDependencyOptions options, ILogger logger, TemporaryDirectory tempWorkingDirectory) => new DotNet(options, logger, tempWorkingDirectory);

        private void Info()
        {
            // TODO: make sure the below `dotnet` version is matching the one specified in global.json
            var res = dotnetCliInvoker.RunCommand("--info");
            if (!res)
            {
                throw new Exception($"{dotnetCliInvoker.Exec} --info failed.");
            }
        }

        private string GetRestoreArgs(RestoreSettings restoreSettings)
        {
            var args = $"restore --no-dependencies \"{restoreSettings.File}\" --packages \"{restoreSettings.PackageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal";

            if (restoreSettings.ForceDotnetRefAssemblyFetching)
            {
                // Ugly hack: we set the TargetFrameworkRootPath and NetCoreTargetingPackRoot properties to an empty folder:
                var path = ".empty";
                if (tempWorkingDirectory != null)
                {
                    path = Path.Combine(tempWorkingDirectory.ToString(), "emptyFakeDotnetRoot");
                    Directory.CreateDirectory(path);
                }

                args += $" /p:TargetFrameworkRootPath=\"{path}\" /p:NetCoreTargetingPackRoot=\"{path}\"";
            }

            if (restoreSettings.PathToNugetConfig != null)
            {
                args += $" --configfile \"{restoreSettings.PathToNugetConfig}\"";
            }

            if (restoreSettings.ForceReevaluation)
            {
                args += " --force";
            }

            return args;
        }

        public RestoreResult Restore(RestoreSettings restoreSettings)
        {
            var args = GetRestoreArgs(restoreSettings);
            var success = dotnetCliInvoker.RunCommand(args, out var output);
            return new(success, output);
        }

        public bool New(string folder)
        {
            var args = $"new console --no-restore --output \"{folder}\"";
            return dotnetCliInvoker.RunCommand(args);
        }

        public bool AddPackage(string folder, string package)
        {
            var args = $"add \"{folder}\" package \"{package}\" --no-restore";
            return dotnetCliInvoker.RunCommand(args);
        }

        public IList<string> GetListedRuntimes() => GetListed("--list-runtimes", "runtime");

        public IList<string> GetListedSdks() => GetListed("--list-sdks", "SDK");

        private IList<string> GetListed(string args, string artifact)
        {
            if (dotnetCliInvoker.RunCommand(args, out var artifacts))
            {
                return artifacts;
            }
            return new List<string>();
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return dotnetCliInvoker.RunCommand(args);
        }
    }
}
