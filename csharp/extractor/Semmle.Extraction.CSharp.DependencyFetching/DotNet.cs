using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Newtonsoft.Json.Linq;

using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    public partial class DotNet : IDotNet
    {
        private readonly IDotNetCliInvoker dotnetCliInvoker;
        private readonly ILogger logger;
        private readonly TemporaryDirectory? tempWorkingDirectory;

        private DotNet(IDotNetCliInvoker dotnetCliInvoker, ILogger logger, bool runDotnetInfo, TemporaryDirectory? tempWorkingDirectory = null)
        {
            this.tempWorkingDirectory = tempWorkingDirectory;
            this.dotnetCliInvoker = dotnetCliInvoker;
            this.logger = logger;
            if (runDotnetInfo)
            {
                Info();
            }
        }

        private DotNet(ILogger logger, string? dotNetPath, TemporaryDirectory tempWorkingDirectory, DependabotProxy? dependabotProxy) : this(new DotNetCliInvoker(logger, Path.Combine(dotNetPath ?? string.Empty, "dotnet"), dependabotProxy), logger, dotNetPath is null, tempWorkingDirectory) { }

        internal static IDotNet Make(IDotNetCliInvoker dotnetCliInvoker, ILogger logger, bool runDotnetInfo) => new DotNet(dotnetCliInvoker, logger, runDotnetInfo);

        public static IDotNet Make(ILogger logger, string? dotNetPath, TemporaryDirectory tempWorkingDirectory, DependabotProxy? dependabotProxy) => new DotNet(logger, dotNetPath, tempWorkingDirectory, dependabotProxy);

        private void Info()
        {
            var res = dotnetCliInvoker.RunCommand("--info", silent: false);
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

            if (restoreSettings.TargetWindows)
            {
                args += " /p:EnableWindowsTargeting=true";
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

        public IList<string> GetListedRuntimes() => GetResultList("--list-runtimes");

        public IList<string> GetListedSdks() => GetResultList("--list-sdks");

        private IList<string> GetResultList(string args, string? workingDirectory = null, bool silent = true)
        {
            if (dotnetCliInvoker.RunCommand(args, workingDirectory, out var results, silent))
            {
                return results;
            }
            logger.LogWarning($"Running 'dotnet {args}' failed.");
            return [];
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return dotnetCliInvoker.RunCommand(args);
        }

        private const string nugetListSourceCommand = "nuget list source --format Short";

        public IList<string> GetNugetFeeds(string nugetConfig)
        {
            logger.LogInfo($"Getting Nuget feeds from '{nugetConfig}'...");
            return GetResultList($"{nugetListSourceCommand} --configfile \"{nugetConfig}\"");
        }

        public IList<string> GetNugetFeedsFromFolder(string folderPath)
        {
            logger.LogInfo($"Getting Nuget feeds in folder '{folderPath}'...");
            return GetResultList(nugetListSourceCommand, folderPath);
        }

        // The version number should be kept in sync with the version .NET version used for building the application.
        public const string LatestDotNetSdkVersion = "9.0.100";

        /// <summary>
        /// Returns a script for downloading relevant versions of the
        /// .NET SDK. The SDK(s) will be installed at <code>installDir</code>
        /// (provided that the script succeeds).
        /// </summary>
        private static BuildScript DownloadDotNet(IBuildActions actions, ILogger logger, IEnumerable<string> files, string tempWorkingDirectory, bool shouldCleanUp, string installDir, string? version, bool ensureDotNetAvailable)
        {
            if (!string.IsNullOrEmpty(version))
                // Specific version requested
                return DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, [version]);

            // Download versions mentioned in `global.json` files
            // See https://docs.microsoft.com/en-us/dotnet/core/tools/global-json
            var versions = new List<string>();

            foreach (var path in files.Where(p => string.Equals(FileUtils.SafeGetFileName(p, logger), "global.json", StringComparison.OrdinalIgnoreCase)))
            {
                try
                {
                    var o = JObject.Parse(File.ReadAllText(path));
                    var v = (string?)o?["sdk"]?["version"];
                    if (v is not null)
                    {
                        versions.Add(v);
                    }
                }
                catch
                {
                    // not a valid `global.json` file
                    logger.LogInfo($"Couldn't find .NET SDK version in '{path}'.");
                    continue;
                }
            }

            if (versions.Count > 0)
            {
                return
                    DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, versions) |
                    // if neither of the versions succeed, try the latest version
                    DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, [LatestDotNetSdkVersion], needExactVersion: false);
            }

            if (ensureDotNetAvailable)
            {
                return DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, [LatestDotNetSdkVersion], needExactVersion: false);
            }

            return BuildScript.Failure;
        }

        /// <summary>
        /// Returns a script for downloading specific .NET SDK versions, if the
        /// versions are not already installed.
        ///
        /// See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script.
        /// </summary>
        private static BuildScript DownloadDotNetVersion(IBuildActions actions, ILogger logger, string tempWorkingDirectory, bool shouldCleanUp, string path, IEnumerable<string> versions, bool needExactVersion = true)
        {
            if (!versions.Any())
            {
                logger.LogInfo("No .NET SDK versions requested.");
                return BuildScript.Failure;
            }

            return BuildScript.Bind(GetInstalledSdksScript(actions), (sdks, sdksRet) =>
            {
                if (
                    needExactVersion &&
                    sdksRet == 0 &&
                    // quadratic; should be OK, given that both `version` and `sdks` are expected to be small
                    versions.All(version => sdks.Any(sdk => sdk.StartsWith(version + " ", StringComparison.Ordinal))))
                {
                    // The requested SDKs are already installed, so no need to reinstall
                    return BuildScript.Failure;
                }
                else if (!needExactVersion && sdksRet == 0 && sdks.Count > 0)
                {
                    // there's at least one SDK installed, so no need to reinstall
                    return BuildScript.Failure;
                }
                else if (!needExactVersion && sdksRet != 0)
                {
                    logger.LogInfo("No .NET SDK found.");
                }

                BuildScript prelude;
                BuildScript postlude;
                Func<string, BuildScript> getInstall;

                if (actions.IsWindows())
                {
                    prelude = BuildScript.Success;
                    postlude = BuildScript.Success;

                    getInstall = version =>
                    {
                        var psCommand = $"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Version {version} -InstallDir {path}";

                        BuildScript GetInstall(string pwsh) =>
                            new CommandBuilder(actions).
                            RunCommand(pwsh).
                            Argument("-NoProfile").
                            Argument("-ExecutionPolicy").
                            Argument("unrestricted").
                            Argument("-Command").
                            Argument($"\"{psCommand}\"").
                            Script;

                        return GetInstall("pwsh") | GetInstall("powershell");
                    };
                }
                else
                {
                    var dotnetInstallPath = actions.PathCombine(tempWorkingDirectory, ".dotnet", "dotnet-install.sh");

                    var downloadDotNetInstallSh = BuildScript.DownloadFile(
                        "https://dot.net/v1/dotnet-install.sh",
                        dotnetInstallPath,
                        e => logger.LogWarning($"Failed to download 'dotnet-install.sh': {e.Message}"),
                        logger);

                    var chmod = new CommandBuilder(actions).
                        RunCommand("chmod").
                        Argument("u+x").
                        Argument(dotnetInstallPath);

                    prelude = downloadDotNetInstallSh & chmod.Script;
                    postlude = shouldCleanUp ? BuildScript.DeleteFile(dotnetInstallPath) : BuildScript.Success;

                    getInstall = version => new CommandBuilder(actions).
                        RunCommand(dotnetInstallPath).
                        Argument("--channel").
                        Argument("release").
                        Argument("--version").
                        Argument(version).
                        Argument("--install-dir").
                        Argument(path).Script;
                }

                var dotnetInfo = new CommandBuilder(actions).
                    RunCommand(actions.PathCombine(path, "dotnet")).
                    Argument("--info").Script;

                Func<string, BuildScript> getInstallAndVerify = version =>
                    // run `dotnet --info` after install, to check that it executes successfully
                    getInstall(version) & dotnetInfo;

                var installScript = prelude & BuildScript.Failure;

                var attempted = new HashSet<string>();
                foreach (var version in versions)
                {
                    if (!attempted.Add(version))
                        continue;

                    installScript = BuildScript.Bind(installScript, combinedExit =>
                    {
                        logger.LogInfo($"Attempting to download .NET {version}");

                        // When there are multiple versions requested, we want to try to fetch them all, reporting
                        // a successful exit code when at least one of them succeeds
                        return combinedExit != 0 ? getInstallAndVerify(version) : BuildScript.Bind(getInstallAndVerify(version), _ => BuildScript.Success);
                    });
                }

                return installScript & postlude;
            });
        }

        private static BuildScript GetInstalledSdksScript(IBuildActions actions)
        {
            var listSdks = new CommandBuilder(actions, silent: true).
                RunCommand("dotnet").
                Argument("--list-sdks");
            return listSdks.Script;
        }

        /// <summary>
        /// Returns a script that attempts to download relevant version(s) of the
        /// .NET SDK, followed by running the script generated by <paramref name="f"/>.
        ///
        /// The argument to <paramref name="f"/> is the path to the directory in which the
        /// .NET SDK(s) were installed.
        /// </summary>
        public static BuildScript WithDotNet(IBuildActions actions, ILogger logger, IEnumerable<string> files, string tempWorkingDirectory, bool shouldCleanUp, bool ensureDotNetAvailable, string? version, Func<string?, BuildScript> f)
        {
            var installDir = actions.PathCombine(tempWorkingDirectory, ".dotnet");
            var installScript = DownloadDotNet(actions, logger, files, tempWorkingDirectory, shouldCleanUp, installDir, version, ensureDotNetAvailable);
            return BuildScript.Bind(installScript, installed =>
            {
                if (installed != 0)
                {
                    // The .NET SDK was not installed, either because the installation failed or because it was already installed.
                    installDir = null;
                }

                return f(installDir);
            });
        }
    }
}
