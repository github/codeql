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
        private readonly TemporaryDirectory? tempWorkingDirectory;

        private DotNet(IDotNetCliInvoker dotnetCliInvoker, ILogger logger, TemporaryDirectory? tempWorkingDirectory = null)
        {
            this.tempWorkingDirectory = tempWorkingDirectory;
            this.dotnetCliInvoker = dotnetCliInvoker;
            Info();
        }

        private DotNet(ILogger logger, string? dotNetPath, TemporaryDirectory tempWorkingDirectory) : this(new DotNetCliInvoker(logger, Path.Combine(dotNetPath ?? string.Empty, "dotnet")), logger, tempWorkingDirectory) { }

        internal static IDotNet Make(IDotNetCliInvoker dotnetCliInvoker, ILogger logger) => new DotNet(dotnetCliInvoker, logger);

        public static IDotNet Make(ILogger logger, string? dotNetPath, TemporaryDirectory tempWorkingDirectory) => new DotNet(logger, dotNetPath, tempWorkingDirectory);

        private void Info()
        {
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

        // The version number should be kept in sync with the version .NET version used for building the application.
        public const string LatestDotNetSdkVersion = "8.0.101";

        /// <summary>
        /// Returns a script for downloading relevant versions of the
        /// .NET SDK. The SDK(s) will be installed at <code>installDir</code>
        /// (provided that the script succeeds).
        /// </summary>
        private static BuildScript DownloadDotNet(IBuildActions actions, ILogger logger, IEnumerable<string> files, string tempWorkingDirectory, bool shouldCleanUp, string installDir, string? version, bool ensureDotNetAvailable)
        {
            if (!string.IsNullOrEmpty(version))
                // Specific version requested
                return DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, version);

            // Download versions mentioned in `global.json` files
            // See https://docs.microsoft.com/en-us/dotnet/core/tools/global-json
            var installScript = BuildScript.Success;
            var validGlobalJson = false;

            foreach (var path in files.Where(p => p.EndsWith("global.json", StringComparison.Ordinal)))
            {
                try
                {
                    var o = JObject.Parse(File.ReadAllText(path));
                    version = (string)(o?["sdk"]?["version"]!);
                }
                catch
                {
                    // not a valid global.json file
                    continue;
                }

                installScript &= DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, version);
                validGlobalJson = true;
            }

            if (validGlobalJson)
            {
                return installScript;
            }

            if (ensureDotNetAvailable)
            {
                return DownloadDotNetVersion(actions, logger, tempWorkingDirectory, shouldCleanUp, installDir, LatestDotNetSdkVersion, needExactVersion: false);
            }

            return BuildScript.Failure;
        }

        /// <summary>
        /// Returns a script for downloading a specific .NET SDK version, if the
        /// version is not already installed.
        ///
        /// See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script.
        /// </summary>
        private static BuildScript DownloadDotNetVersion(IBuildActions actions, ILogger logger, string tempWorkingDirectory, bool shouldCleanUp, string path, string version, bool needExactVersion = true)
        {
            return BuildScript.Bind(GetInstalledSdksScript(actions), (sdks, sdksRet) =>
                {
                    if (needExactVersion && sdksRet == 0 && sdks.Count == 1 && sdks[0].StartsWith(version + " ", StringComparison.Ordinal))
                    {
                        // The requested SDK is already installed (and no other SDKs are installed), so
                        // no need to reinstall
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

                    logger.LogInfo($"Attempting to download .NET {version}");

                    if (actions.IsWindows())
                    {

                        var psCommand = $"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Version {version} -InstallDir {path}";

                        BuildScript GetInstall(string pwsh) =>
                            new CommandBuilder(actions).
                            RunCommand(pwsh).
                            Argument("-NoProfile").
                            Argument("-ExecutionPolicy").
                            Argument("unrestricted").
                            Argument("-Command").
                            Argument("\"" + psCommand + "\"").
                            Script;

                        return GetInstall("pwsh") | GetInstall("powershell");
                    }
                    else
                    {
                        var dotnetInstallPath = actions.PathCombine(tempWorkingDirectory, ".dotnet", "dotnet-install.sh");

                        var downloadDotNetInstallSh = BuildScript.DownloadFile(
                            "https://dot.net/v1/dotnet-install.sh",
                            dotnetInstallPath,
                            e => logger.LogWarning($"Failed to download 'dotnet-install.sh': {e.Message}"));

                        var chmod = new CommandBuilder(actions).
                            RunCommand("chmod").
                            Argument("u+x").
                            Argument(dotnetInstallPath);

                        var install = new CommandBuilder(actions).
                            RunCommand(dotnetInstallPath).
                            Argument("--channel").
                            Argument("release").
                            Argument("--version").
                            Argument(version).
                            Argument("--install-dir").
                            Argument(path);

                        var buildScript = downloadDotNetInstallSh & chmod.Script & install.Script;

                        if (shouldCleanUp)
                        {
                            buildScript &= BuildScript.DeleteFile(dotnetInstallPath);
                        }

                        return buildScript;
                    }
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